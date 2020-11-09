#include <stdio.h>
// #include <SWI-Prolog.h>
#include <argp.h>
#include "symdiff.h"
#include "parser.h"
#include <stdlib.h>
#include <sys/types.h> 
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>

// #define SYMDIFF_VERSION 0.1
#define FORK_ERROR_EXIT -2

int main(int argc, char **argv) { 
	int pid;
	int status, nbytes;
	int fd[2];
	char command[100] = "evaluate(";
	char readbuffer[100];
	struct arguments arguments;

	parse_arguments(argc,argv,&arguments);

	pipe(fd);

	strcat(command,argv[1]);
	strcat(command,",");
	strcat(command,argv[2]);
	strcat(command,").");

	pid = fork();
    if (pid < 0) {
		printf("Fork error\n");
        exit(FORK_ERROR_EXIT);
	}
    if (pid == 0) {
		close(fd[0]);
		close(1);
		dup(fd[1]);
		execlp("swipl","swipl","-s","differentiate.pl","-g",command,"-t","halt",(char *)NULL);	
	}
    else {
		printf("Waiting\n");
		close(fd[1]);
		close(0);
		dup(fd[0]);
		wait(&status);
		nbytes = read(fd[0], readbuffer, sizeof(readbuffer));
		printf("Received string: %s", readbuffer);
	} 

	return 0;
 	
}