#ifndef LEVEL_H
#define LEVEL_H

#include "animate.h"
#include "monster.h"
#include "level_piece.h"

#include <list>
#include <vector>

using std::list;

enum direction {WEST, NORTH, SOUTH, EAST, DOWN, UP};
class player;
class light_group;

//representation of a level in the dungeon
class level {

 public:
  level();
  ~level();
  
 private:
  list<monster *> _monsters;  
  list<light_group *> _light_groups;
  level_piece *_pieces[50][40];    
  int _srow, _scol;

  
  void check_right(int, int);
  void check_left(int, int);
  void check_down(int, int);
  void check_up(int, int);

  
public:
  void draw();
  void heal_monsters();
  void add_monster(monster *m);
  void remove_monster(monster *m);
  void next_state(player *p);    //make monsters move, etc.
  bool move_me(animate *obj, int row, int col);
  bool move_me(animate *obj, direction dir);
  void move_start(player *p);
  void set_start(int row, int col) {_srow = row; _scol = col;}
  void set_piece(int row, int col, level_piece *piece);
  void add_group(light_group *group) { _light_groups.push_back(group); }
  level_piece *get_piece(int row, int col);
  
};

#endif
