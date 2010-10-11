// Matt Forbes
// October 2010
// CS245 Assignment 2

#ifndef WORLD_H
#define WORLD_H

#include <iostream>

using namespace std;

// simple container to hold current/next state of a cell 
struct Cell {
    int current,
	next;
    Cell(): current(0), next(0) {}
};

class World {
    
    public:
	World();
	~World();
	void initialize(istream& input);
	void step();
	void print_state(ostream& output);

    private:
	Cell **cells;
	int generation,
	    rows, cols;

	int check_cell(int row, int col);

};

#endif
