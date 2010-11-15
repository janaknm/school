#ifndef PLAYER_H
#define PLAYER_H

#include "animate.h"
#include "inanimate.h"
#include "inventory.h"
#include "enum.h"

//main player class
class player : public animate {

public:
  player();
  ~player();

private:
  int _hunger;
  int _gold;
  bool _diamond;
  stair_direction _on_stairs;
  inventory _inv;

public:
  int get_hunger();                  //hunger accessor
  int get_gold();                    //gold accessor
  bool get_stairs();                 //on_stairs accessor
  bool get_diamond();                //diamond accessor
  void set_stairs(stair_direction dir);  //player is/isn't standing on stairs
  void add_diamond();                //player picked up diamond, record it
  void add_gold(int n);              //give player some gold
  bool move(direction dir);          //move direction, return if it was successful
  bool obtain(inanimate *obj);       //pick up object, return if it was successful
  bool use_item(int index);          //use item, return if it was successful
};

#endif
