CFLAGS= -Wall -Wextra -pedantic
CFLAGSPEDANTIC= -Wfloat-equal -Wundef -Wshadow -Wpointer-arith -Wwrite-strings -Wunreachable-code -Winit-self -fsanitize=address
COMMONFLAGS= -Os
CC=gcc

# COMPILE=${CC} ${CFLAGS} ${CFLAGSPEDANTIC} ${COMMONFLAGS}

COMPILE=${CC} ${CFLAGS}


symdiff: main.o symdiff.o
	${COMPILE} -o symdiff main.o symdiff.o -lc

main.o: main.c symdiff.h
	${COMPILE} -c main.c

symdiff.o: symdiff.c symdiff.h
	${COMPILE} -c symdiff.c

clean:
	rm symdiff symdiff.o main.o

check:
	@echo "running prolog tests"
	swipl -s test/test.pl -g test -t halt