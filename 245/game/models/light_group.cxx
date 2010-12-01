#include "light_group.h"
#include "../gui.h"

void light_group::illuminate() {
  level_piece *piece;
  
  if(_lit) {
    return;
  }

  _lit = true;

  for(int i = _row; i < _row + _w; i++) {
    for(int j = _col; j < _col + _h; j++) {
      piece = _owner->get_piece(i, j);
      if(piece != NULL) {
	piece->set_visible();
	piece->draw();
      }
    }
  }
}
