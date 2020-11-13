#include "symdiff.h"
#include "errors.h"

#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>

#define BUFLEN 500

char *exec_wrapper(char *command) {
    char *readbuffer;
    int pid;
    int status, nbytes;
    int fd[2];

    if(pipe(fd) < 0) {
        exit(PIPE_ERROR_EXIT);
    }

    pid = fork();
    if (pid < 0) {
        exit(FORK_ERROR_EXIT);
	}
    if (pid == 0) {
		close(fd[0]);
		close(STDOUT_FILENO);
		close(STDERR_FILENO);
		dup(fd[1]);
		close(fd[1]);
		execlp("swipl","swipl","-s","differentiate.pl","-g",command,"-t","halt",(char *)NULL);
        exit(EXECLP_ERROR_EXIT);
    }
    else {
		close(fd[1]);
        close(STDIN_FILENO);
        dup(fd[0]);
		// dup2(fd[0],0);
		// close(0);
		while(wait(&status) > 0);
        readbuffer = malloc(BUFLEN);
		nbytes = read(fd[0], readbuffer, BUFLEN - 1);
        printf("hhee, %d, %s\n",nbytes,readbuffer);
        if(nbytes > 0) {
            return readbuffer;
        }
		else {
            return NULL;
        }
	}

    return NULL; 
}

char* symbolic_differentiate(char *function, char *variable) {
    char command[100] = "differentiate(";

    strcat(command,function);
	strcat(command,",");
	strcat(command,variable);
	strcat(command,").");

    return exec_wrapper(command); 
}

char* symbolic_differentiate_steps(char *function, char *variable) {
    return NULL;
}

char* evaluate(char *function, char *variable) {
    return NULL;
}
char* evaluate_steps(char *function, char *variable) {
    return NULL;
}


char* jacobian(char *function) {
    return '_';
}
char* jacobian_steps(char *function) {
    return '_';
}


char* hessian(char *function) {
    return '_';
}
char* hessian_steps(char *function) {
    return '_';
}