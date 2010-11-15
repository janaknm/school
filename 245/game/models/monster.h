#ifndef MONSTER_H
#define MONSTER_H

#include "animate.h"
#include "player.h"

//all monsters on the board
class monster : public animate {

 public:
  monster();
  
  void move(player *p);   //change monsters position based on where player is
  
};

#endif
