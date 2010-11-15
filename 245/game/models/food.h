#ifndef FOOD_H
#define FOOD_H

#include "inventory_item.h"
#include "player.h"

//food found on floor
class food : public inventory_item {

public:
  food();

  void use(player* p);    //virtual definition. heals players hunger

};

#endif
