#ifndef FLOOR_H
#define FLOOR_H

#include "level_piece.h"
#include "animate.h"
#include "player.h"
#include "inanimate.h"
#include "light_group.h"

#include "../PlayArea.h"

//defines a floor piece that animates can walk on, and inanimates can lay on
class floor : public level_piece {

public:
  floor(light_group *group, graphic sprite=WHITE) : level_piece(group),
						    _occupied_animate(NULL),
						    _occupied_inanimate(NULL) {
    set_sprite(sprite);
  };
  ~floor() {}

private:
  animate *_occupied_animate;       //points to animate obj standing on this piece or null
  inanimate *_occupied_inanimate;   //points to inanimate obj standing on this piece or null
  
public:
  void interact(animate *obj);   //called when any animate tries to move here
  void set_occupied(animate *obj);
  void set_occupied(inanimate *obj);
  void draw();
};


#endif
