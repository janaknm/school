#include "player.h"
#include "inventory_item.h"
#include "inventory.h"
#include "util.h"				

#include "../gui.h"

player::player() : animate(10),
		   _hunger(200),
		   _max_hunger(200),
		   _gold(0)
{
  inv = new inventory(this);
  set_sprite(PLAYER);
}
  
player::~player() { delete inv; }


void player::add_gold(int n) {
  _gold += n;
  gui_message("You found %d gold.", n);
  report();
}

void player::report() {
  char msg[20];

  sprintf(msg, "%d/%d", _health, _max_health);
  gui_health->value(msg);

  sprintf(msg, "%d", _gold);
  gui_gold->value(msg);
}

void player::sub_hunger(int n) {
  _hunger -= n;
  if (_hunger == 0) {
    gui_message("You are hungry.");
  } else if (_hunger == -25) {
    gui_message("You are very hungry.");
  }

  if (_hunger < 0 && _hunger % 5 == 0) {
    sub_health(1);
  }
  
  report();
}

void player::eat() {
  _hunger = _max_hunger;
  report();
}

void player::heal() {
  _health = _max_health;
  report();
}

void player::level_up() {
  _max_health++;
  report();
}

bool player::has_diamond() {
  return inv->has_diamond();
}
