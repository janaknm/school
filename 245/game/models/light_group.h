#ifndef LIGHT_GROUP_H
#define LIGHT_GROUP_H

#include <vector>
#include "level_piece.h"

//groups level pieces together that start invisible, but can be illuminated
class light_group {

public:
  light_group();

private:
  vector<level_piece> _pieces;

public:
  void illuminate();   //make all pieces in this group visible
  
};


#endif
