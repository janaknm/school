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
        i = 0;
    
    if (argc > 1 && strncmp("-n", argv[1], 2) == 0) {
        print_nl = 0;
        /* don't print the -n */
        argv++;
        argc--;
    }

    for(i = 1; i < argc; i++) {
        if (i != 1) {
            if (write(1, " ", 1) < 0) 
                perror("write");
        }
        
        if (write(1, argv[i], strlen(argv[i])) < 0) 
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
