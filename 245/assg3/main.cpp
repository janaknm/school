#include "big_int.h"
#include <iostream>

using namespace std;

void run_tests() {
    big_int a,
            b = 3,
            c = 500.5;

    a = 100;
    a += b;
    a += 5;
    cout << "addition: should print 108... a=" << a << endl;

    a = 5000;
    a -= c;
    a -= 30;
    cout << "subtraction: should print 4200... a=" << a << endl;
    
    a = 200;
    a *= c;
    cout << "multiplication: should print 1000... a=" << a << endl;

    a = 10;
    a = big_int::factorial(a);
    cout << "factorial: should print 3628800... a=" << a << endl;

    a = big_int::factorial(5); // does this work??
    cout << "factorial of literal: should print 120... a=" << a << endl;
}

int main(int argc, char **argv) {
    //run_tests();
    big_int a = 50;
    big_int b = 50;
    cout << "a < b ? " << (a < b) << endl;

    return 0;
}
