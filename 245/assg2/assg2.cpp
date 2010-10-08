#include <fstream>
#include <iostream>
#include <cctype>
#include "world.h"
using namespace std;

int main(int argc, char **argv) {
    // declare locals
    World w;
    ifstream input;
    string fname;
    int generations;
    bool generating = true;
    char c;

    // get input
    cout << "Please enter a filename containing initial world: ";
    cin >> fname;
    cout << "Enter number of generations to compute: ";
    cin >> generations;
    cin.get(); // clear \n

    // open file and build the world
    input.open(fname.c_str(), ifstream::in);
    w.initialize(input);
    input.close();

    // continue generating until user says stop
    while(generating) {
	while (generations--) {
	    // print current state, and step through generation
	    w.print_state(cout);
	    w.step();
	    
	    // wait for new line
	    cout << "Press enter to continue... ";
	    while(cin.get() != '\n');
	}
	
	do {
	    cout << "Continue? (y/n) "; 
	    c = tolower(cin.get());
	} while(c != 'y' && c != 'n');
	
	// reset generations if we are continuing
	generating = (c == 'y');
	if (generating) {
	    cout << "Enter number of generations to compute: ";
	    cin >> generations;
	    cin.get();
	}
    }

    return 0;
}
