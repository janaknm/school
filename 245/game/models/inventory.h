#ifndef INVENTORY_H
#define INVENTORY_H

#include <vector>

using std::vector;

class player;
class inventory_item;

class inventory;

//holds player's inventory items
class inventory {
  
public:
  inventory(player *owner) : _owner(owner), _capacity(10) { }

private:
  vector<inventory_item *> _items;
  player *_owner;
  unsigned int _capacity;

public:
  bool add_item(inventory_item *item);   //try adding item, return true on success (not full)
  bool remove_item(unsigned int index);           //try removing an item by index, return true if success (item exists)
  bool use_item(unsigned int index);              //try using an item by index
};

#endif
