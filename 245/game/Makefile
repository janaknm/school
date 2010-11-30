PATH=/home/phil/cs245sw/bin:/bin:/usr/bin
PROG=game

MODELS=animate.cxx \
drawable.cxx \
floor.cxx \
inanimate.cxx \
inventory_item.cxx \
level.cxx \
level_piece.cxx \
light_group.cxx \
monster.cxx \
player.cxx \

# Add your .cxx files here.  They need the .cxx extension.
SRCS=gui.cxx PlayArea.cxx game.cxx lexfile.cxx readgame.cxx $(MODELS:%.cxx=models/%.cxx)

OBJ1=$(SRCS:.cxx=.o)
OBJS=$(OBJ1:.cpp=.o)

CLEAN=$(OBJS) $(PROG) gui.h gui.cxx *~ testread .depend

#local fltk installations ....
FLTK=/usr

# applications
CXX=g++
FLUID=$(FLTK)/bin/fluid

# compile and link flags for NetBSD
CXXFLAGS= -g -Wall -I$(FLTK)/include -I/usr/X11R6/include  -I/usr/pkg/include
LDFLAGS= -L$(FLTK)/lib -L/usr/X11R6/lib  -L/usr/phkg/lib -R/usr/X11R6/lib  -R/usr/pkg/lib
LIBS=-lX11 -lfltk

# compile and link flags for cygwin (standard install of fltk)
#CXXFLAGS= -g
#LDFLAGS=
#LIBS= -lfltk

# how to comple
.SUFFIXES: .c .cpp .cxx .fl .o

.cxx.o:
	$(CXX) -c $(CXXFLAGS) -o $@ $<

.cpp.o:
	$(CXX) -c $(CXXFLAGS) -o $@ $<

# how to get .fl files ready to compile
.fl.cxx:
	$(FLUID) -c $<

# make the program

$(PROG): $(OBJS)
	$(CXX) -o $(PROG) $(LDFLAGS) $(OBJS) $(LIBS)

clean:
	rm -f $(CLEAN)

# testread

testread: lexfile.h lexfile.cxx readgame.cxx
	$(CXX) -o testread -DTESTREAD readgame.cxx lexfile.cxx

# making dependencies

