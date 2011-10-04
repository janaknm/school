#include <stdio.h>
#include <stdlib.h>

#include "proto.h"


/* parses a line read from shell into individual args. */
int arg_parse(char *line, char ***argvp)
{ 
    char   *c, *ptr;
    char   **it;
    int    argc = 0, reading = 0;
    
    /* determine number of args */
    ptr = line;
    while ( *ptr ) {
        /* eat spaces */
        while (*ptr && *ptr == ' ') 
            ptr++;

        /* arg starts here */
        argc++;
        
        while ( *ptr && *ptr != ' ') {
            /* now have either quote or other charater */
            if (*ptr == '"') {
                ptr++;
                /* read to end quote */
                while (*ptr && *ptr != '"')
                    ptr++;
                ptr++;
            } else {
                ptr++;
            }
        }
        
    }

    /* create array for args */
    *argvp = (char **)malloc(argc * sizeof(char *) + 1);
    if (!*argvp)
        perror("malloc");

    /* partition args and store positions of first characters */
    it = *argvp;
    reading = 0;
    c = ptr = line;
    while ( *ptr ) {
        /* eat spaces */
        while (*ptr && *ptr == ' ') 
            ptr++;
        
        /* arg starts here */
        *(it++) = c;

        while ( *ptr && *ptr != ' ') {
            /* now have either quote or other charater */
            if (*ptr == '"') {
                ptr++;
                /* read to end quote */
                while (*ptr && *ptr != '"')
                    *(c++) = *(ptr++);
                ptr++;
            } else {
                *(c++) = *(ptr++);
            }
        }
        
        /* null terminate argument */
        *(c++) = 0;
        
    }

    /* add null pointer to end of array */
    *it = (char *)0;

    return argc;
}
