#ifndef FLOOR_H
#define FLOOR_H

#include "level_piece.h"
#include "animate.h"
#include "player.h"
#include "inanimate.h"

//defines a floor piece that animates can walk on, and inanimates can lay on
class floor : public level_piece {

public:
  floor();

private:
  animate *occupied_animate;       //points to animate obj standing on this piece or null
  inanimate *occupied_inanimate;   //points to inanimate obj standing on this piece or null
  
  virtual void step_on(player *p);    //special function to call when player steps here, default does nothing

public:
  void interact(animate *obj);   //called when any animate tries to move here
};


#endif
