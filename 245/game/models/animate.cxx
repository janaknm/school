#include "animate.h"
#include "floor.h"
#include "../gui.h"

animate::animate(int max_health) {
  _max_health = max_health;
  _health = _max_health;
  flr = NULL;
}

void animate::attacked_by(animate *opponent) {
  int def_roll = 1 + rand() % health(),
    att_roll = 1 + rand() % (opponent)->health(),
    diff = abs(att_roll - def_roll);
  animate *loser;
  graphic what;
  
  // just for printing :/
  if (what_am_i() == PLAYER) {
    what = opponent->what_am_i();
    if (what == SNAKE) {
      gui_message("You are being attacked by a snake!");
    } else {
      gui_message("You are being attacked by a rat!");
    }
  } else {
    what = what_am_i();
    if (what == SNAKE) {
      gui_message("You are attacking a snake!");
    } else {
      gui_message("You are attacking a rat!");
    }
  }
  
  // different rolls
  if (diff > 0) {
    
    //pointer to loser
    loser = (def_roll < att_roll) ? this : opponent;
    
    // just print what happened
    if (loser->what_am_i() == PLAYER) {
      gui_message("You lost the fight and %d health!", diff);
    } else {
      gui_message("You won the fight and did %d damage!", diff);
    }

    // remove diff health
    loser->sub_health(diff);
    
  } else {
    gui_message ("Both of you miss!");
  }
}

void animate::sub_health(int n) {
  _health -= n;

  if(_health > _max_health) {
    _health = _max_health;
  }

  if(what_am_i() == PLAYER) {
    if(_health <= 0) {
      _health = 0;
      game.over(false);
    } 
    
    ((player *)this)->report();

    
  } else {
    if (_health <= 0) {

      // remove monster from the game
      game.get_level()->remove_monster(dynamic_cast<monster *>(this));

      // just print kill message
      if(what_am_i() == SNAKE) {
	gui_message("The snake died.");
      } else {
	gui_message("You killed a rat");
      }

      game.get_player()->level_up();
    }
  }
}
