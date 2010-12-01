#include "floor.h"

#include "../gui.h"
#include "../game.h"
#include "../PlayArea.h"

#include "inventory.h"

#include <cstdlib>

void floor::set_visible() {
  visible = true;
  if(_occupied_inanimate != NULL) {
    _occupied_inanimate->visible = true;
  }
  if(_occupied_animate != NULL) {
    _occupied_animate->visible = true;
  }
}

void floor::interact(player *p) {
  graphic what = what_am_i();
  inanimate *in = _occupied_inanimate;
  int g_amt;
  bool added = false;

  if (in != NULL) {
    switch(in->what_am_i()) {
    case GOLD:
      g_amt = 5 + rand() % 96;
      p->add_gold(g_amt);

      //delete gold from the game
      delete in;
      _occupied_inanimate = NULL;
      break;

    case FOOD:
    case DRINK:
    case DIAMOND:
      //if we were able to pick it up, then remove it from this floor piece so it isn't drawn
      added = p->inv->add_item( dynamic_cast<inventory_item *>(_occupied_inanimate) );
      if(added) {
	_occupied_inanimate = NULL;
      }
      break;
      
    default:
      gui_message("Where did you get that??");
      break;
    }
  }
  
  if(what == ATRAP) {
    p->sub_health(1);
    gui_message("You landed on an arrow trap!");
    _seen = true;
  } else if (what == TTRAP) {
    game.teleport_player();
    gui_message("You landed on a teleport trap!");
    _seen = true;
  }
  draw();
}

void floor::fight(animate *obj) {
  player *p;
  monster *m;

  //fight validation::
  
  // try casting attacker as a player
  p = dynamic_cast<player *>(obj);
  if (p != NULL) {

    // try casting occupied as monster
    m = dynamic_cast<monster *>(_occupied_animate);
    if (m != NULL && !m->has_fought) {

      // success, fight
      _occupied_animate->attacked_by(obj);
      m->has_fought = true;
      return;
    }

  } else {
    // try casting occupied as player
    p = dynamic_cast<player *>(_occupied_animate);
    
    if (p != NULL) {

      // try casting attacker as monster
      m = dynamic_cast<monster *>(obj);
      if (m != NULL && !m->has_fought ) {

	// success, fight
	_occupied_animate->attacked_by(obj);
	m->has_fought = true;
	return;
      }
    }
  }
  
  // either: no player involved or monster already fought
  // do nothing
}

void floor::set_occupied(animate *obj) {
  if (obj == NULL) {
    _occupied_animate = NULL;
  } else {
    _occupied_animate = obj;
    obj->flr = this;
    obj->row = row;
    obj->col = col;
    obj->set_group(_group);
  }
}

void floor::set_occupied(inanimate *obj) {
  if (_occupied_inanimate == NULL) {
    _occupied_inanimate = obj;
    obj->row = row;
    obj->col = col;
  } else {
    printf("ERRRORRRRORROROROROORORRRRR");
  }
}

void floor::draw() {
  if(_occupied_animate != NULL) {
    _occupied_animate->draw();
  } else if(_occupied_inanimate != NULL) {
    _occupied_inanimate->draw();
  } else if (_seen) {
    drawable::draw();
  } else {
    drawable::draw(WHITE);
  }
}




