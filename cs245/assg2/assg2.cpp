#include <iostream>
#include "world.h"

int main(int argc, char **argv) {
    World w;

    w.initialize(cin);
    w.print_state(cout);

    return 0;
}
