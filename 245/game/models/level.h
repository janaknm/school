#ifndef LEVEL_H
#define LEVEL_H

#include "monster.h"
#include "level_piece.h"

//representation of a level in the dungeon
class level {

 public:
  level();
  ~level();

 private:
  monster* _monsters;        //array of monster objects on this level
  level_piece** _pieces;     //pieces that make up this level
  level_piece* _upstairs;    //upstairs object
  level_piece* _downstairs;  //downstairs object

 public:
  void next_state();    //make monsters move, etc.

};

#endif
