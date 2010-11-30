#ifndef INVENTORY_ITEM_H
#define INVENTORY_ITEM_H

#include "inanimate.h"
#include "player.h"

#include "../PlayArea.h"

class inventory_item : public inanimate {

public:
  inventory_item(graphic sprite) : inanimate(sprite)  {}
    
  bool be_obtained(player *p) { return p->add_item(this); }   //add this item to player's inventory.
  
  virtual void use(player *p) {
    switch(what_am_i()) {
    default:
      printf("being used\n");
    }

  }; 
  
};


#endif
