/* Matt Forbes */
/* Server implemented RFA protocol */
   
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <fcntl.h>
#include "netlib.h"

#define BUFFSIZE 256
#define MAXCLIENT 20
#define MAXFD 20
#define DEFAULTPORT 18156
#define AUTH_FILE ".rfahosts"

/* debug flag */
int debug = 0;

/* from getopt */
extern char *optarg;
extern int optind;

/* structures */

/* simple linked list for hostnames */
struct str_list {
  char str[BUFFSIZE];
  struct str_list *next;
};
typedef struct str_list list;

/* globals */
list *authorized_hosts = NULL;

/* prototypes */
void usage(const char *);
void build_authorized_hosts(char *filename);
void handle_client(int conn);
void close_client(int conn, int *fds);
int open_request(char *request);
int authenticate(int conn);
int get_fd_ix(int *fds);
void tokenize(char *str, char **tokens);

void test();

/* entry */
int main (int argc, char **argv) {
  int port = DEFAULTPORT;
  int ch;
  int serv;
  int conn;
  int status;
  pid_t pid;
  
  /* process args */
  while((ch = getopt(argc, argv, "dp:")) != -1) {
    switch(ch) {
    case 'd':
      debug = 1;
      break;
    case 'p':
      port = atoi(optarg);
      break;
    case '?':
    default:
      usage(argv[0]);
    }
  }
  
  /* start as daemon */
  if (!debug) {
    daemon(1, 1);
  }

  /* build authorized hosts from file */
  build_authorized_hosts(AUTH_FILE);
  
  /* setup socket */
  serv = tcp4_server(INADDR_ANY, port, MAXCLIENT);
  if (serv < 0) {
    fprintf(stderr, "Error starting server, %s\n", strerror(errno));
    exit(1);
  }
  if (debug) {
    printf("Started server on port %d\n", port);
  }
  
  /* server loop */
  while(1) {

    /* accept connection from client */
    conn = accept(serv, NULL, NULL);
    if (conn < 0) {
      fprintf(stderr, "accept returned an error\n");
      exit(1);
    }
    if (debug) {
      printf("Connected to client\n");
    }
    
    /* fork to get a new process */
    pid = fork();
    if (pid == 0) {
      /* handle client when child process */
      handle_client(conn);
      _exit(0);
    }
       
    /* clean up zombies */
    while(wait3(&status, WNOHANG, 0) > 0);
  }
  
  return 0;
}


void usage(const char *progname) {
  fprintf(stderr, "Usage: %s [-d] [-p port]\n", progname);
  exit(1);
}

void build_authorized_hosts(char *filename) {
  FILE *f;
  list *iter, *tmp;
  char str[BUFFSIZE];
  int len;
  
  f = fopen(filename, "r");
  if (f == NULL) {
    fprintf(stderr, "Could not open authorized hosts file\n");
    exit(1);
  }

  while (fgets(str, BUFFSIZE, f) != NULL) {
    /* remove newline */
    len = strlen(str);
    if (str[len-1] == '\n')
      str[len-1] = '\0';

    tmp = (list *)malloc(sizeof(list));
    tmp->next = NULL;
    strncpy(tmp->str, str, BUFFSIZE);
    

    if (authorized_hosts == NULL) {
      iter = authorized_hosts = tmp;
    } else {
      iter->next = tmp;
      iter = tmp;
    }
    
  }
}

void test() {
  list *iter = authorized_hosts;
  int i=0;
  while (iter != NULL) {
    printf("%d: %s\n", ++i, iter->str);
    iter = iter->next;
  }
}

void handle_client(int conn) {
  int i;
  int allowed;
  int fd;
  int fd_ix;
  int fds[MAXFD];
  int bytes_read;
  int bytes_written;
  int len;
  int size;
  char buff[BUFFSIZE];
  char *fd_str;
  char *size_str;
  char *dyn_buffer;

  
  /* authenticate connection or die */
  allowed = authenticate(conn);

  /* look for grant request 'G' */
  recv_line(conn, buff, BUFFSIZE);
  if ('G' != buff[0] ) {
    if (debug) {
      printf("Client not following protocol; must send 'G' as first message\n");
    }
    close_client(conn, fds);
    return;
  }

  /* respond to grant access */
  if (!allowed) {
    if (debug) {
      printf("Access denied\n");
    }
    send_line(conn, "N");
    close_client(conn, fds);
    return;
  }

  send_line(conn, "Y");
  if (debug) {
    printf("Access granted\n");
  }

  /* initialize file descriptors */
  for( i=0; i<MAXFD; i++ ) {
    fds[i] = -1;
  }

  while( recv_line(conn, buff, BUFFSIZE) >= 0 ) {
    /* get next command */
    len = strlen(buff);
      
    if (debug) {
      printf("Client request: %s\n", buff);
    }

    switch(buff[0]) {
      
    case 'Q':
      if (debug) {
        printf("Client requesting disconnect\n");
      }
      close_client(conn, fds);
      return;
      break;

    case 'O':
      /* process open request */
      fd = open_request(buff);

      if (fd == -1) {
        snprintf(buff, BUFFSIZE, "N %d", errno);
      } else {
        /* get next fd */
        fd_ix = get_fd_ix(fds);
        fds[fd_ix] = fd;
        snprintf(buff, BUFFSIZE, "Y %d", fd_ix);
      }
      
      send_line(conn, buff);
      
      break;

    case 'R':

      /* process request string */
      i=1;
      while (buff[i] == ' ' && i < len) i++;
      
      /* get fd id */
      fd_str = buff + i;
      while (buff[i] != ' ' && i < len) i++;
      buff[i++] = 0;
      fd_ix = atoi(fd_str);

      while (buff[i] == ' ' && i < len) i++;
      
      /* get size requested */
      size_str = buff + i;
      while (buff[i] != ' ' && i < len) i++;
      buff[i++] = 0;
      size = atoi(size_str);
      
      
      fd = fds[fd_ix];
      if (fd == -1) {
        snprintf(buff, BUFFSIZE, "N %d", errno);
        send_line(conn, buff);
      } else {
        dyn_buffer = (char *)malloc(sizeof(char) * size);
        bytes_read = read(fd, dyn_buffer, size);
        snprintf(buff, BUFFSIZE, "Y %d", bytes_read);
        send_line(conn, buff);
        send(conn, dyn_buffer, bytes_read, 0);
        free(dyn_buffer);
      }
      
      break;

    case 'W':
      
      /* process request string */
      i=1;
      while (buff[i] == ' ' && i < len) i++;

      /* get fd id */
      fd_str = buff + i;
      while (buff[i] != ' ' && i < len) i++;
      buff[i++] = 0;
      fd_ix = atoi(fd_str);

      while (buff[i] == ' ' && i < len) i++;
      
      /* get size  */
      size_str = buff + i;
      while (buff[i] != ' ' && i < len) i++;
      buff[i++] = 0;
      size = atoi(size_str);

      while (buff[i] == ' ' && i < len) i++;

      
      fd = fds[fd_ix];
      if (fd == -1) {
        snprintf(buff, BUFFSIZE, "N %d", errno);
        send_line(conn, buff);
      } else {
        dyn_buffer = (char *)malloc(sizeof(char) * size);
        bytes_read = read(conn, dyn_buffer, size);
        bytes_written = write(fd, dyn_buffer, bytes_read);
        snprintf(buff, BUFFSIZE, "Y %d", bytes_written);
        send_line(conn, buff);
        free(dyn_buffer);
      }
      
      
      break;

    case 'C':

      /* process request */
      i=1;
      while (buff[i] == ' ' && i < len) i++;

            /* get fd id */
      fd_str = buff + i;
      while (buff[i] != ' ' && i < len) i++;
      buff[i++] = 0;
      fd_ix = atoi(fd_str);

      fd = fds[fd_ix];
      if (fd == -1) {
        snprintf(buff, BUFFSIZE, "N %d", errno);
      } else {
        close(fd);
        fds[fd_ix] = -1;
        snprintf(buff, BUFFSIZE, "Y");
      }

      send_line(conn, buff);
      break;
      
      
    default:
      if (debug) {
        printf("Unhandled command\n");
      }
      break;
    }
  }

}

void close_client(int conn, int *fds) {
  int i=0;
  shutdown(conn, SHUT_RDWR);
  for (; i<MAXFD; i++) {
    if (fds[i] >= 0) 
      close(fds[i]);
  }
}

int open_request(char *request) {
      char *name_len;
      char *name;
      char *flags_str;
      char *mode_str;
      mode_t mode;
      int flags;
      int i;

      /* tokenize request */
      i=1;
      while (request[i] == ' ') i++;
      
      /* get length */
      name_len = request + i;
      while (request[i] != ' ') i++;
      request[i++] = 0;
      
      /* get name */
      name = request + i;
      i += atoi(name_len);
      request[i++] = 0;

      while (request[i] == ' ') i++;

      /* get flags */
      flags_str = request + i;
      while (request[i] != ' ') i++;
      request[i++] = 0;
      
      while (request[i] == ' ') i++;
      
      /* get mode */
      mode_str = request + i;
      while (request[i] != ' ') i++;
      request[i++] = 0;
      mode = strtol(mode_str, NULL, 8);

      /* done processing request */
      
      /* build flags */
      flags = 0;
      if (strchr(flags_str, 'R') != 0) {
        if (strchr(flags_str, 'W') != 0) {
          flags = O_RDWR;
        } else {
          flags = O_RDONLY;
        }
      } else if (strchr(flags_str, 'W') != 0) {
        flags = O_WRONLY;
      } else {
        /* error */
        /* /usr/include/sys/errno.h */
      }
      
      
      /* optionals */
      if (strchr(flags_str, 'A') != NULL)
        flags |= O_APPEND;
      if (strchr(flags_str, 'C') != NULL)
        flags |= O_CREAT;
      if (strchr(flags_str, 'T') != NULL)
        flags |= O_TRUNC;
      if (strchr(flags_str, 'E') != NULL)
        flags |= O_EXCL;

      /* make sure we have legal filename */
      if ( strstr(name, "..") != NULL
           || name[0] == '/') {
        return -1;
      }


      return open(name, flags, mode);
      
}


int authenticate(int conn) {
  char hostname[BUFFSIZE];
  in_addr_t ip;
  list *iter;
  
  ip = peer_ip(conn);
  dns_rlookup(ip, hostname, BUFFSIZE);

  /* make sure hostname resolved */
  if (strcmp("", hostname) == 0) {
    if (debug) {
      printf("Could not resolve hostname\n");
    }
    return 0;
  }
  
  if (debug) {
    printf("Connection from %s@%s\n", 
           hostname, 
           inet_ntoa(*(struct in_addr *)&ip));
  }

  iter = authorized_hosts;
  while (iter != NULL) {
    if (strncmp(iter->str, hostname, BUFFSIZE) == 0)
      return 1;
    iter = iter->next;
  }

  return 0;
}

int get_fd_ix(int *fds) {
  int i=0;
  for (; i<MAXFD; i++) {
    if (fds[i] == -1)
      return i;
  }
  return -1;
}
