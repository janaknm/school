#ifndef BIG_INT_H
#define BIG_INT_H

#include <iostream>

using namespace std;

class big_int {

    friend ostream& operator<< (ostream& out, big_int&);

    public:
        // constructors
        big_int();
        big_int(long long);
        big_int(const big_int&);
        ~big_int();

        // operator overloads
        const big_int operator+(const big_int&);
        const big_int operator-(const big_int&);
        const big_int operator*(const big_int&);
        bool operator<(const big_int&);
        bool operator>(const big_int&);
        big_int& operator=(const big_int&);
        big_int& operator+=(const big_int&);
        big_int& operator-=(const big_int&);
        big_int& operator*=(const big_int&);

        //public methods
        void print(ostream&) const;
        //compare: return 1 if arg is smaller, 0 if equal, -1 if greater
        int compare(const big_int&, bool ignore_sign);

        //public static methods
        static big_int factorial(const big_int&);
    
    private:
        //private properties
        char *_value; //holds digits
        int _size; //size of value array
        int _digits; //number of digits in this int
        bool _positive; //sign of this int

        //private methods
        void push_digit(char d); // push a digit on to the front of the number
        void grow(); //get more memmory! if n=0, double existing memory
        void duplicate(const big_int& rhs); //copy from another int

};



#endif
