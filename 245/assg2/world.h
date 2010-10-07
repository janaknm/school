#ifndef WORLD_H
#define WORLD_H

#include <iostream>

using namespace std;

struct Cell {
    int current,
	next;
    Cell(): current(0), next(0) {}
};

class World {
    
    //friend istream& operator>> (istream& input, World& world);
    public:
	World();
	void initialize(istream& input);
	void generate(int n, bool ask=true);
	void print_state(ostream& output);

    private:
	//attributes
	Cell **board;
	int generation,
	    rows, cols;

	//methods
	int check_cell(int row, int col);

};

#endif
