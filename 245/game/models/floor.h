#ifndef FLOOR_H
#define FLOOR_H

#include "level_piece.h"
#include "animate.h"
#include "player.h"
#include "inanimate.h"
#include "light_group.h"
#include "inventory_item.h"

#include "../PlayArea.h"

//defines a floor piece that animates can walk on, and inanimates can lay on
class floor : public level_piece {

public:
  floor(light_group *group, graphic sprite=WHITE) : level_piece(group),
						    _occupied_animate(NULL),
						    _occupied_inanimate(NULL),
                                                    _seen(true) {
    set_sprite(sprite);
  };
  ~floor() {}

private:
  animate *_occupied_animate;       //points to animate obj standing on this piece or null
  inanimate *_occupied_inanimate;   //points to inanimate obj standing on this piece or null
  bool _seen;  // only for traps
  
public:
  void interact(player *p);   //called when any animate tries to move here
  void fight(animate *obj);
  void set_occupied(animate *obj);
  void set_occupied(inanimate *obj);
  void set_visible();
  bool has_animate() { return _occupied_animate != NULL; }
  bool set_seen(bool seen) { return _seen = seen; }
  void draw();
};


#endif
