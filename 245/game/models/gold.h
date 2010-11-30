#ifndef GOLD_H
#define GOLD_H

#include "player.h"
#include "inanimate.h"

#include "../PlayArea.h"

//gold piece found on floor
class gold : public inanimate {
  
public:
  gold() {
    set_sprite(GOLD);
  }

  bool be_obtained(player *p) { return true; }   //virtual definition. Add gold to player.
  
};


#endif
