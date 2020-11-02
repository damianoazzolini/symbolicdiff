#include "symdiff.h"

double evaluate(char *function, char *variable) {
    return 0;
}

char* symbolic_differentiate(char *function, char *variable) {
    // char command[100];
    // int pid;

    // strcat(command,function);
	// strcat(command,",");
	// strcat(command,variable);
	// strcat(command,").");

    // pid = fork();
    // if (pid < 0) {
	// 	printf("Fork error\n");
    //     exit(FORK_ERROR_EXIT);
	// }
    // if (pid == 0) {
	// 	execlp("swipl","swipl","-s","differentiate.pl","-g",command,"-t","halt",(char *)NULL);	
	// }
    // else {
	// 	wait(&status);
	// } 

    return '_';
}

char* jacobian(char *function) {
    return '_';
}

char* hessian(char *function) {
    return '_';
}