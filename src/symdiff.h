char* evaluate(char *function, char *variable);
char* symbolic_differentiate(char *function, char *variable);
char* jacobian(char *function);
char* hessian(char *function);
char* gradient(char *function);
double evaluate_expr(char *function, char *variable);

char* evaluate_steps(char *function, char *variable);
char* symbolic_differentiate_steps(char *function, char *variable);
char* jacobian_steps(char *function);
char* hessian_steps(char *function);
char* gradient_steps(char *function);