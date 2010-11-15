#ifndef GOLD_H
#define GOLD_H

#include "player.h"
#include "inanimate"

//gold piece found on floor
class gold : public inanimate {
  
public:
  gold();

  void be_obtained(player *p);   //virtual definition. Add gold to player.
  
};


#endif
