#ifndef PLAYER_H
#define PLAYER_H

#include "animate.h"
#include "inventory.h"

#include "../PlayArea.h"

#include <string>
using std::string;

class inanimate;
class inventory;
class inventory_item;

//main player class
class player : public animate {

public:
  player() : animate(10),
	     _hunger(200),
             _max_hunger(200),
	     _gold(0)
  {
    _inv = new inventory(this);
    set_sprite(PLAYER);
  }
  
  ~player() { delete _inv; }
  
private:
  int _hunger;
  int _max_hunger;
  int _gold;
  inventory *_inv;

public:
  string get_hunger_str();          
  string get_gold_str();                   
  void add_gold(int n);              //give player some gold
  bool obtain(inanimate *obj);       //pick up object, return if it was successful
  bool use_item(int index);          //use item, return if it was successful
  bool add_item(inventory_item *item); //add to inventory
};

#endif
