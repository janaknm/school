#ifndef STAIRS_H
#define STAIRS_H

#include "floor.h"
#include "player.h"

//floor piece holding stairs
class stairs : public floor {

public:
  stairs();

  void step_on(player *p);   //if obj is a player, set stairs flag to true
  
};

#endif
