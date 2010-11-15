#ifndef DRINK_H
#define DRINK_H

#include "inventory_item.h"
#include "player.h"

//drink found on floor
class drink : public inventory_item {

public:
  drink();

private:
  bool _is_health;    //type of drink. if true, heal player otherwise hurt him

public:
  void use(player *p);   //virtual definition of what happens when drink is used.
  
};

#endif
