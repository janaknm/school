//Test suite for the big_int class

#ifndef BIG_INT_TESTS_H
#define BIG_INT_TESTS_H

string to_bool(int b) {
    return b? "true" : "false";
}

int test_pass(const big_int& a, const big_int& b) {
    if (a == b) {
        cout << "...PASS" << endl;
        return 1;
    } else { 
        cout << "...FAIL " << a << " != " << b << endl;
        return 0;
    }
}

int test_pass(bool a, bool b) {
    if (a == b) {
        cout << "...PASS" << endl;
        return 1;
    } else {
        cout << "...FAIL" << endl;
        return 0;
    }
}
    
void run_tests() {
    int correct = 0, possible = 0;
    big_int a,
            b = 3,
            c = 500.5;

    a = 5;
    b = 10;
    cout << "5 < 10 = " << to_bool(a < b);
    correct += test_pass(a < b, true);
    possible++;

    a = 15;
    b = 7;
    cout << "15 < 7 = " << to_bool(a < b);
    correct += test_pass(a < b, false);
    possible++;

    a = -20;
    b = 5;
    cout << "-20 < 5 = " << to_bool(a < b);
    correct += test_pass(a < b, true);
    possible++;

    a = 15;
    b = -30;
    cout << "15 < -30 = " << to_bool(a < b);
    correct += test_pass(a < b, false);
    possible++;

    a = -100;
    b = -8;
    cout << "-100 + (-8) = " << a+b;
    correct += test_pass(a+b, -108);
    possible++;

    a = -500;
    b = 30;
    cout << "-500 + 30 = " << a+b;
    correct += test_pass(a+b, -470);
    possible++;

    a = 9;
    b = 1;
    cout << "9 + 1 = " << a+b;
    correct += test_pass(a+b, 10);
    possible++;

    a = 35;
    b = 0;
    cout << "35 + 0 = " << a+b;
    correct += test_pass(a+b, 35);
    possible++;

    a = 400;
    b = -40;
    cout << "400 + (-40) = " << a+b;
    correct += test_pass(a+b, 360);
    possible++;

    a = 30;
    b = 40;
    cout << "30 + 40 = " << a+b;
    correct += test_pass(a+b, 70);
    possible++;

    a = 50;
    b = -50;
    cout << "50 + (-50) = " << a+b;
    correct += test_pass(a+b, 0);
    possible++;

    a = 5000;
    b = 400;
    cout << "5000 - 400 = " << a - b;
    correct += test_pass(a - b, 4600);
    possible++;

    a = -4000;
    b = 400;
    cout << "-4000 - 400 = " << (a - b);
    correct += test_pass(a-b, -4400);
    possible++;

    a = -500;
    b = -300;
    cout << "-500 - (-300) = " << (a - b);
    correct += test_pass(a - b, -200);
    possible++;
    
    a = 300;
    b = -200;
    cout << "300 - (-200) = " << (a - b);
    correct += test_pass(a - b, 500);
    possible++;

    a = 10;
    b = 1;
    a -= b;
    cout << "10 - 1 = " << a;
    correct += test_pass(a, 9);
    possible++;

    a = 20;
    b = 30;
    cout << "20 * 30 = " << (a * b);
    correct += test_pass(a * b, 600);
    possible++;

    a = 100;
    b = -50;
    cout << "100 * -50 = " << (a * b);
    correct += test_pass(a * b, -5000);
    possible++;

    a = -5;
    b = -35;
    cout << "-5 * -35 = " << (a * b);
    correct += test_pass(a * b, 175);
    possible++;

    a = 0;
    b = -33;
    cout << "0  * -33 = " << (a * b);
    correct += test_pass(a * b, 0);
    possible++;

    a = 1345;
    b = 221;
    cout << "1345 * 221 = " << (a * b);
    correct += test_pass(a * b, 297245);
    possible++;

    a = 553;
    b = 2323;
    cout << "553  * 2323 = " << (a * b);
    correct += test_pass(a * b, 1284619);
    possible++;

    a = 534123;
    b = -35;
    cout << "534123  * -35 = " << (a * b);
    correct += test_pass(a * b, -18694305);
    possible++;

    a = 5345;
    b = 1232;
    a *= b;
    cout << "5345 * 1232 = " << a ;
    correct += test_pass(a, 6585040);
    possible++;

    a = 2222;
    b = 999;
    cout << "2222  * 999 = " << (a * b);
    correct += test_pass(a * b, 2219778);
    possible++;

    cout << "Tests: " << correct << " / " << possible << " passed." << endl;
}


#endif

