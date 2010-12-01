#ifndef INVENTORY_ITEM_H
#define INVENTORY_ITEM_H

#include "inanimate.h"
#include "player.h"

#include "../PlayArea.h"

class inventory_item : public inanimate {

public:
  inventory_item(graphic sprite, bool is_bad=false) : inanimate(sprite), _is_bad(is_bad) {}
  bool is_bad() { return _is_bad; }
  
private:
  bool _is_bad;
  
};


#endif
