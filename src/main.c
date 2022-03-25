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

void to_latex(__attribute__ ((unused)) char *res) {
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
	double res;
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

	// FIX ALL THE RETURN VALUES
	// if evaluate == 1 && derivate == 0 -> evaluate the current formula (evaluate_expr)
	// if evaluate == 1 && derivate == 1 -> evaluate the derivative
	if(arguments.evaluate == 1 && arguments.derivate == 1) {
		result = evaluate(arguments.args[0],arguments.evaluate_points);	
	}
	else if(arguments.evaluate == 1 && arguments.derivate == 0) {
		res = evaluate_expr(arguments.args[0],arguments.evaluate_points);
	}
	else if(arguments.derivate == 1) {
		if(arguments.print_steps == 1) {
			result = symbolic_differentiate_steps(arguments.args[0],arguments.variables);
		}
		else {
			result = symbolic_differentiate(arguments.args[0],arguments.variables);
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
	else if(arguments.gradient == 1) {
		if(arguments.print_steps == 1) {
			result = gradient_steps(arguments.args[0]);
		}
		else {
			result = gradient(arguments.args[0]);
		}
	}
	else if(arguments.interactive) {
		interactive_loop();
	}

	if(result == NULL) {
		exit(EXEC_NULL_ERROR_EXIT);
	}
	
	if(arguments.latex == 1) {
		to_latex(result);
	}

	fprintf(fp,"%s",result);
	free(result);

	return 0;
}

int check_consistency(struct arguments *args) {
	int i,j,pars = 0, error = 0;
	char c,c1;
	// char choice[5];
	// check equation
	for(i = 0; i < (int)strlen(args->args[0]) - 1; i++) {
		c = args->args[0][i];
		c1 = args->args[0][i+1];
		if(c >= '0' && c <= '9') {
			if(c1 != '*' && c1 != '+' && c1 != '-' && c1 != '\\' && !(c1 >= '0' && c1 <= '9')) {
				printf("Error in function\n");
				printf("%s\n",args->args[0]);
				for(j = 0; j < i+1; j++) {
					printf("-");
				}
				printf("^\n");
				printf("Maybe missing *?\n");
				error++;
				// printf("Insert *? [y,n]: ");
				// scanf("%s",choice);
				// if(strcmp(choice,"y") == 0) {
				// }
			}
		}
	}
	// check variables x or [x] or [x,y]
	if(args->variables != NULL) {
		if(strlen(args->variables) != 1) {
			for(i = 0; i < (int)strlen(args->variables); i++) {
				if(args->variables[i] == '[') {
					pars++;
				}
				else if(args->variables[i] == ']') {
					pars--;
				}
			}
			if(pars > 0) {
				printf("Unbalanced paratheses: %s\n",args->variables);
				error++;
			}
			// TODO check list
		}
	}

	// check evaluate points
	if(args->evaluate_points != NULL) {
		for(i = 0; i < (int)strlen(args->evaluate_points); i++) {
			if(args->evaluate_points[i] == '[') {
				pars++;
			}
			else if(args->evaluate_points[i] == ']') {
				pars--;
			}
		}
		if(pars > 0) {
			printf("Unbalanced parentheses: %s\n",args->evaluate_points);
			error++;
		}
		// TODO check list
	}

	return error;
}

int main(int argc, char **argv) { 
	struct arguments arguments;

	parse_arguments(argc,argv,&arguments);
	if(check_consistency(&arguments) == 0) {
		dispatcher(arguments);
	}
	else {
		exit(INCONSISTENCY_ERROR_EXIT);
	}

	return 0;
}