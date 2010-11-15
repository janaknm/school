#ifndef PATH_H
#define PATH_H

#include "floor.h"
#include "light_group.h"
#include "player.h"

//floor that connects rooms
class path : public floor {

public:
  path();

private:
  light_group *destination;    //what group should light up when we get to the end of the path or null

public:
  void step_on(player *p);   //if destination is not null illuminate the light_group

};

#endif
