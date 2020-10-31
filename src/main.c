#include <stdio.h>
// #include <SWI-Prolog.h>
#include <stdlib.h>
#include <sys/types.h> 
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>

#define FORK_ERROR_EXIT -1
#define MANUAL_EXIT 0

int main(int argc, char **argv) { 
	int pid = fork();
	int status;
	char command[100] = "differentiate("; 	

	// if(argc > 1 && strcmp(argv[1],"-h") || strcmp(argv[1],"--help")) {
	// 	printf("pre pre pre alpha release\n");
	// 	printf("usage: ./symdiff <function> <variable>\n");
	// 	printf("example: ./symdif 2*x x\n");
	// 	exit(MANUAL_EXIT);
	// }

	strcat(command,argv[1]);
	strcat(command,",");
	strcat(command,argv[2]);
	strcat(command,").");

	
    if (pid < 0) {
		printf("Fork error\n");
        exit(FORK_ERROR_EXIT);
	}
    if (pid == 0) {
		execlp("swipl","swipl","-s","src/differentiate.pl","-g",command,"-t","halt",(char *)NULL);	
	}
    else {
		// printf("Waiting\n");
		wait(&status);
	} 
 	
}