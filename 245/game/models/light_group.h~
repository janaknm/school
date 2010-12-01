#ifndef LIGHT_GROUP_H
#define LIGHT_GROUP_H

class level;

//groups level pieces together that start invisible, but can be illuminated
class light_group {

public:
  light_group(level *owner, int row, int col, int width, int height) :
    _owner(owner),
    _topx(col),
    _topy(row),
    _w(width),
    _h(height) {}

private:
  level *_owner;
  int _topx, _topy, _w, _h;

public:
  void illuminate();   //make all pieces in this group visible
  
};


#endif
