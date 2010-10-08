CC=g++
CFLAGS=-c -Wall
OBJ=assg1.o

all:
	gmake assg1

%.o: %.cpp
	$(CC) $(CFLAGS) -o $@ $<

assg1: $(OBJ)
	$(CC) -o $@ $^
