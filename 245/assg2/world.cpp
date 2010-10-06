#include "world.h"
#include <iostream>
#include <cstring>

using namespace std;

World::World() {
    board = NULL;
    generation = 0;
}

void World::initialize(istream& input) {
    int x, y,
	i, j;
    char c;
    
    input >> cols >> rows >> x >> y;
    
    //normalize for 0-indexed array
    x--; y--;

    // initialize board to 0 (all dead)
    board = new int*[rows];
    for( i=0; i<rows; i++ ) {
	board[i] = new int[cols];
    }

    j = x;
    i = y;

    do {
	c = input.get();
	if (c == '\n') {
	    j = x;
	    i++;
	}
	board[i][j++] = (c == '*') ? 1 : 0;
    } while (!input.eof());
}

void World::print_state(ostream& output) {
    int i, j;
    char c;

    for( i=0; i<rows; i++) {
	cout << i;
	for( j=0; j<cols; j++) {
	    c = (board[i][j]) ? '*' : ' ';
	    cout << c;
	}
	cout << j;
	cout << endl;
    }

}

void generate(int n, bool ask=true) {
    
}
