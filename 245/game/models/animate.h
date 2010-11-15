#ifndef ANIMATE_H
#define ANIMATE_H

#include "drawable.h"
#include "animate.h"

//abstract class describing objects that move/interact with the board
class animate : public drawable {

public:
  animate();
  virtual ~animate() = 0;

private:
  int _health;

public:
  int get_health();                      //health accessor
  void attacked_by(animate *opponent);   //this object is being attacked by *opponent*
  
};


#endif
