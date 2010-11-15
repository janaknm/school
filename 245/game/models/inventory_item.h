#ifndef INVENTORY_ITEM_H
#define INVENTORY_ITEM_H

#include "inanimate.h"
#include "player.h"

//abstract class to group objects that can be placed in the inventory
class inventory_item : public inanimate {

public:
  inventory_item();

  void be_obtained(player *p);   //add this item to player's inventory.
  
  virtual void use(player *p) = 0;   //pure virtual. what happens when player uses this item
  
};


#endif
