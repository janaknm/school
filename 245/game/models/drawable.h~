#ifndef DRAWABLE_H
#define DRAWABLE_H

#include "../PlayArea.h"

//abstract base class for all objects that can be drawn on the screen
class drawable {

 public:
  drawable() { visible = false; }
  virtual ~drawable() {}
  
 private:
  graphic _sprite;

 public:
  bool visible;     //should we draw this object
  int row, col;     //position

  virtual void draw();      //draw graphic at position (if visible)
  void draw(graphic sprite);
  graphic what_am_i() { return _sprite; }
  void set_sprite(graphic g);

};


#endif
