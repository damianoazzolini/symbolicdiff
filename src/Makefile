CFLAGS= -Wall -Wextra -pedantic
CFLAGSPEDANTIC= -Wfloat-equal -Wundef -Wshadow -Wpointer-arith -Wwrite-strings -Wunreachable-code -Winit-self -fsanitize=address -g
COMMONFLAGS= -Os
CC=gcc

# COMPILE=${CC} ${CFLAGS} ${CFLAGSPEDANTIC} ${COMMONFLAGS}
# -I /usr/local/lib/swipl/include/ -L /usr/local/lib/swipl/lib/x86_64-linux -g  main.c -lswipl -Wl,-rpath,/usr/local/lib/swipl/lib/x86_64-linux
INCLUDE = -I /usr/local/lib/swipl/include/
LIB_PATHS = -L /usr/local/lib/swipl/lib/x86_64-linux
SWIPL = -lswipl -Wl,-rpath,/usr/local/lib/swipl/lib/x86_64-linux

COMPILE=${CC} ${CFLAGS} -fpic ${INCLUDE} ${LIB_PATHS}

symdiff: main.o symdiff.o parser.o
	${COMPILE} -o symdiff main.o symdiff.o parser.o -lc  ${SWIPL}
	${COMPILE} -shared main.o symdiff.o parser.o -o libsymdiff.so  ${SWIPL}

main.o: main.c symdiff.h parser.h errors.h
	${COMPILE} -c main.c  ${SWIPL}

symdiff.o: symdiff.c symdiff.h errors.h
	${COMPILE} -c symdiff.c  ${SWIPL}

parser.o: parser.c parser.h errors.h
	${COMPILE} -c parser.c  ${SWIPL}

clean:
	rm symdiff *.o *.so

check:
	@echo "running prolog tests"
	swipl -s ../test/test.pl -g test -t halt