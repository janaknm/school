#ifndef INANIMATE_H
#define INANIMATE_H

#include "player.h"

// abstract class to represent non-moving objects
class inanimate : public drawable {
public:
  inanimate();

  virtual void be_obtained(player *p) = 0;   //pure virtual. what happens when player picks this up
  
};


#endif
