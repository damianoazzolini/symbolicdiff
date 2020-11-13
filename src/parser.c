#include <argp.h>
#include "parser.h"

const char *argp_program_version = "symdiff 0.0.1";
const char *argp_program_bug_address = "<github_issue>";
const char doc[] = "SYMDIFF -- symbolic derivative and more\nexample: symdiff 3*x^2 -d x\nnexample: symdiff 3*x^2 + y -d [x,y]";
const char args_doc[] = "EQUATION";

error_t argp_err_exit_status = -1;

static struct argp_option options[] = {
	{"verbose",  	'v', 0,      	0,	"Produce verbose output", -1 },
	{"quiet",    	'q', 0,      	0,  "Don't produce any output", -1 },
	{"output",   	'o', "FILE", 	0,	"Output to FILE instead of standard output", -1 },
	{"derivate",	'd', "VARIABLE(s)",0,	"Compute derivative w.r.t. VARIABLE(s)", 0 },
	{"print-steps",	'p', 0, 		0,	"Print derivation steps", 1 },
	{"tex",			't', 0, 		0,	"Print latex output", 2 },
	{"evaluate",	'e', "POINT(s)",0,	"Evaluate the derivative", 1 },
	{"jacobian",	'j', 0, 		0,	"Compute Jacobian",2 },
	{"hessian",		'H', 0, 		0,	"Compute Hessian", 2 },
	{"interactive",	'i', 0, 		0,	"Interactive mode", 3 },
	{ 0 }
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
	case 'd':
		arguments->derivate = 1;
		arguments->variables = arg;
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
		arguments->evaluate_points = arg;
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
		if (state->arg_num > 1)
			/* Too many arguments-> */
			argp_usage(state);

		arguments->args[state->arg_num] = arg;

		break;

	case ARGP_KEY_END:
		if (state->arg_num != 1 && arguments->interactive == 0) {
			/* Not enough arguments-> */
			argp_usage(state);
        }
		if(state->arg_num == 1 && arguments->variables == NULL && (arguments->jacobian == 0 || arguments->hessian == 0)) {
            argp_usage(state);
        }
        // if(arguments->derivate == 1 && arguments->variables == NULL) {
        //     argp_usage(state);
        // }
		break;

	default:
		return ARGP_ERR_UNKNOWN;
	}
	return 0;
}

static struct argp argp = { options, parse_opt, args_doc, doc, NULL, NULL,NULL };

void init_argument(struct arguments *arguments) {
    arguments->quiet = 0;
	arguments->verbose = 0;
	arguments->derivate = 0;
	arguments->print_steps = 0;
	arguments->latex = 0;
	arguments->evaluate = 0;
	arguments->hessian = 0;
	arguments->jacobian = 0;
	arguments->interactive = 0;
	arguments->output_file = NULL;
	arguments->variables = NULL;
	arguments->evaluate_points = NULL;
}

void parse_arguments(int argc, char **argv, struct arguments *arguments) {
    init_argument(arguments);
    argp_parse(&argp, argc, argv, 0, 0, arguments);
}