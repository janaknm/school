// game.h  -- interface between the gui and the game engine

#ifndef GAME_H
#define GAME_H

#include "models/player.h"
#include "models/light_group.h"
#include "models/level.h"

#include "gui.h"
#include "lexfile.h"
#include <iostream>
#include <vector>

// types

class Game {

 public:

  // Default constructor ... only one needed ...
  // May want to add code to initialize student defined
  // private data.

  Game() : had_error(false), playing(false), played(false) {
    _current_level = NULL;
    _build_group = NULL;
    _player = NULL;
    _player_moves = 0;
    _player_pos_moves = 0;
  };

  // Routines to build the game

  void SetBuildLevel (int newlevel);
  void NewRoom (int row, int col, int width, int height);
  void NewPath (int row1, int col1, int row2, int col2);  
  void SetStart (int row, int col);
  void PlaceAt (token what, int row, int col);

  // routines to play the game

  void start(void);
  void quit(void);
  void inventory(void);
  void drop(void);
  void eat(void);
  void drink(void);
  void move (direction dir);
  void teleport_player();

  // Other utility routines ..

  void error (char *fmt, ...);  

  int getMaxLevel() { return 10; };
  
 private:
  bool had_error;
  bool playing;
  bool played;

private:
  int _level_depth;
  int _player_moves;
  int _player_pos_moves;
  vector<level *> _levels;
  player *_player;
  level *_current_level;
  light_group *_build_group;
  void _change_level(int depth);
  void _change_level(direction dir);
  void _clear();

public:
  player *get_player() { return _player; };
  level *get_level() { return _current_level; }
  void over(bool won);
  
};

#define CHECK_PLAYING  \
  if (!playing) { \
    fl_alert("Not playing a game."); \
    return ; \
  }

#endif
