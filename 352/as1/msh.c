/* CS 352 -- Mini Shell!  
 *
 *   Sept 21, 2000,  Phil Nelson
 *   Modified April 8, 2001 
 *   Modified January 6, 2003
 *
 */

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>


/* Constants */ 

#define LINELEN 1024

/* Prototypes */

char **arg_parse (char *line);
void processline (char *line);

/* Shell main */

int
main (void)
{
    char   buffer [LINELEN];
    int    len;

#if DEBUG
    char   **arg_it;
#endif
    
    while (1) {

        /* prompt and get line */
	fprintf (stderr, "%% ");
	if (fgets (buffer, LINELEN, stdin) != buffer)
	  break;

        /* Get rid of \n at end of buffer. */
	len = strlen(buffer);
	if (buffer[len-1] == '\n')
	    buffer[len-1] = 0;

	/* Run it ... */
	processline (buffer);

        /* testing argparse */
#if DEBUG
        arg_it = arg_parse(buffer);
        while ( *arg_it != (char *)0 ) 
            printf("%s\n", *(arg_it++));
#endif
        
    }

    if (!feof(stdin))
        perror ("read");

    return 0;		/* Also known as exit (0); */
}


void processline (char *line)
{
    pid_t  cpid;
    int    status;
    
    /* Start a new process to do the job. */
    cpid = fork();
    if (cpid < 0) {
      perror ("fork");
      return;
    }
    
    /* Check for who we are! */
    if (cpid == 0) {
      /* We are the child! */
      execlp (line, line, (char *)0);
      perror ("exec");
      exit (127);
    }
    
    /* Have the parent wait for child to complete */
    if (wait (&status) < 0)
      perror ("wait");
}


char **arg_parse (char *line)
{ 
    char **args, *c, **arg_it;
    int n_args=1, reading;

    /* determine number of args */
    c = line;
    reading = 1;
    do
    {
        if (reading && *c == ' ') {
            reading = 0;
            n_args++;
        } else if (!reading && *c != ' ') {
            reading = 1;
        }
    } while ( *(++c) );

    /* create array for args */
    args = (char **)malloc(n_args * sizeof(char *) + 1);
    if (!args)
        perror("malloc");

    /* partition args and store positions of first characters */
    arg_it = args;
    c = *(arg_it++) = line;
    reading = 1;
    do
    {
        if (reading && *c == ' ') {
            *c = 0;
            reading = 0;
        } else if (!reading && *c != ' ') {
            reading = 1;
            *(arg_it++) = c;
        }
    } while ( *(++c) );

    /* add null pointer to end of array */
    *arg_it = (char *)0;
    
    return args;
}
