#ifndef INANIMATE_H
#define INANIMATE_H

#include "drawable.h"
#include "../PlayArea.h"

class player;

class inanimate : public drawable {
public:
  inanimate(graphic sprite) {
    set_sprite(sprite);
  }
  ~inanimate() {}

  virtual bool be_obtained(player *p) { return true; };   //pure virtual. what happens when player picks this up
  
};


#endif
