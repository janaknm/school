/* RFA Protocol Client Library
   Matt Forbes - CS367
*/

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include "netlib.h"

#define BUFFSIZE 256
#define MAXFD 250
#define MAXHOST 10
#define DEFAULTPORT 18156
#define FDOFFSET 1000000

extern int errno;

/* host: holds information about connected remote host */
typedef struct {
  char hostname[BUFFSIZE];
  int port;
  int open_files;
  int sockfd;
} host;

/* file_d: remote file descriptor translation */
typedef struct {
  host *server;
  int fd;
} file_d;

/* pathinfo: information about a RFA-style path */
typedef struct {
  int is_remote;
  int port;
  char hostname[BUFFSIZE];
  char filename[BUFFSIZE];
} pathinfo;

/* global containers */
file_d remote_fds[MAXFD];
host remote_hosts[MAXHOST];

/* state variables */
int initialized = 0;

/* local prototypes */
pathinfo parse_path(const char *path);
void try_initialize();
host *get_host(char *hostname, int port);
void close_host(host *h);
void quit();

pathinfo parse_path(const char *path) {
  pathinfo info;
  char copy[BUFFSIZE];
  char *ptr;
  
  /* clear out */
  bzero((void *)&info, sizeof(pathinfo));
  
  /* make a copy so we can edit it */
  strncpy(copy, path, BUFFSIZE);
  
  /* try to find colon */
  ptr = strchr(copy, ':');
  if (ptr == NULL) {
    info.is_remote = 0;
    strncpy(info.filename, copy, BUFFSIZE);
    return info;
  }

  /* colon was found, it's a remote location */
  info.is_remote = 1;
  
  /* filename is everything after the colon, server info before it */
  *ptr = '\0';
  ptr++;
  strncpy(info.filename, ptr, BUFFSIZE);
  
  ptr = strchr(copy, '@');
  if (ptr == NULL) {
    info.port = DEFAULTPORT;
    strncpy(info.hostname, copy, BUFFSIZE);
    return info;
  }

  /* @ found, there is a port we need to read */
  *ptr = '\0';
  ptr++;
  strncpy(info.hostname, ptr, BUFFSIZE);
  info.port = atoi(copy);
  return info;
}

inline void try_initialize() {
  int i;
  
  if (initialized) return;
  
  initialized = 1;
  
  for ( i=0; i<MAXHOST; i++ ) {
    remote_hosts[i].sockfd = -1;
  }

  for ( i=0; i<MAXFD; i++ ) {
    remote_fds[i].fd = -1;
  }
  
}

host *get_host(char *hostname, int port) {
  host *h;
  in_addr_t addr;
  char response[BUFFSIZE];
  int found = 0;;
  int i;

  /* make sure globals set */
  try_initialize();

  for ( i=0; i<MAXHOST; i++) {
    
    /* find next available host */
    if (!found && remote_hosts[i].sockfd == -1) {
      h = &remote_hosts[i];
    }
    
    /* check if already connected to host */
    if ( remote_hosts[i].sockfd > 0
         && (strcmp(remote_hosts[i].hostname, hostname)) == 0
         && remote_hosts[i].port == port) {
      
      /* connection exists */
      return &remote_hosts[i];
    }
  }

  /* try opening connection, or return null */
  addr = dns_lookup(hostname);
  if (addr == 0) {
    /* ERROR */
    return NULL;
  }

  h->sockfd = tcp4_connect(addr, port);
  if (h->sockfd < 0) {
    /* ERROR */
    return NULL;
  }
  
  /* set properties on the host struct */
  strncpy(h->hostname, hostname, BUFFSIZE);
  h->port = port;
  h->open_files = 0;


  /* now we're connected, try to get granted access */
  send_line(h->sockfd, "G");

  /* get grant response */
  recv_line(h->sockfd, response, BUFFSIZE);

  /* make sure we have access */
  if (response[0] == 'N') {
    /* ERROR - bad access*/
    errno = atoi(response+1);
    
    close_host(h);
    return NULL;
    
  } else if (response[0] == 'Y') {
    return h;
    
  } else {
    /* ERROR (weird response from host) */
    return NULL;
  }
  
}

void close_host(host *h) {
  send_line(h->sockfd, "Q");
  shutdown(h->sockfd, SHUT_RDWR);
  
  /* clear out host info */
  h->hostname[0] = '\0';
  h->port = -1;
  h->open_files = 0;
  h->sockfd = -1;
}

void quit() {
  int i;
  
  for ( i=0; i<MAXHOST; i++ ) {
    if (remote_hosts[i].sockfd > 0) {
      close_host(&remote_hosts[i]);
    }
  }
  
}

/* LIBRARY FUNCTIONS */

/* open on remote machine if hostname present, otherwise
   use standard open call
*/
int rfa_open(const char *path, int flags, mode_t mode) {
  pathinfo info;
  host *h;
  file_d *remote_fd;
  char flags_str[BUFFSIZE];
  char buffer[BUFFSIZE];
  char *ptr;
  int sockfd;
  int i;
  int fd;
  
  /* make sure we're initialized */
  try_initialize();

  /* pull info out of pathname */
  info = parse_path(path);

  /* it is a local file */
  if (!info.is_remote) {
    return open(path, flags, mode);
  }

  /* it is a remote file */
  h = get_host(info.hostname, info.port);
  if (h == NULL) {
    /* ERROR (can't connect to host) */
    return -1;
  }

  sockfd = h->sockfd;
  
  /* create flags str */
  i = 0;

  switch(flags & O_ACCMODE) {
    case O_RDONLY:
      flags_str[i++] = 'R';
      break;
    case O_WRONLY:
      flags_str[i++] = 'W';
      break;
    case O_RDWR:
      flags_str[i++] = 'R';
      flags_str[i++] = 'W';
      break;
  }
  
  if (flags & O_APPEND) flags_str[i++] = 'A';
  if (flags & O_CREAT) flags_str[i++] = 'C';
  if (flags & O_TRUNC) flags_str[i++] = 'T';
  if (flags & O_EXCL) flags_str[i++] = 'E';
  flags_str[i] = '\0';

  snprintf(buffer, BUFFSIZE, "O %d %s %s %o ", 
           strlen(info.filename),
           info.filename,
           flags_str,
           mode);

  /* send the request */
  send_line(sockfd, buffer);

  /* get the response */
  recv_line(sockfd, buffer, BUFFSIZE);

  /* check to see we got a valid response */
  if (buffer[0] == 'N') {
    /* ERROR */
    errno = atoi(buffer+1);
    
    return -1;
  }

  /* get response fd */
  ptr = buffer + 2;
  fd = -1;
  fd = atoi(ptr);

  if (fd == -1) {
    /* ERROR */
    return -1;
  }

  /* get the next remote fd slot */
  for ( i=0; i<MAXFD; i++) {
    if (remote_fds[i].fd < 0) {
      remote_fd = &remote_fds[i];
      break;
    }
  }

  /* note: we got the remote_fd at index i */
  remote_fd->fd = fd;
  remote_fd->server = h;

  h->open_files++;
  
  return FDOFFSET + i;
}

ssize_t rfa_read(int d, void *buf, size_t nbytes) {
  file_d *remote_fd;
  host *h;
  char buffer[BUFFSIZE];
  int size;
  
  /* check for local file */
  if (d < FDOFFSET) {
    return read(d, buf, nbytes);
  }
  
  try_initialize();

  remote_fd = &remote_fds[d-FDOFFSET];
  h = remote_fd->server;
  
  if (h->sockfd < 0) {
    /* ERROR */
    printf("unhandled error: trying to read from file that isn't open\n");
    return -1;
  }

  /* make read request */
  snprintf(buffer, BUFFSIZE, "R %d %d", remote_fd->fd, nbytes);
  send_line(h->sockfd, buffer);
  
  /* get first response */
  recv_line(h->sockfd, buffer, BUFFSIZE);
  if (buffer[0] == 'N') {
    /* ERROR */
    errno = atoi(buffer+1);
    return -1;
    
  } else if (buffer[0] != 'Y') {
    /* ERROR */
    return -1;
  }

  /* good to read */
  size = atoi(buffer+2);
  if (size > nbytes) size = nbytes;
  return recv(h->sockfd, buf, size, 0);
}

ssize_t  rfa_write(int d, const void *buf, size_t nbytes) {
  file_d *remote_fd;
  host *h;
  char buffer[BUFFSIZE];
  int val;
  
  /* check for local file */
  if (d < FDOFFSET) {
    return write(d, buf, nbytes);
  }

  try_initialize();

  remote_fd = &remote_fds[d-FDOFFSET];
  h = remote_fd->server;

  if (h->sockfd < 0) {
    /* ERROR */
    printf("unhandled error: trying to read from file that isn't open\n");
    return -1;
  }

  /* make write request */
  snprintf(buffer, BUFFSIZE, "W %d %d", remote_fd->fd, nbytes);
  send_line(h->sockfd, buffer);

  send(h->sockfd, buf, nbytes, 0);

  /* get return value */
  recv_line(h->sockfd, buffer, BUFFSIZE);
  if (buffer[0] == 'N') {
    /* ERROR */
    errno = atoi(buffer+1);
    return -1;
    
  } else if (buffer[0] != 'Y') {
    /* ERROR */
    return -1;
  }

  /* return value */
  val = atoi(buffer+2);
  
  return val;
}

int rfa_close(int d) {
  file_d *remote_fd;
  host *h;
  char buffer[BUFFSIZE];
  
  /* check if it's a local file */
  if (d < FDOFFSET) {
    return close(d);
  }

  try_initialize();

  remote_fd = &remote_fds[d-FDOFFSET];
  h = remote_fd->server;
  
  if (h->sockfd < 0) {
    /* ERROR */
    printf("unhandled error: trying to close file that isn't open\n");
    return -1;
  }

  h->open_files--;

  /* tell the server to close the file */
  snprintf(buffer, BUFFSIZE, "C %d", remote_fd->fd);
  send_line(h->sockfd, buffer);

  /* get response */
  recv_line(h->sockfd, buffer, BUFFSIZE);
  if (buffer[0] == 'Y') {
    h->open_files--;

    /* if we don't have any more open files, close connection */
    if (h->open_files == 0) {
      close_host(h);
    }
    return 0;
    
  } else if (buffer[0] == 'N') {
    /* ERROR */
    errno = atoi(buffer+1);
    return -1;
    
  } else {
    /* ERROR */
    return -1;
    
  }
  
}

/* if we're testing, create an executable to run tests */
#ifdef DEBUG
void test_pathinfo();
void test_connect();
void test_open();
void test_open_file(char *s);
void print_pathinfo(pathinfo info);
void print_host(host *h);

void print_pathinfo(pathinfo info) {
  printf("is_remote: %d\nfilename: %s\nhostname: %s\nport: %d\n\n", 
         info.is_remote,
         info.filename,
         info.hostname,
         info.port);
}

void print_host(host *h) {
  if (h == NULL) {
    printf("host: NULL\n\n");
    return;
  }
  
  printf("hostname: %s\nport: %d\nopen_files: %d\nsockfd: %d\n\n",
         h->hostname,
         h->port,
         h->open_files,
         h->sockfd);
}

void test_pathinfo() {
  char *s1 = "local_name.file";
  char *s2 = "server:remote_name.file";
  char *s3 = "123@server.com:remote_name.file";
  pathinfo info;
  
  printf("parsing %s:\n", s1);
  info = parse_path(s1);
  print_pathinfo(info);
  
  printf("parsing %s:\n", s2);
  info = parse_path(s2);
  print_pathinfo(info);

  printf("parsing %s:\n", s3);
  info = parse_path(s3);
  print_pathinfo(info);
  
}

void test_connect() {
  char hostname[BUFFSIZE];
  host *h;
  
  printf("opening first connection to sister...\n");
  strncpy(hostname, "sister", BUFFSIZE);
  h = get_host(hostname, 18156);
  print_host(h);

  printf("opening first connection to whistler on wrong port...\n");
  strncpy(hostname, "whistler", BUFFSIZE);
  h = get_host(hostname, 18156);
  print_host(h);

  printf("retry connection to whistler with correct port...\n");
  strncpy(hostname, "whistler", BUFFSIZE);
  h = get_host(hostname, 15555);
  print_host(h);

  printf("try to connect to sister, should reuse host...\n");
  strncpy(hostname, "sister", BUFFSIZE);
  h = get_host(hostname, 18156);
  print_host(h);

  printf("connect to whistler on correct port again...\n");
  strncpy(hostname, "whistler", BUFFSIZE);
  h = get_host(hostname, 15555);
  print_host(h);
  
}

void test_open_close() {
  char *strings[] = {"local.file",
                     "sister:remote.file",
                     "11111@sister:remote.file",
                     "sister:remote2.file",
                     "whistler:remote.file",
                     "15555@whistler:remote.file",
                     "15555@whistler:remote.file",
                     "15555@whistler:local.file"};
  int fds[8];
  int i;

  for ( i=0; i<8; i++ ) {
    printf("opening file: %s\n", strings[i]);
    fds[i] = rfa_open(strings[i], O_RDONLY, 0700);

    printf("received fd %d from server\n", fds[i]);

    printf("attempting to close... ");
    printf("return code: %d\n\n", rfa_close(fds[i]));
  }
  
}

void test_read_write_file(char *s) {
    char buffer[1024];
    int fd;
    int ret;
  
    snprintf(buffer, 1024, "some test data for file named %s\ndone.", s);
    
    /* write */
    printf("opening %s\n", s);
    fd = rfa_open(s, O_WRONLY | O_CREAT | O_TRUNC, 0700);
    printf("got fd: %d\n", fd);
    printf("going to write %d bytes to file...\n", strlen(buffer));
    ret = rfa_write(fd, buffer, strlen(buffer));
    printf("return value: %d\n", ret);
    printf("closing file...\n");
    rfa_close(fd);

    /* read */
    printf("opening %s\n", s);
    fd = rfa_open(s, O_RDONLY, 0700);
    printf("got fd: %d\n", fd);
    printf("reading 1024 bytes from file...\n");
    ret = rfa_read(fd, buffer, 1024);
    printf("read %d bytes from file\n", ret);
    printf("file contents: %s\n", buffer);
    printf("closing file...\n\n");
    rfa_close(fd);

    
}

void test_read_write() {
  char *strings[] = {"local.file",
                     "sister:remote.file",
                     "15555@whistler:remote.file" };
  int i;
  
  for ( i=0; i<3; i++ ){ 
    test_read_write_file(strings[i]);
  }
  
}

int main(int argc, char **argv) {
  /* test parsing paths */
  printf("*** running tests on path infos...   \n");
  test_pathinfo();

  printf("*** running tests on host connections...  \n");
  test_connect();

  printf("*** running tests on opening/closing files... \n");
  test_open_close();

  printf("*** running tests on reading/writing files... \n");
  test_read_write();
  
  quit();
  
  return 0;
}
#endif

