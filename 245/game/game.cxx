// game.cxx -- the implementation part of the interface

#include "gui.h"
#include "game.h"

#include "models/level.h"
#include "models/player.h"
#include "models/floor.h"
#include "models/inventory_item.h"
#include "models/inanimate.h"
#include "models/inventory.h"

#include <FL/fl_ask.h>
#include <cstdio>
#include <cstdlib>
#include <cstdarg>
using namespace std;

// Utility routine:  called like printf.

void Game::error(char *fmt, ...)
{
  va_list ap;
  char mesg[1024]; 

  had_error = true;
  va_start(ap,fmt);
  vsnprintf (mesg, 1024, fmt, ap);
  va_end(ap);
  cerr << mesg << endl; 
}

// All routines from here on need to be changed by the student!

// Routines to build the game

void Game::SetBuildLevel (int newlevel)
{ 
  if (debug) printf ("SetBuildLevel -> %d.\n", newlevel);
  
  if (_levels.size() <= newlevel) {
    _current_level = new level();
    _levels.push_back(_current_level);
    _level_depth = newlevel;
    
    if (debug) printf ("added new level, _levels.size() = %d\n", _levels.size());
    
  } else {
    _current_level = _levels[newlevel];

    if (debug) printf("set build level out of order...\n");
  }
  
}

void Game::NewRoom (int row, int col, int width, int height)
{
  level_piece *piece;
  
  if (debug) printf ("NewRoom(%d,%d,%d,%d)\n", row, col, width, height);

  _build_group = new light_group(_current_level,
				 row,
				 col,
				 width,
				 height,
				 ROOM);
  for(int i=row; i<row+width; i++) {

    for(int j=col; j<col+height; j++) {
	
      piece = (i==row || i==row+width-1 || j==col || j==col+height-1)
	? new level_piece(_build_group, WALL)
	: new floor(_build_group);

      _current_level->set_piece(i, j, piece);
	  
    }
  }

  _current_level->add_group(_build_group);
    
    
}

void Game::NewPath (int row1, int col1, int row2, int col2)
{
  if (debug) printf ("NewPath: (%d,%d) -> (%d,%d)\n", row1, col1, row2, col2);

  int minx = (row1 < row2) ? row1 : row2,
    miny = (col1 < col2) ? col1 : col2,
    width = abs(row2 - row1) + 1,
    height = abs(col2 - col1) + 1;

  level_piece *piece;

  group_type gtype = (width == 1) ? VERTICAL : HORIZONTAL;
  
  
  _build_group = new light_group(_current_level,
				 minx,
				 miny,
				 width,
				 height,
				 gtype);

  _current_level->add_group(_build_group);
				 
				 
  for(int i=minx; i < minx + width; i++) {

    for(int j=miny; j < miny + height; j++) {

      piece = new floor(_build_group, PATH);
      _current_level->set_piece(i, j, piece);
      
    }
    
  }
  
}  

void Game::SetStart (int row, int col)
{
  if (debug) printf ("Level starts at (%d,%d)\n", row, col);
  if (_current_level != NULL) {
    _current_level->set_start(row, col);
  } else {
    error("trying to set start location without a level");
  }
}

void Game::PlaceAt (token what, int row, int col)
{
  floor *f = dynamic_cast<floor *>(_current_level->get_piece(row, col)); 

  if (f == NULL) {
    printf("Can't place that here!");
    return;
  }
  
  if (debug) printf ("Place %s at (%d,%d)\n", tok_name[what], row, col);
  if (debug && what == t_diamond)
    printf ("Place the diamond at (%d,%d)...\n", row, col);

  switch(what) {
    
  case t_up: 
    f->set_sprite(GOUP);
    break;

  case t_down: 
    f->set_sprite(GODOWN);
    break;

  case t_diamond: {
    inventory_item *item = new inventory_item(DIAMOND);
    f->set_occupied(item);
  }
    break;

  case t_gold: {
    inanimate *item = new inanimate(GOLD);
    f->set_occupied(item);
  }
    break;

  case t_rat: {
    int health = 7 + (1 + rand() % (_level_depth + 1));
    monster *m = new monster(health, RAT);

    f->set_occupied(m);
    _current_level->add_monster(m);
   }
    break;
   
  case t_snake: {
    int health = 7 + (1 + rand() % (_level_depth + 1));
    monster *m = new monster(health, SNAKE);
    f->set_occupied(m);
    _current_level->add_monster(m);
  }
    break;
    
  case t_food: {
    inventory_item *item = new inventory_item(FOOD);
    f->set_occupied(item);
  }
    break;

  case t_arrow:
    f->set_sprite(ATRAP);
    f->set_seen(false);
    break;

  case t_transport:
    f->set_sprite(TTRAP);
    f->set_seen(false);
    break;

  case t_sickness: {
    inventory_item *item = new inventory_item(DRINK, true);
    f->set_occupied(item);
  }
    break;

  case t_health: {
    inventory_item *item = new inventory_item(DRINK);
    f->set_occupied(item);
  }
    break;

  default:
    break;
  }
    
}

void Game::_change_level(direction dir) {
  floor *f = dynamic_cast<floor *>(_current_level->get_piece(_player->row, _player->col));
  if(dir == UP) {
    if(f != NULL && f->what_am_i() == GOUP) {
      _change_level(_level_depth-1);
    } else {
      gui_message("You aren't standing on up-stairs");
    }
  } else if(dir == DOWN) {
    if (f != NULL && f->what_am_i() == GODOWN) {
      _change_level(_level_depth+1);
    } else {
      gui_message("You aren't standing on down-stairs");
    }
  }
}

void Game::_change_level(int depth) {
  char msg[10];
  if (depth >= 0 && depth < _levels.size()) {
    
    _level_depth = depth;
    _clear();
    _current_level = _levels[depth];
    _current_level->move_start(_player);
    _current_level->draw();
    sprintf(msg, "%d", depth+1);
    gui_level->value(msg);
  } else {
    // going out of the dungeon
    if (depth == -1) {
      if (_player->has_diamond()) {
	game.over(true);
      } else {
	game.over(false);
      }
    }
  }
}

void Game::_clear() {
  for(int i=0; i < 50; i++) {
    for( int j=0; j < 40; j++) {
      play_area->SetSquare(i, j, BLACK);
    }
  }
}

// Routines to play the game

void Game::start(void)
{
  if (!played) {
    playing = true;

    _player = new player();
    _player->report();

    _change_level(0);
  }
}

void Game::quit(void)
{
  if (!playing || (fl_choice ("Quit the game?","yes","no",NULL)==0))
    exit(0);
}

void Game::inventory(void)
{
  CHECK_PLAYING;
  _player->inv->report();
}

void Game::drop(void)
{
  CHECK_PLAYING;
  int index = atoi( gui_in->value() ) - 1,
      row, col;
  inventory_item *item = _player->inv->drop(index);
  floor *f;

  if (item == NULL) {
    gui_message("You don't have an item in that slot.");
  } else {
    //get piece player's standing on
    row = _player->row;
    col = _player->col;
    f = dynamic_cast<floor *>(_current_level-> get_piece(row, col));

    //if it's a real spot, drop it there
    if (f != NULL) {
      f->set_occupied(item);
      
    //invalid location?
    } else {
      gui_message("wtf, where are you standing?");
    }
  }
  
  gui_in->value("");
}

void Game::eat(void)
{
  CHECK_PLAYING;
  int index = atoi( gui_in->value() ) - 1;

  _player->inv->eat(index);
  
  gui_in->value("");
}

void Game::drink(void)
{
  CHECK_PLAYING;
  int index = atoi( gui_in->value() ) - 1;

  _player->inv->drink(index);
  
  gui_in->value("");
}

void Game::move (direction dir)
{
  CHECK_PLAYING;

  bool moved = false;
  
  if (debug)
    printf ("Move %d\n", dir);
  
  switch (dir) {
  case UP:
  case DOWN:
    _change_level(dir);
    return;
    break;

  default:
    moved = _current_level->move_me(_player, dir);
    if(!moved) {
      gui_message("You can't move there!");
    } 
    break;
  }

  if(moved) {

    // always do this
    _player_moves++;
    _player->sub_hunger(1);
    _player->group()->illuminate();
    _current_level->next_state(_player);
    
    // if health is positive, keep track of steps
    if(_player->hunger() > 0) {
      _player_pos_moves++;
    } else {
      _player_pos_moves = 0;
    }

    // if we've been positive for 10 steps, heal
    if (_player_pos_moves == 10) {
      _player_pos_moves = 0;
      _player->sub_health(-1); //add 1
    }

    // heal monsters after 15 moves regardless of hunger
    if (_player_moves % 15 == 0) {
      _current_level->heal_monsters();
    }

  }
}

void Game::teleport_player() {
  bool moved = false;
  int row, col;

  while(!moved) {
    row = rand() % 50;
    col = rand() % 40;
    moved = _current_level->move_me(_player, row, col);
  }
  
}

void Game::over(bool won) {
  playing = false;
  played = true;
  if (won) {
    fl_alert("Congratulations, you beat the game.");
  } else {
    fl_alert("Gameover: You lost.");
  }
}



