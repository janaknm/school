#include "world.h"
#include <iostream>
#include <cstring>

using namespace std;

World::World() {
    cells = NULL;
    generation = 0;
}

World::~World() {
    delete[] cells;
}

void World::initialize(istream& input) {
    int x, y,
	i, j;
    char c;
    
    // get dimensions
    input >> cols >> rows >> x >> y;
    
    //normalize for 0-indexed array
    x--; y--;

    // 2D array of cells. Deallocated in constructor!
    cells = new Cell* [rows];
    for( i=0; i<rows; i++ ) {
	cells[i] = new Cell [cols];
    }

    j = x; 
    i = y;
    do {
	c = input.get();
	if (c == '\n') {
	    j = x;
	    i++;
	}
	// set the current flag of this cell if it is marked with an *
	(cells[i][j++]).current = (c == '*') ? 1 : 0;
    } while (!input.eof());
}

void World::print_state(ostream& output) {
    int i, j;
    char c;

    for( i=0; i<rows; i++) {
	for( j=0; j<cols; j++) {
	    c = (cells[i][j].current) ? '*' : ' ';
	    cout << c;
	}
	cout << endl;
    }

}

// step:
// Because the step from generation to generation is instantaneous, we have
// to build the entire cell array based on the current data, (ie we can't
// do this in-place) A possibility would be to create an auxillary array
// to hold next states, but that seems wasteful. Each cell holds its current
// state, and also the next state which is used soley for this generation purpose.
void World::step() {
    int i, j;
    
    // calculate the next state for all cells based on current cell data
    for ( i=0; i<rows; i++) {
	for ( j=0; j<cols; j++) {
	    cells[i][j].next = check_cell(i,j);
	}
    }

    // update the current cell data with previously generated states
    for ( i=0; i<rows; i++) {
	for ( j=0; j<cols; j++) {
	    cells[i][j].current = cells[i][j].next;
	}
    }

    generation++;
}

// check_cell:
// I didn't want a bunch of stupid nested if statements, so I went with
// a much more readable, if slightly less efficient, bounds check on each
// cell. Doesn't change asymptotic behavior, so it's fine with me.
int World::check_cell(int row, int col) {
    int alive = cells[row][col].current,
	neighbors=0;

// Calculate number of alive neighbors::

    // left middle
    if (col > 0) {
	neighbors += cells[row][col-1].current;
    }
    // top left corner
    if (row > 0 && col > 0) {
	neighbors += cells[row-1][col-1].current;
    }
    // top middle
    if (row > 0) {
	neighbors += cells[row-1][col].current;
    }
    // top right corner
    if (row > 0 && col < (cols-1)) {
	neighbors += cells[row-1][col+1].current;
    }
    // right middle
    if (col < (cols-1)) {
	neighbors += cells[row][col+1].current;
    }
    // bottom right corner
    if(row < (rows-1) && col < (cols-1)) {
	neighbors += cells[row+1][col+1].current;
    }
    // bottom middle
    if(row < (rows-1)) {
	neighbors += cells[row+1][col].current;
    }
    // bottom left corner
    if (row < (rows-1) && col > 0) {
	neighbors += cells[row+1][col-1].current;
    }

// return the next state of this cell
    if(alive) {
	if (neighbors < 2) {
	    return 0;
	} else if (neighbors > 3) {
	    return 0;
	} else {
	    return 1;
	}
    } else {
	return (neighbors == 3) ? 1 : 0;
    }


}
