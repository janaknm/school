//Matt Forbes
//November 1, 2010
//Assignment 3, big_ints

//#include "tests.h"
#include "big_int.h"
#include <iostream>

using namespace std;

big_int factorial(const big_int& val) {
    if (val > 1) {
        return val * factorial(val - 1);
    }
    return 1;
}

big_int fibonacci(int n) {
    big_int f0 = 0,
            f1 = 1;
    int c = 2;

    // special case
    if(n == 0) return 1;

    while ( c < n) {
        if ( (c % 2) == 0) {
            f0 = f0 + f1;
        } else {
            f1 = f0 + f1;
        }
        c++;
    }
    return f0 + f1;
}

big_int pow(const big_int& base, big_int power) {
    big_int ret = base;
    while( (power -= 1) > 0) {
        ret *= base;
    }
    return ret;
}



int main(int argc, char **argv) {
    big_int i = factorial(500) - pow(2, 500) + fibonacci(1000);
    cout << "500! - 2^500 + fib(1000):" << endl << i << endl;
   
    return 0;
}
