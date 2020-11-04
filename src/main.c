#include <stdio.h>
// #include <SWI-Prolog.h>
#include "symdiff.h"
#include <stdlib.h>
#include <sys/types.h> 
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>

#define SYMDIFF_VERSION 0.1
#define FORK_ERROR_EXIT -2
#define MANUAL_EXIT -1

void print_manual() {
	printf("SYMDIFF - compute symbolic derivations\n");
	printf("usage: symdiff <function> <variable>\n");
	printf("example: symdiff \"3*x^2\" \"x\"\n");
	printf("example: symdiff \"3*x^2 + y\" \"[x,y]\"\n");
	printf("options: \n");
	printf("\t-p --print-steps: \n");
	printf("\t-t --tex: \n");
	printf("\t-e --evaluate: \n");
	printf("\t-h --hessian: \n");
	printf("\t-j --jacobian: \n");
	printf("\t-i --interactive: \n");
}

int main(int argc, char **argv) { 
	int pid;
	int status, nbytes;
	int fd[2];
	char command[100] = "evaluate(";
	char readbuffer[100];

	if(argc <= 2) {
		print_manual();
		exit(MANUAL_EXIT);
	}

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