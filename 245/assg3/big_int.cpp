#include "big_int.h"
#include <cstring>
#include <iostream>

using namespace std;

// NOTES
// Representation of the number 32334 would be in an array of chars,
// with the number shifted to the right as far as possible. so
// 32334 = [0, 0, 0, 0, 0, ... , 0, 3, 2, 3, 3, 4]. Use add_digit to add a digit 
// to the front of the number, so say you want 32334 to become 432334, you'd call
// add_digit(4), etc. add_digit will check to make sure the current array is large
// enough to hold a new number with one greater digit, and if it doesn't we will
// create a larger array first (of 2x the length).

// CONSTRUCTORS

// Default constructor, initialize to zero
big_int::big_int() {
    initialize();
}

// Int constructor, type casting for ints. i.e. big_int a = 5;
big_int::big_int(long long n)  {
    int i;
    char c;

    initialize();
    
    if (n < 0) {
        _positive = false;
        n = -n;
    } else {
        _positive = true;
    }
    

    i = 0;
    while(n > 0) {
        c = n % 10;
        edit_digit(i, c);
        i++;
        n /= 10;
    }
}

// Copy constructor, calls the same function assignment operator does
big_int::big_int(const big_int& rhs) {
    initialize();
    duplicate(rhs);
}

// Destructor to manage memory
big_int::~big_int() {
    dispose();
}

void big_int::initialize() {
    _size = 0;
    _digits = 0;
    _value = NULL;
    _positive = true;
    edit_digit(0, 0);
}

void big_int::dispose() {
    delete[] _value;
}

// OPERATORS

// Assignment operator
big_int& big_int::operator=(const big_int& rhs) {
    if (*this == rhs) {
        return *this;
    }
    dispose();
    initialize();
    duplicate(rhs);
    return *this;
}

// Deep copy
void big_int::duplicate(const big_int& rhs) {
    int ix = 0;
    _digits = 0;
    _positive = rhs._positive;
    while (ix < rhs._digits) {
        edit_digit(ix, rhs.get_digit(ix));
        ix++;
    }
}


bool big_int::operator<(const big_int& rhs) const {
    int c = compare(rhs, false);
    return c == -1;
}
bool big_int::operator<=(const big_int& rhs) const {
    int c = compare(rhs, false);
    return c < 1;
}
bool big_int::operator>(const big_int& rhs) const {
    int c = compare(rhs, false);
    return c == 1;
}
bool big_int::operator>=(const big_int& rhs) const {
    int c = compare(rhs, false);
    return c > -1;
}

bool big_int::operator==(const big_int& rhs) const {
    return compare(rhs, false) == 0;
}

bool big_int::operator!=(const big_int& rhs) const {
    return compare(rhs, false) != 0;
}

// + defined in terms or +=
const big_int big_int::operator+(const big_int& rhs) const {
    big_int sum = *this;
    sum += rhs;
    return sum;
}

// - defined in terms of -=
const big_int big_int::operator-(const big_int& rhs) const {
    big_int s = *this;
    s -= rhs;
    return s;
}

// * defined in terms of *=
const big_int big_int::operator*(const big_int& rhs) const {
    big_int p = *this;
    p *= rhs;
    return p;
}

big_int& big_int::operator+=(const big_int& rhs) {
    if ( (_positive && rhs._positive) || (!_positive && !rhs._positive) ) {
        abs_add(rhs);
        return *this;
    }

    switch( compare(rhs, true) ) {
        case 1: // |this| > |rhs|
            abs_sub(rhs);
            break;
        case -1: // |this| < |rhs|
            {
                big_int tmp = *this;
                *this = rhs;
                abs_sub(tmp);
                _positive = !_positive; 
            }
            break;
        default: // |this| = |rhs|
            *this = 0;
            break;
    }

    return *this;
}

big_int& big_int::operator-=(const big_int& rhs) {
    if ( (!_positive && rhs._positive) || (_positive && !rhs._positive) ) {
        abs_add(rhs);
        return *this;
    }

    switch( compare(rhs, true) ) {
        case 1: // |this| > |rhs|
            abs_sub(rhs);
            break;
        case -1: // |this| < |rhs|
            {
                big_int tmp = *this;
                *this = rhs;
                abs_sub(tmp);
                _positive = !_positive;
            }
            break;
        default:
            *this = 0;
            break;
    }

    return *this;
}

big_int& big_int::operator*=(const big_int& rhs) {
    
    big_int tmp = *this,
            accum = 0;
    int carry = 0,
        offset = 0,
        value = 0,
        current = 0,
        ix = 0,
        jx = 0,
        kx = 0;

    *this = 0;
    if (tmp == 0 || rhs == 0) {
        return *this;
    }
    
    while( ix < tmp._digits) {
        //add offset 0's
        jx = 0;
        accum = 0;
        while (jx < offset) {
            accum.edit_digit(jx, 0);
            jx++;
        }

        current = tmp.get_digit(ix);
        kx = 0;
        carry = 0;
        while (kx < rhs._digits) {
            value = carry + current * rhs.get_digit(kx);
            carry = value / 10;
            value =  value % 10;
            accum.edit_digit(jx, value);
            jx++;
            kx++;
        }

        if (carry) {
            accum.edit_digit(jx, carry);
        }   
        
        *this += accum;
        offset++;
        ix++;
    }

    _positive = (tmp._positive == rhs._positive);

    return *this;
}

void big_int::abs_add(const big_int& rhs) {
    int max_size = (_digits > rhs._digits) ? _digits : rhs._digits;
    int carry = 0,
        value = 0,
        ix = 0;
    
    while(ix < max_size) {
        value = carry + get_digit(ix) + rhs.get_digit(ix);
        carry = (value >= 10) ? 1 : 0; // just in case???
        value = value % 10;
        edit_digit(ix, value);
        ix++;
    }

    if(carry) {
        edit_digit(ix, carry);
    }

}

void big_int::abs_sub(const big_int& rhs) {
    int max_size = _digits,
        carry = 0,
        value = 0,
        bottom = 0,
        ix = 0;

    while (ix < max_size) {
        value = carry + get_digit(ix);
        bottom = rhs.get_digit(ix);
        if (value < bottom) {
            carry = -1;
            value += 10;
        } else {
            carry = 0;
        }
        value = value - bottom;
        edit_digit(ix, value);
        ix++;
    }

    ix--;
    while( get_digit(ix) == 0) {
        _digits--;
        ix--;
    }
}




// PUBLIC

// Print this big_int to an output stream (used in overloading <<)
void big_int::print(ostream& out) const {
    int i = _digits - 1;
    if(!_positive) out << '-';
    while (i >= 0) {
        out << (int)get_digit(i);
        i--;
    }
}

// STATIC
big_int big_int::factorial(const big_int& val) {
    if (val > 1) {
        return val * big_int::factorial(val -1);
    }
    return val;
}

// PRIVATE
// Safe way to add a digit to this number, adds to FRONT of the current number
// Allocates memory as necessary
void big_int::edit_digit(int i, char d) {
    //grow if we've filled up the _value array
    if (d < 0) {
        throw d;
    }

    if(i >= _size) {
        grow();
    }
    if(i >= _digits) {
        _digits = i+1;
    }


    _value[_size - i - 1] = d;
}

// Safe way to get a digit in this number, will return 0 if it's out of bounds
char big_int::get_digit(int i) const {
    if(i >= _digits) {
        return 0;
    }
    else return _value[_size - i - 1];
}

// Memory management for internal char* representation. If we need more space, we
// make a new array of 2x the size, then copy the old data in to it. Swap this new
// array for the old, and free up the old memory.
void big_int::grow() {
    static int c = 0;
    c++;
    char *new_value;
    int i = 0,
        n = (_size > 0) ? 2*_size : 20; // default 20 digits (enough for 64bit integer)

    new_value = new char[n];

    while (i < _digits) {
        new_value[n - i - 1] = _value[_size - i - 1]; 
        i++;
    }

    _size = n;

    if (_value != NULL) delete[] _value;
    _value = new_value;
}


// -1 if smaller than arg, 0 if equal, 1 if greater
int big_int::compare(const big_int& rhs, bool ignore_sign) const {
    int i;
    char l, r;
    // case: this is positive and rhs is negative, this is bigger if we care about sign
    if (!ignore_sign && _positive && !rhs._positive) {
        return 1;
    // case: this is negative, and rhs is positive, this is smaller if we care about sign
    } else if (!ignore_sign && !_positive && rhs._positive) {
        return -1;
    // case: this has less digits than rhs, if both are negative, then this is greater
    } else if (_digits < rhs._digits) {
        if (!ignore_sign && !_positive) {
            return 1;
        }
        return -1;
    // case: this has more digits than rhs, if both are negative, then this is smaller
    } else if (_digits > rhs._digits) {
        if (!ignore_sign && !_positive) {
            return -1;
        }
        return 1;
    // case: same sign, same number of digits, compare each digit starting on the most significant
    } else {
        i = _digits - 1;
        while (i > 0 && get_digit(i) == rhs.get_digit(i)) {
            i--;
        }
        // i now holds the index of the first digit from the left that is different
        l = get_digit(i);
        r = rhs.get_digit(i);
        if (l == r) {
            return 0; // we hit i=0, all digits are equal
        } else if (l < r) {
            if (!ignore_sign && !_positive) {
                return 1; // smaller negative
            }
            return -1; // smaller positive
        } else {
            if (!ignore_sign && !_positive) {
                return -1; // greater negative
            } 
            return 1; // greater positive
        }
    }
}

//print that shit.
ostream& operator<< (ostream& out, const big_int& n) {
    n.print(out);
    return out;
}
