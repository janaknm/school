#ifndef TELEPORT_TRAP_H
#define TELEPORT_TRAP_H

#include "floor.h"
#include "player.h"

//trap that random teleports player somewhere within the level
class teleport_trap : public floor {

public:
  teleport_trap();

  void step_on(player *p);   //if animate is player, teleport to random position in the current level

};

#endif
