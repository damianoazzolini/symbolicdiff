#include <stdio.h>
// #include <SWI-Prolog.h>
#include <argp.h>
#include "symdiff.h"
#include <stdlib.h>
#include <sys/types.h> 
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>

#define SYMDIFF_VERSION 0.1
#define FORK_ERROR_EXIT -2

error_t argp_err_exit_status = -1;

const char *argp_program_version = "symdiff 0.0.1";
const char *argp_program_bug_address = "<github_issue>";
const char doc[] = "SYMDIFF -- symbolic derivative and more\nexample: symdiff 3*x^2 -d x\nnexample: symdiff 3*x^2 + y -d [x,y]";

const char args_doc[] = "EQUATION VARIABLE(s)";
static struct argp_option options[] = {
	{"verbose",  	'v', 0,      	0,	"Produce verbose output", -1 },
	{"quiet",    	'q', 0,      	0,  "Don't produce any output", -1 },
	{"output",   	'o', "FILE", 	0,	"Output to FILE instead of standard output", -1 },
	// {"derivate",	'd', "VARIABLE(s)",0,	"Compute derivative w.r.t. VARIABLE(s)", 0 },
	{"print-steps",	'p', 0, 		0,	"Print derivation steps", 1 },
	{"tex",			't', 0, 		0,	"Print latex output", 2 },
	{"evaluate",	'e', 0, 		0,	"Evaluate the derivative", 1 },
	{"jacobian",	'j', 0, 		0,	"Compute Jacobian",2 },
	{"hessian",		'H', 0, 		0,	"Compute Hessian", 2 },
	{"interactive",	'i', 0, 		0,	"Interactive mode", 3 },
	{ 0 }
};

struct arguments {
	char *args[2];                /* EQUATION & VARIABLE(s) */
	int quiet, verbose, print_steps, latex, evaluate, hessian, jacobian, interactive;
	char *output_file;
};

error_t parse_opt(int key, char *arg, struct argp_state *state) {
	struct arguments *arguments = state->input;

	switch (key) {
	case 'q':
		if(arguments->verbose == 0)
			arguments->quiet = 1;
		break;
	case 'v':
		if(arguments->quiet == 0)
			arguments->verbose = 1;
		break;
	case 'o':
		arguments->output_file = arg;
		break;
	case 'p':
		arguments->print_steps = 1;
		break;
	case 't':
		arguments->latex = 1;
		break;
	case 'e':
		arguments->evaluate = 1;
		break;
	case 'j':
		arguments->jacobian = 1;
		break;
	case 'H':
		arguments->hessian = 1;
		break;
	case 'i':
		arguments->interactive = 1;
		break;
		
	case ARGP_KEY_ARG:
		if (state->arg_num > 2)
			/* Too many arguments. */
			argp_usage(state);

		arguments->args[state->arg_num] = arg;

		break;

	case ARGP_KEY_END:
		if (state->arg_num != 2)
			/* Not enough arguments. */
			argp_usage(state);
			// exit(MANUAL_EXIT);
		break;

	default:
		return ARGP_ERR_UNKNOWN;
	}
	return 0;
}

static struct argp argp = { options, parse_opt, args_doc, doc, NULL, NULL,NULL };

int main(int argc, char **argv) { 
	int pid;
	int status, nbytes;
	int fd[2];
	char command[100] = "evaluate(";
	char readbuffer[100];
	struct arguments arguments;

	/* Default values. */
	arguments.quiet = 0;
	arguments.verbose = 0;
	arguments.print_steps = 0;
	arguments.latex = 0;
	arguments.evaluate = 0;
	arguments.hessian = 0;
	arguments.jacobian = 0;
	arguments.interactive = 0;
	arguments.output_file = "-";

	argp_parse(&argp, argc, argv, 0, 0, &arguments);

	printf("args[0], args[1]: %s, %s\n",arguments.args[0],arguments.args[1]);

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