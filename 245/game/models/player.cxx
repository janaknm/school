#include "player.h"
#include "inventory_item.h"
#include "inventory.h"
#include "util.h"				
					       

string player::get_hunger_str() {
  return to_string(_hunger) + "/" + to_string(_max_hunger);
}

string player::get_gold_str() {
  return to_string(_gold);
}

void player::add_gold(int n) { _gold += n; }

bool player::obtain(inanimate *obj) {
  return obj->be_obtained(this);
}

bool player::add_item(inventory_item *item) {
  return _inv->add_item(item);
}

bool player::use_item(int index) {
  return _inv->use_item(index);
}
  
