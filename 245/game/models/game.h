#ifndef GAME_H
#define GAME_H

#include "level.h"
#include "player.h"
#include "enum.h"

//main driver for the game, holds all important info
class game {
 public:
  game();
  ~game();
  
 private:
  level* _levels;           //all levels in this game
  player* _current_player;  //current player pointer
  level* _current_level;    //current level pointer

 public:
  level* get_level();      //accessor for level
  player* get_player();    //accessor for player
  
  void use_stairs(stair_direction dir); //go up/down stairs (checking if player is standing on correct stairs)
};

#endif GAME_H
