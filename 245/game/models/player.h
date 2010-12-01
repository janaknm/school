#ifndef PLAYER_H
#define PLAYER_H

#include "animate.h"
#include "../PlayArea.h"

#include <string>
using std::string;

class inanimate;
class inventory_item;
class inventory;

//main player class
class player : public animate {

public:
  player();
  ~player();
  
private:
  int _hunger;
  int _max_hunger;
  int _gold;
  
public:
  inventory *inv;

  void add_gold(int n);              //give player some gold
  void report();
  void sub_hunger(int n);
  void eat();
  void heal();
  void level_up();
  int hunger() { return _hunger; }
  bool has_diamond();
};

#endif
