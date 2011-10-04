#include "proto.h"

struct builtin {
    char *name;
    void (*f)(char **argv);
};

void testfn(char **argv) {
}

void (*get_builtin(char *name))(char **argv) {
    void (*fn)(char **argv) = testfn;
    return fn;
}
