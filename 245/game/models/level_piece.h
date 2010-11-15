#ifndef LEVEL_PIECE_H
#define LEVEL_PIECE_H

#include "drawable.h"
#include "animate.h"
#include "light_group.h"

//groups objects that are valid 'tiles'
class level_piece : public drawable {

public:
  level_piece();

private:
  bool _wall;            //is this just a wall?
  light_group *group;    //what light_group does this piece belong to?

public:
  bool is_wall();   
  virtual void interact(animate *obj);   //handle something trying to move to this piece

};


#endif
