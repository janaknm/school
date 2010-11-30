#include "floor.h"

#include "../gui.h"

void floor::interact(animate *obj) {
  if (_occupied_animate == NULL) {
    
    set_occupied(obj);
  } else {
    //fight code!!
  }
}

void floor::set_occupied(animate *obj) {
  if (obj == NULL) {
    _occupied_animate = NULL;
  } else {
    _occupied_animate = obj;
    obj->row = row;
    obj->col = col;
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
  } else {
    drawable::draw();
  }
}




