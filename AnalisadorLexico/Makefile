all: goianinha

goianinha: goianinha.c main.c
	gcc -o goianinha goianinha.c main.c

goianinha.c: goianinha.l
	flex -o goianinha.c goianinha.l

clean:
	rm -f goianinha goianinha.c lex.yy.c
