#include "symdiff.h"

// char *exec_wrapper(char *command) {
//     int pid = fork();
//     if (pid < 0) {
// 		printf("Fork error\n");
//         exit(FORK_ERROR_EXIT);
// 	}
//     if (pid == 0) {
// 		close(fd[0]);
// 		close(1);
// 		dup(fd[1]);
// 		execlp("swipl","swipl","-s","differentiate.pl","-g",command,"-t","halt",(char *)NULL);	
// 	}
//     else {
// 		printf("Waiting\n");
// 		close(fd[1]);
// 		close(0);
// 		dup(fd[0]);
// 		wait(&status);
// 		read(fd[0], readbuffer, sizeof(readbuffer));
// 		return readbuffer;
// 	}
// }

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