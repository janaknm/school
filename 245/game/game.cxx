// game.cxx -- the implementation part of the interface

#include "gui.h"
#include "game.h"

#include "models/level.h"
#include "models/player.h"
#include "models/floor.h"
#include "models/inventory_item.h"
#include "models/inanimate.h"

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
				 height);
  for(int i=row; i<row+width; i++) {

    for(int j=col; j<col+height; j++) {
	
      piece = (i==row || i==row+width-1 || j==col || j==col+height-1)
	? new level_piece(_build_group, WALL)
	: new floor(_build_group);

      piece->visible = true;
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
  
  
  _build_group = new light_group(_current_level,
				 minx,
				 miny,
				 width,
				 height);
				 
				 
  for(int i=minx; i < minx + width; i++) {

    for(int j=miny; j < miny + height; j++) {

      piece = new floor(_build_group, PATH);
      piece->visible = true;
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
    
  case t_up: {
    level_piece *piece = new level_piece(_build_group, GOUP);
    _current_level->set_piece(row, col, piece);
  }
    break;

  case t_down: {
    level_piece *piece = new level_piece(_build_group, GODOWN);
    _current_level->set_piece(row, col, piece);
  }
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
    // RANDOM HEALTH
    
    monster *m = new monster(10, RAT);

    f->set_occupied(m);
      
   }
    
   break;
   
  case t_snake: {
    // RANDOM HEALTH
    
    monster *m = new monster(10, SNAKE);

    f->set_occupied(m);
      
  }
    
    break;

    
  case t_food: {
    inventory_item *item = new inventory_item(FOOD);
    f->set_occupied(item);
  }
    break;

  case t_arrow:
    //printf("ARROW TRAP");
    break;

  case t_transport:
    // printf("TRANSPORT TRAP");
    break;

  case t_sickness: {
    inventory_item *item = new inventory_item(DRINK);
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
  if(dir == UP) {
    _change_level(_level_depth-1);
  } else if(dir == DOWN) {
    _change_level(_level_depth+1);
  }
}

void Game::_change_level(int depth) {
  if (depth >= 0 && depth < _levels.size()) {
    _level_depth = depth;
    _current_level = _levels[depth];
    _current_level->draw();
  } else {
    printf("Cant go to level %d", depth);
  }
}

// Routines to play the game

void Game::start(void)
{
  playing = true;

  _change_level(0);
    
  _player = new player();
  _current_level->move_start(_player);
  
  
  /*
  // The following shows you how to set some elements of the gui.
  // YOU NEED TO REPLACE THIS WITH YOUR REAL START CODE ...

  gui_level->value("1");
  gui_health->value("10/10");
  gui_gold->value("0");

  gui_message("Welcome to the game!");

  int x, y;

  for (x = 0; x<50; x++) play_area->SetSquare(x,2,WHITE);
  for (x = 0; x<50; x++) play_area->SetSquare(x,4,WALL);
  for (x = 0; x<50; x++) play_area->SetSquare(x,6,PATH);
  for (x = 0; x<50; x++) play_area->SetSquare(x,8,DIAMOND);
  for (x = 0; x<50; x++) play_area->SetSquare(x,10,GOLD);
  for (x = 0; x<50; x++) play_area->SetSquare(x,12,FOOD);
  for (x = 0; x<50; x++) play_area->SetSquare(x,13,ATRAP);
  for (x = 0; x<50; x++) play_area->SetSquare(x,14,DRINK);
  for (x = 0; x<50; x++) play_area->SetSquare(x,15,TTRAP);
  for (x = 0; x<50; x++) play_area->SetSquare(x,16,SNAKE);
  for (x = 0; x<50; x++) play_area->SetSquare(x,17,RAT);

  for (x=10; x<30; x++)
    for ( y=20; y<27; y++)
      play_area->SetSquare(x, y,
			   (x==10 || x== 29 || y==20 || y==26 ? WALL
			    : WHITE));
  play_area->SetSquare(15, 22, GOUP);
  play_area->SetSquare(25, 24, GODOWN);
  play_area->SetSquare(20, 23, PLAYER);

  // End of code you need to replace ....
  */
}

void Game::quit(void)
{
  if (!playing || (fl_choice ("Quit the game?","yes","no",NULL)==0))
    exit(0);
}

void Game::inventory(void)
{
  CHECK_PLAYING;
  gui_message("You are carrying nothing!");
}

void Game::drop(void)
{
  CHECK_PLAYING;

  gui_message("drop -> %s", gui_in->value());
  // clear the gui_in element
  gui_in->value("");
}

void Game::eat(void)
{
  CHECK_PLAYING;

  gui_message ("eat -> %s", gui_in->value());
  // clear the gui_in element
  gui_in->value("");
}

void Game::drink(void)
{
  CHECK_PLAYING;

  gui_message("drink -> %s", gui_in->value());
  // clear the gui_in element
  gui_in->value("");
}

void Game::move (direction dir)
{
  CHECK_PLAYING;
  if (debug)
    printf ("Move %d\n", dir);
  
  switch (dir) {
  case UP:
  case DOWN:
    _change_level(dir);
    break;

  default:
    _current_level->move_me(_player, dir);
    break;
  }
}



