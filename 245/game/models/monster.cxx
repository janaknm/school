#include "../gui.h"
#include <cstdlib>

#include "monster.h"
#include "../game.h"

void monster::move(player *p) {
  int n;
  level *lvl = game.get_level();
  // in same room
  if (p->group() == group()) {
    n = 1 + rand() % 11;

    switch(n) {
    case 1:
      lvl->move_me(this, NORTH);
      break;

    case 2:
      lvl->move_me(this, EAST);
      break;

    case 3:
      lvl->move_me(this, SOUTH);
      break;

    case 4:
      lvl->move_me(this, WEST);
      break;

    case 5:
    case 6:
      break;

    default:
      // move towards player
      // todo: maybe add randomness?
      if (row < p->row) {
	lvl->move_me(this, row+1, col);
      } else if (row > p->row) {
	lvl->move_me(this, row-1, col);
      } else if (col < p->col) {
	lvl->move_me(this, row, col+1);
      } else {
	lvl->move_me(this, row, col-1);
      }
      
    }
    
  // different room
  } else {
    n = 1 + rand() % 6;
    switch(n) {
    case 1:
      lvl->move_me(this, NORTH);
      break;
      
    case 2:
      lvl->move_me(this, EAST);
      break;

    case 3:
      lvl->move_me(this, SOUTH);
      break;

    case 4:
      lvl->move_me(this, WEST);
      break;

    default:
      //no movement
      break;
    }

  }
}
