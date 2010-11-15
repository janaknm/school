#ifndef ARROW_TRAP_H
#define ARROW_TRAP_H

#include "floor.h"
#include "player.h"

//booby trap
class arrow_trap : public floor {

public:
  arrow_trap();

  void step_onl(player *p); //if obj is player, remove 1hp

};

#endif
