# make file for CS367, F08 assignment 2

CC= gcc
CFLAGS=  -g -Wall -DDEBUG
LDFLAGS= -g

all: rfa_serv rfa_cli mcat

rfa_serv: rfa_serv.o netlib.o 
	${CC} -o rfa_serv ${LDFLAGS} rfa_serv.o netlib.o

rfa_cli: rfa_cli.o netlib.o 
	${CC} -o rfa_cli ${LDFLAGS} rfa_cli.o netlib.o

clean:
	rm -f rfa_serv.o rfa_cli.o rfa_serv rfa_cli *~

chat_serv.o chat_cli: netlib.h
