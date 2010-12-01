#include "inventory.h"
#include "inventory_item.h"

bool inventory::add_item(inventory_item *item) {
  if (_items.size() < _capacity) {
    _items.push_back(item);
    return true;
  }
  return false;
}

bool inventory::remove_item(unsigned int index) {
  if (_items.size() >= index) {
    _items.erase(_items.begin()+index);
    return true;
  }
  return false;
}

bool inventory::use_item(unsigned int index) {
  if (_items.size() >= index) {
    _items.at(index)->use(_owner);
    remove_item(index);
    return true;
  }
  return false;
}
