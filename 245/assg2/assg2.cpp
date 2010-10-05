#include <iostream>
#include "world.h"

using namespace std;

int main(int argc, char **argv) {
    World w;

    w.initialize(cin);
    w.print_state(cout);

    return 0;
}
