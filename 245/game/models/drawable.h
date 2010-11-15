#ifndef DRAWABLE_H
#define DRAWABLE_H

#include "point.h"
#include "enum.h"

//abstract base class for all objects that can be drawn on the screen
class drawable {

 public:
  drawable();
  virtual ~drawable() = 0;

 private:
  sprite _graphic;

 public:
  void draw();      //draw graphic at position (if visible)
  point position;   //x,y coordinate on the level
  bool visible;     //should we draw this object
  
};


#endif
