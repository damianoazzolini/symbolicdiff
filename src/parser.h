struct arguments {
	char *args[1];                /* EQUATION */
	int quiet, verbose, print_steps, latex, evaluate, hessian, jacobian, interactive, derivate, gradient;
	char *output_file, *variables, *evaluate_points;
};

void parse_arguments(int argc, char **argv, struct arguments *arguments);