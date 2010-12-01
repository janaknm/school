#ifndef LIGHT_GROUP_H
#define LIGHT_GROUP_H

class level;

enum group_type { ROOM, HORIZONTAL, VERTICAL };

//groups level pieces together that start invisible, but can be illuminated
class light_group {

public:
  light_group(level *owner, int row, int col, int width, int height, group_type gtype) :
    _owner(owner),
    _row(row),
    _col(col),
    _w(width),
    _h(height),
    _lit(false),
    _gtype(gtype) {}

private:
  level *_owner;
  int _row, _col, _w, _h;
  bool _lit;
  group_type _gtype;

public:
  void illuminate();   //make all pieces in this group visible
  group_type gtype() { return _gtype; }
  
};


#endif
