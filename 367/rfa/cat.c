/* cat.c -- a simple cat program!
 *
 *   Usage:  cat [-o file] [files ...]
 *
 * Phil Nelson, February 21, 1997
 *    Modified Nov 2, 2005
 *
 */

#include <sys/types.h>
#include <sys/uio.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include "rfa.h"

int debug;

#define BUFSIZE 1024

/* Utility routine to copy a file given two file descriptors. */

void copyfile (int infd, int outfd)
{
    char buffer[BUFSIZE];
    size_t size;
    
    while ( (size = read (infd, buffer, BUFSIZE)) > 0 )
	if (write (outfd, buffer, size) != size)
	    {
		write (2, "Write problems\n", 15);
		exit (1);
	    }
    if (size < 0)
	{
	    write (2, "Read problems\n", 14);
	    exit (1);
	}
}

int main (int argc, char **argv)
{
    int i;
    int fd[argc];
    int outfd = 1;
    int ix;
    
    /* Process Option Arguments */
    ix = 1;
    if (argc > ix && argv[ix][0] == '-' && argv[ix][1] == 'd') {
	debug = 1;
	ix++;
    }
    if (argc > ix && argv[ix][0] == '-')
	{
	    if (argv[ix][1] == 'o' && argv[ix][2] == 0 && argc > 2)
		{
		    /* Open the output file. */
		    outfd = open (argv[ix+1], O_WRONLY|O_CREAT|O_TRUNC,
				  0777);
		    if (outfd < 0)
			{
			    write (2, "Can not open output file ", 25);
			    write (2, argv[ix+1], strlen(argv[ix+1]));
			    write (2, ".\n", 2);
			    exit (1);
			}
		    
		    /* Adjust argv/argc to ignore -o option. */
		    ix += 2;
		}
	    else if (strcmp(argv[ix], "-f") == 0)
	      {
		debug = 1;
	      }
	    else
		{
		    write (2, "Usage: ", 7);
		    write (2, argv[0], strlen(argv[0]));
		    write (2, " [-d] [-o file] [files ...]\n", 28);
			exit (1);
		}
	}
    
    if (argc == 1)
	{  /* Read from standard in! */
	    copyfile (0, outfd);
	}
    else
	{ /* For each argument, open the file, copy it to outfd, close it. */
	    for (i = ix; i < argc; i++)
		{
		    fd[i] = open (argv[i], O_RDONLY, 0);
		    if (fd[i] < 0)
			{
			    write (2, "Can not open file ", 18);
			    write (2, argv[i], strlen(argv[i]));
			    write (2, ".\n", 2);
			    exit (1);
			}
		    copyfile (fd[i], outfd);
		}
	    for (i = ix; i < argc; i++)
		close (fd[i]);
	}
    
    /* Done successfully */
    close(outfd);
    exit (0);
}
