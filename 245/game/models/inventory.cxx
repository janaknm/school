#include "inventory.h"
#include "inventory_item.h"

bool inventory::add_item(inventory_item *item) {
  if (_items.size() == _capacity) {
    gui_message("Your inventory is full!");
    return false;
  }
  
  switch(item->what_am_i()) {
  case FOOD:
    gui_message("You found some food.");
    break;
  case DRINK:
    gui_message("You found a drink.");
    break;
  case DIAMOND:
    gui_message("You found the diamond.");
    break;
  default:
    gui_message("Where the hell did you get that?");
    break;
  }
  
  _items.push_back(item);
  return true;
}

inventory_item *inventory::drop(int index) {
  inventory_item *item = remove_item(index);

  if(item != NULL) {

    switch(item->what_am_i()) {
    case FOOD:
      gui_message("You dropped some food.");
      break;

    case DRINK:
      gui_message("You dropped a drink.");
      break;

    case DIAMOND:
      gui_message("You dropped the diamond.");
      break;

    default:
      gui_message("I don't know what you dropped...");
      break;
    }
    
  }

  return item;
}

inventory_item *inventory::remove_item(int index) {
  vector<inventory_item *>::iterator it;
  inventory_item *item;
  
  if (_items.size() <= index) {
    return NULL;
  }

  //get the item and hold on to it's pointer
  it = _items.begin() + index;
  item = *it;
  
  //remove it from the items
  _items.erase(it);
  
  return item;
}

void inventory::eat(int index) {
  inventory_item *item;
  
  if (_items.size() <= index) {
    gui_message("You don't have an item in that slot.");
    return;
  }

  item = *(_items.begin() + index);
  if (item->what_am_i() != FOOD) {
    gui_message("You can't eat that.");
    return;
  }

  _owner->eat();
  gui_message("mmm... You just ate some food.");

  // remove item from game entirely
  delete item;

  remove_item(index);
}

void inventory::drink(int index) {
  inventory_item *item;

  if(_items.size() <= index) {
    gui_message("You don't have an item in that slot.");
    return;
  }

  item = *(_items.begin() + index);
  if (item->what_am_i() != DRINK) {
    gui_message("You can't drink that.");
    return;
  }

  if(item->is_bad()) {
    gui_message("Uh oh, that was a drink of sickness.");
    _owner->sub_health(5);
  } else {
    gui_message("Yum, that was a drink of health.");
    _owner->heal();
  }

  _owner->report();
  _know_drinks = true;

  // remove item from game entirely
  delete item;

  remove_item(index);
}

void inventory::report() {
  int i=0;
  vector<inventory_item *>::iterator it;

  gui_message("Inventory:");

  if(_items.size() == 0) {
    gui_message("No items in your inventory.");
  }
  
  for(it = _items.begin(); it != _items.end(); it++) {
    i++;
    switch( (*it)->what_am_i() ) {
    case DRINK:
      if(!_know_drinks) {
	gui_message("%d: An unknown drink.", i);
      } else if ( (*it)->is_bad() ) {
	gui_message("%d: A drink of sickness.", i);
      } else {
	gui_message("%d: A drink of health.", i);
      }
      break;

    case FOOD:
      gui_message("%d: Some food.", i);
      break;

    case DIAMOND:
      gui_message("%d: The diamond.", i);
      break;

    default:
      gui_message("%d: Some whacky item", i);
      break;
    }
  }
}

bool inventory::has_diamond() {
  vector<inventory_item *>::iterator it;

  for(it = _items.begin(); it != _items.end(); it++) {
    if ( (*it)->what_am_i() == DIAMOND) {
      return true;
    }
  }

  return false;
}
