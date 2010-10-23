#ifndef BIG_INT_H
#define BIG_INT_H

#include <iostream>

using namespace std;

class big_int {

    friend ostream& operator<< (ostream& out, const big_int&);

    public:
        // constructors
        big_int();
        big_int(long long);
        big_int(const big_int&);
        ~big_int();

        // operator overloads
        const big_int operator+(const big_int&) const;
        const big_int operator-(const big_int&) const ;
        const big_int operator*(const big_int&) const;
        bool operator<(const big_int&) const;
        bool operator<=(const big_int&) const;
        bool operator>(const big_int&) const;
        bool operator>=(const big_int&) const;
        bool operator==(const big_int&) const;
        bool operator!=(const big_int&) const;
        big_int& operator=(const big_int&);
        big_int& operator+=(const big_int&);
        big_int& operator-=(const big_int&);
        big_int& operator*=(const big_int&);

        //public methods
        void print(ostream&) const;

        //public static methods
        static big_int factorial(const big_int&);
    
    private:
        //private properties
        char *_value; //holds digits
        int _size; //size of value array
        int _digits; //number of digits in this int
        bool _positive; //sign of this int

        //private methods
        void edit_digit(int i, char d); // push a digit on to the front of the number
        char get_digit(int i) const;
        void grow(); //get more memmory! if n=0, double existing memory
        void duplicate(const big_int& rhs); //copy from another int
        int compare(const big_int&, bool ignore_sign) const; // 1 if smaller than arg, 0 if equal, -1 if less

	    void abs_add(const big_int&); //add two values igoring sign
        void abs_sub(const big_int&); //subtract first arg from second igoring sign

};

ostream& operator<< (ostream& out, const big_int&);


#endif
