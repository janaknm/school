#include "floor.h"
#include "level.h"
#include "../gui.h"
#include "../PlayArea.h"

level::level() {
  for(int i=0; i<50; i++) {
    for(int j=0; j<40; j++) {
      _pieces[i][j] = NULL;
    }
  }
}

level::~level() {
  list<monster *>::iterator m_iter;
  list<light_group *>::iterator g_iter;
  
  for(m_iter = _monsters.begin(); m_iter != _monsters.end(); m_iter++) {
    delete *m_iter;
  }
  
  for(g_iter = _light_groups.begin();
      g_iter != _light_groups.end();
      g_iter++) {
    delete *g_iter;
  }

  for(int i=0; i<50; i++) {
    for(int j=0; j<40; j++) {
      delete _pieces[i][j];
    }
  }

}

void level::draw() {
  level_piece *piece;

  for(int i=0; i<50; i++) {
    for(int j=0; j<40; j++) {
      piece = get_piece(i,j);
      if (piece != NULL) {
	piece->draw();
      } else {
	play_area->SetSquare(i, j, BLACK);
      }
    }
  }
}

void level::heal_monsters() {
  list<monster *>::iterator it;

  //heal all monsters by one
  for(it = _monsters.begin(); it != _monsters.end(); it++) {
    (*it)->sub_health(-1); // add one
  }
}

void level::add_monster(monster *m) {
  _monsters.push_back(m);
}

void level::remove_monster(monster *m) {
  list<monster *>::iterator it;
  floor *f = dynamic_cast<floor *>(get_piece(m->row, m->col));

  for(it = _monsters.begin(); it != _monsters.end(); it++) {
    if ( (*it) == m) {
      _monsters.erase(it);
    }
  }

  if(f != NULL) {
    f->set_occupied( (animate *) NULL);
    f->draw();
  } else {
    gui_message("uhh... where was the monster standing?");
  }

}

void level::next_state(player *p) {
  list<monster *>::iterator m_iter;
  
  //make all the monsters move
  for(m_iter = _monsters.begin(); m_iter != _monsters.end(); m_iter++) {
    (*m_iter)->move(p);
    (*m_iter)->has_fought = false;
  }
  
}

void level::move_start(player *p) {
  move_me(p, _srow, _scol);
}

bool level::move_me(animate *obj, int row, int col) {
  floor *piece = dynamic_cast<floor *>(get_piece(row, col));
  player *p;
  
  //invalid piece (bad position or wasn't a floor piece)
  if (piece == NULL) {
    return false;
  } else if (piece->has_animate()) {
    piece->fight(obj);
  } else {
    //remove old piece

    if (obj->flr != NULL) {
      obj->flr->set_occupied( (animate *) NULL);
      obj->flr->draw();
    } else {
      gui_message("obj wasn't on a floor before?");
    }

    //set new piece
    piece->set_occupied(obj);
    piece->draw();
    
    //if animate is player, interact with piece
    p = dynamic_cast<player *>(obj);
    if(p != NULL) {
      piece->interact(p);
      piece->group()->illuminate();
      check_right(row+1, col);
      check_left(row-1, col);
      check_up(row, col+1);
      check_down(row, col-1);
    }

  }

  return true;

}

void level::check_right(int row, int col) {
  level_piece *piece = get_piece(row, col);
  if(piece == NULL || piece->visible || piece->group()->gtype() == ROOM) {
    return;
  }
  
  piece->visible = true;
  piece->draw();
  check_right(row+1, col);

}

void level::check_left(int row, int col) {
  level_piece *piece = get_piece(row, col);
  if(piece == NULL || piece->visible || piece->group()->gtype() == ROOM) {
    return;
  }

  piece->visible = true;
  piece->draw();
  check_left(row-1, col);
}

void level::check_up(int row, int col) {
  level_piece *piece = get_piece(row, col);
  if(piece == NULL || piece->visible || piece->group()->gtype() == ROOM) {
    return;
  }

  piece->visible = true;
  piece->draw();
  check_up(row, col+1);
}

void level::check_down(int row, int col) {
  level_piece *piece = get_piece(row, col);
  if(piece == NULL || piece->visible || piece->group()->gtype() == ROOM) {
    return;
  }

  piece->visible = true;
  piece->draw();
  check_down(row, col-1);
}

bool level::move_me(animate *obj, direction dir) {
  switch(dir) {

  case NORTH:
    return move_me(obj, obj->row, obj->col -1);
    break;

  case EAST:
    return move_me(obj, obj->row+1, obj->col);
    break;

  case SOUTH:
    return move_me(obj, obj->row, obj->col+1);
    break;

  case WEST:
    return move_me(obj, obj->row-1, obj->col);
    break;

  default:
    return false;
    
  }
}

void level::set_piece(int row, int col, level_piece *piece) {
  level_piece *old_piece;
  
  if (row >= 0 && row < 50 && col < 40 && col >= 0) {
    old_piece = get_piece(row, col);
    
    if (old_piece != NULL) {
      //printf("DELETED OLD PIECE, %d,%d\n", old_piece->row, old_piece->col);
      //delete old_piece;
      old_piece = NULL;
    }

    piece->row = row;
    piece->col = col;
    
    _pieces[row][col] = piece;
    
  } else {
      // game.error("can't access _pieces[%d][%d]", row, col);
  }
}

level_piece *level::get_piece(int row, int col) {
  if (row >= 0 && row < 50 && col < 40 && col >= 0) {
    return _pieces[row][col];
  }

  //piece not found
  return NULL;
}
