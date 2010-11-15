#ifndef INVENTORY_H
#define INVENTORY_H

#include <vector>
#include "inventory_item.h"

//holds player's inventory items
class inventory {
  
public:
  inventory();

private:
  vector<inventory_item> _items;
  int _num_items;
  int _capacity;

public:
  bool add_item(inventory_item *item);   //try adding item, return true on success (not full)
  bool remove_item(int index);           //try removing an item by index, return true if success (item exists)
};

#endif
