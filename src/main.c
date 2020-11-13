#include <stdio.h>
// #include <SWI-Prolog.h>
// #include <argp.h>
#include "symdiff.h"
#include "parser.h"
#include "errors.h"
#include <string.h>
#include <stdlib.h>

#define DEFAULT_LEN 500

int dispatcher(struct arguments arguments);
void interactive_loop();
void to_latex(char *res);

void to_latex(char *res) {
}

void interactive_loop() {
	char line[DEFAULT_LEN] = "";
	printf("SYMDIFF INTERACTIVE MODE\n");
	printf("Exit with exit()\n");
	printf("> ");
	scanf("%s",line);

	while(strcmp(line,"exit()") != 0) {
		// TODO
	}
}

int dispatcher(struct arguments arguments) {
	char *result;
	FILE *fp;

	if(arguments.output_file != NULL) {
		fp = fopen(arguments.output_file,"w");
		if(fp == NULL) {
			exit(FOPEN_ERROR_EXIT);
		}
	}
	else {
		fp = stdout;
	}

	
	if(arguments.quiet == 1) {

	}
	else if(arguments.verbose == 1) {

	}


	if(arguments.derivate == 1) {
		if(arguments.print_steps == 1) {
			result = symbolic_differentiate_steps(arguments.args[0],arguments.variables);
		}
		else {
			result = symbolic_differentiate(arguments.args[0],arguments.variables);
		}
	} 
	else if(arguments.evaluate == 1) {
		if(arguments.print_steps == 1) {
			result = evaluate_steps(arguments.args[0],arguments.variables);
		}
		else {
			result = evaluate(arguments.args[0],arguments.variables);
		}
	}
	else if(arguments.hessian == 1) {
		if(arguments.print_steps == 1) {
			result = hessian_steps(arguments.args[0]);
		}
		else {
			result = hessian(arguments.args[0]);
		}
	}
	else if(arguments.jacobian == 1) {
		if(arguments.print_steps == 1) {
			result = jacobian_steps(arguments.args[0]);
		}
		else {
			result = jacobian(arguments.args[0]);
		}
	}
	else if(arguments.interactive) {
		interactive_loop();
	}
	
	if(arguments.latex == 1) {
		to_latex(result);
	}

	fprintf(fp,"%s",result);
	free(result);

	return 0;
}

int main(int argc, char **argv) { 
	struct arguments arguments;

	parse_arguments(argc,argv,&arguments);
	dispatcher(arguments);

	return 0; 	
}