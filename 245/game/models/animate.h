#ifndef ANIMATE_H
#define ANIMATE_H

#include "drawable.h"

class light_group;
class level_piece;
class floor;

//abstract class describing objects that move/interact with the board
class animate : public drawable {

public:
  animate(int max_health);
  ~animate() {}
  
protected:
  int _health;
  int _max_health;
  light_group *_group;
  
public:
  floor *flr;
  
  void set_group(light_group *group) { _group = group; }
  void attacked_by(animate *opponent);   //this object is being attacked by *opponent*
  void sub_health(int n);
  int health() { return _health; }
  light_group *group() { return _group; }
  
};


#endif
