#include "symdiff.h"
#include "errors.h"

#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include <SWI-Prolog.h>
#include <assert.h>

#define BUFLEN 1000

// this always returns a string, the result is parsed in
// the caller predicate (whether it needs a double or string)
char *exec_wrapper(void *command) { }

double exec_wrapper_(char *predicate, int arity, char *function, char *variables) {
    int ac = 0;
    char **av = (char **)malloc(sizeof(char *) * (20));
    char av0[10] = "./";
    char av1[10] = "-q";         // quiet
    char av2[15] = "--nosignals"; // signal handling
    av[ac++] = av0;
    av[ac++] = av1;
    av[ac++] = av2;

    if (!PL_is_initialised(NULL, NULL)) {
        if (!PL_initialise(ac, av)) {
            printf("error\n");
        }
    }

    predicate_t p_consult = PL_predicate("consult", 1, "database");
    term_t t = PL_new_term_ref();
    PL_put_string_chars(t, "/mnt/c/Users/damia/Desktop/Dottorato/TestVari/symbolicDiff/src/differentiate.pl");
    PL_call_predicate(NULL, 0, p_consult, t);
    predicate_t p_query = PL_predicate(predicate, arity, "database");
    term_t tq = PL_new_term_refs(3);

    assert(PL_put_string_chars(tq, function) && "PL_put_string_chars function failure");
    assert(PL_put_string_chars(tq + 1, variables) && "PL_put_string_chars variables failure");
    assert(PL_put_variable(tq+2) && "PL_put_variable failure");

    // PL_call_predicate(NULL,0,p_query,t);
    qid_t query = PL_open_query(NULL, PL_Q_NORMAL, p_query, tq);
    
    int result = PL_next_solution(query);
    // printf("query: %d result %d\n",query,result);
    double value_computed;
    if(result){
        PL_get_float(tq+2, &value_computed);
        // printf("Found solution %f.\n", value_computed);
    }
    else {
        return QUERY_FAILURE_EXIT;
    }
    PL_close_query(query);

    if (PL_is_initialised(NULL, NULL)) {
        PL_cleanup(1);
    }

    free(av);

    return value_computed;
}

char* symbolic_differentiate(char *function, char *variable) {
    char command[1000] = "differentiate(";

    snprintf(command,100,"differentiate(%s,%s).",function,variable);
    // strcat(command,function);
	// strcat(command,",");
	// strcat(command,variable);
	// strcat(command,").");
    return exec_wrapper(command); 
}

char* symbolic_differentiate_steps(char *function, char *variable) {
    char command[100] = "differentiate_steps(";

    strcat(command,function);
	strcat(command,",");
	strcat(command,variable);
	strcat(command,").");

    return exec_wrapper(command); 
}

char* evaluate(char *function, char *variable) {
    char command[100] = "evaluate(";

    strcat(command,function);
	strcat(command,",");
	strcat(command,variable);
	strcat(command,").");

    return exec_wrapper(command);
}

double evaluate_expr(char *function, char *variable) {
    return exec_wrapper_("evaluate_expr",3,function,variable);
}

char* jacobian(__attribute__ ((unused)) char *function) {
    return NULL;
}
char* jacobian_steps(__attribute__ ((unused)) char *function) {
    return NULL;
}

char* hessian(__attribute__ ((unused)) char *function) {
    return NULL;
}
char* hessian_steps(__attribute__ ((unused)) char *function) {
    return NULL;
}

char* gradient(char *function) {
    char command[100] = "gradient(";

    strcat(command,function);
	strcat(command,").");

    return exec_wrapper(command);
}

char* gradient_steps(char *function) {
    char command[100] = "gradient_steps(";

    strcat(command,function);
	strcat(command,").");

    return exec_wrapper(command);
}