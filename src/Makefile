CFLAGS= -Wall -Wextra -pedantic
CFLAGSPEDANTIC= -Wfloat-equal -Wundef -Wshadow -Wpointer-arith -Wwrite-strings -Wunreachable-code -Winit-self -fsanitize=address
COMMONFLAGS= -Os
CC=gcc

# COMPILE=${CC} ${CFLAGS} ${CFLAGSPEDANTIC} ${COMMONFLAGS}

COMPILE=${CC} ${CFLAGS} -fpic

symdiff: main.o symdiff.o parser.o
	${COMPILE} -o symdiff main.o symdiff.o parser.o -lc
	${COMPILE} -shared main.o symdiff.o -o libsymdiff.so

main.o: main.c symdiff.h parser.h
	${COMPILE} -c main.c

symdiff.o: symdiff.c symdiff.h
	${COMPILE} -c symdiff.c

parser.o: parser.c parser.h
	${COMPILE} -c parser.c

clean:
	rm symdiff *.o *.so

check:
	@echo "running prolog tests"
	swipl -s ../test/test.pl -g test -t halt