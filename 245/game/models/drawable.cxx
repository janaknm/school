#include "drawable.h"

#include "../gui.h"

void drawable::draw() {
  if(visible) {
    play_area->SetSquare(row, col, _sprite);
  }
}

void drawable::set_sprite(graphic g) {
  _sprite = g;
}
  
