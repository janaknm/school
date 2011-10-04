#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include "proto.h"

struct builtin {
    char *name;
    void (*fn)(int, char **argv);
};

void bin_exit(int argc, char **argv) {
    int code = (argc == 1) ? 0 : atoi(argv[1]);
    exit(code);
}

void bin_aecho(int argc, char **argv) {
    int print_nl = 1,
        len = 0,
        tmp_len,
        i = 0;
    char *buf;
        

    if (argc > 1 && strncmp("-n", argv[1], 2) == 0) {
        print_nl = 0;
        /* don't print the -n */
        argv++;
        argc--;
    }
    
    /* calculate max buffer size */
    for(i = 1; i < argc; i++) {
        /* add 2 to account for '\0' and ' ' */
        tmp_len = strlen(argv[i]) + 2;
        len = (len > tmp_len) ? len : tmp_len;
    }
    
    /* allocate buffer */
    buf = (char *)malloc(len * sizeof(char));
    if (!buf)
        perror("malloc");

    /* write args to stdout (fd=1) */
    for(i = 1; i < argc; i++) {
        tmp_len = strlen(argv[i]) + 1;

        /* write arg to string */
        snprintf(buf, tmp_len + 1, "%s ", argv[i]);
        
        /* write to fd */
        if (write(1, buf, tmp_len + ((i==1) ? 0 : 1)) < 0) 
            perror("write");
    }

    if (print_nl) {
        if (write(1, "\n", 1) < 0) 
            perror("write");
    }
        
}


const int NUM_BUILTINS = 2;
const struct builtin BUILTINS[] = {
    { "aecho", bin_aecho },
    { "exit", bin_exit }
};

int try_builtin(int argc, char **argv) {
    int i;
    char *name = argv[0];
    
    for (i = 0; i<NUM_BUILTINS; i++) {
        if (strcmp(name, BUILTINS[i].name) == 0) {
            /* matched builtin name, call it */
            BUILTINS[i].fn(argc, argv);
            return 1;
        }
    }
    /* didn't match */
    return 0;
}
