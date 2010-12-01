#ifndef LEVEL_PIECE_H
#define LEVEL_PIECE_H

#include "drawable.h"
#include "animate.h"
#include "light_group.h"

//groups objects that are valid 'tiles'
class level_piece : public drawable {

public:
  level_piece(light_group *group, graphic sprite=WHITE) : _group(group) {
    set_sprite(sprite);
  }
  ~level_piece() { delete _group; }

private:
  bool _wall;            //is this just a wall?

protected:
  light_group *_group;    //what light_group does this piece belong to?

public:
  bool is_wall() { return _wall; }   
  virtual void interact(animate *obj);
  virtual void set_visible() { visible = true; }
  light_group *group() { return _group; }
};


#endif
