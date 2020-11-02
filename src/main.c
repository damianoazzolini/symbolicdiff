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
	int status;
	char command[100] = "differentiate("; 	

	// if(argc > 1 && strcmp(argv[1],"-h") || strcmp(argv[1],"--help")) {
	// 	printf("pre pre pre alpha release\n");
	// 	printf("usage: ./symdiff <function> <variable>\n");
	// 	printf("example: ./symdif 2*x x\n");
	// 	exit(MANUAL_EXIT);
	// }

	if(argc <= 2) {
		print_manual();
		exit(MANUAL_EXIT);
	}

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
		execlp("swipl","swipl","-s","differentiate.pl","-g",command,"-t","halt",(char *)NULL);	
	}
    else {
		// printf("Waiting\n");
		wait(&status);
	} 
 	
}