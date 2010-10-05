#ifndef WORLD_H
#define WORLD_H

#include <iostream>

using namespace std;

class World {
    
    //friend istream& operator>> (istream& input, World& world);

    private:
	int **board,
	    generation,
	    rows, cols;

    public:
	World();
	void initialize(istream& input);
	void generate(int n, bool ask=true);
	void print_state(ostream& output);
};

#endif
