struct arguments {
	char *args[1];                /* EQUATION */
	int quiet, verbose, print_steps, latex, evaluate, hessian, jacobian, interactive, derivate;
	char *output_file, *variables;
};

void parse_arguments(int argc, char **argv, struct arguments *arguments);