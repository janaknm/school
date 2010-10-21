#ifndef BIG_INT_H
#define BIG_INT_H

class big_int {

    public:
        // constructors
        big_int();
        big_int(int);
        big_int(const big_int&);
        ~big_int();

        // operator overloads
        const big_int operator+(const big_int&) const;
        const big_int operator-(const big_int&) const;
        const big_int operator*(const big_int&) const;
        big_int& operator=(const big_int&);

        //public methods
        void print() const;

        //public static methods
        static big_int factorial(const big_int&);
    
    private:
        //private properties
        char *_value;
        int _size;

        //private methods
        void grow_to(int size); //get more memmory!

};

#endif
