#ifndef DIAMOND_H
#define DIAMOND_H

#include "inanimate.h"
#include "player.h"

//diamond on bottom level?
class diamond : public inanimate {

public:
  diamond();

  void be_obtained(player *p);   //virtual definition. set player's diamond flag to true
  
};


#endif
