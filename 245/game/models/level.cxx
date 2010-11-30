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

void level::next_state(player *p) {
  list<monster *>::iterator m_iter;
  
  //make all the monsters move
  for(m_iter = _monsters.begin(); m_iter != _monsters.end(); m_iter++) {
    (*m_iter)->move(p);
  }
  
}

void level::move_start(player *p) {
  move_me(p, _srow, _scol);
}

bool level::move_me(animate *obj, int row, int col) {
  floor *piece = dynamic_cast<floor *>(get_piece(row, col));
  floor *old_piece;

  //invalid piece (bad position or wasn't a floor piece)
  if (piece == NULL) {
    return false;
  }

  //remove obj from old piece
  old_piece = dynamic_cast<floor *>(get_piece(obj->row, obj->col));
  if (old_piece != NULL) {
    old_piece->set_occupied( (animate *) NULL );
    old_piece->draw();
  }

  obj->row = row;
  obj->col = col;
  
  piece->interact(obj);
  piece->draw();
  
  return true;
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
