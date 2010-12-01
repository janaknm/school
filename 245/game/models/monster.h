#ifndef MONSTER_H
#define MONSTER_H

#include "animate.h"
#include "player.h"

#include "../PlayArea.h"

//all monsters on the board
class monster : public animate {

 public:
  monster(int health, graphic sprite) : animate(health) {
    set_sprite(sprite);
    has_fought = false;
  }
  ~monster() {}
  
  bool has_fought;
  void move(player *p);   //change monsters position based on where player is
  
};

#endif
