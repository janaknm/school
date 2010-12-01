#ifndef INVENTORY_H
#define INVENTORY_H

#include <string>
#include <vector>

#include "../gui.h"

using std::vector;
using std::string;

class player;
class inventory_item;

//holds player's inventory items
class inventory {
  
public:
  inventory(player *owner) : _owner(owner),
			     _capacity(10),
			     _know_drinks(false) { }

private:
  vector<inventory_item *> _items;
  player *_owner;
  unsigned int _capacity;
  bool _know_drinks;
  
  inventory_item *remove_item(int index);           //try removing an item by index, return true if success (item exists)
  
public:
  bool add_item(inventory_item *item);   //try adding item, return true on success (not full)
  inventory_item *drop(int index);
  void eat(int index);
  void drink(int index);
  void report();
  bool has_diamond();
};

#endif
