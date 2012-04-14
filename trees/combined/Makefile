SRC=trees
OBJ=${SRC:.tex=.aux}
all: ${SRC}.tex
	pdflatex ${SRC}
	bibtex ${SRC}
	pdflatex ${SRC}
	pdflatex ${SRC}
clean:
	rm ${OBJ}.aux
