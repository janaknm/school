#include "world.h"
#include <iostream>

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
	memcpy( board[i], 0, sizeof(int) * cols );
    }

    j = x;
    i = y;

    while( j<cols && i<rows ) {
	input >> c;
	c = (c == '*') ? 1 : 0;
	board[i][j] = c;

	if( ++j == cols) {
	    j = 0;
	    i++;
	}
    }
}

void World::print_state(ostream& output) {
    int i, j;
    char c;
    
    for( i=0; j<rows; i++ ) {
	for( j=0; j<cols; j++) {
	   c = (board[i][j]) ? '*' : ' ';
	   output << c;
	}
	output << endl;
    }
}

void generate(int n, bool ask=true) {
    
}
