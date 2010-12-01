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
  
};


#endif
