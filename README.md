# SYMBOLICDIFF
A Prolog - C project to implement symbolic differentiation.
The front end is built in C while the actual derivation is performed in Prolog.

## Requirements
SWI-Prolog is needed. Installation manual: https://www.swi-prolog.org/build/unix.html
Currently, SWI prolog is called through a system call (execlp). In the future, it would be nice to use its C API.
    
## Function/predicates available
Without steps:
- `differentiate(Formula,Variable(s))`
- `gradient(Formula)`
- `jacobian(Formula)`
- `hessian(Formula)`

With steps:
- `differentiate_steps(Formula,Variable(s))`
- `gradient_steps(Formula)`
- `jacobian_steps(Formula)`
- `hessian_steps(Formula)`

## Command Line Options
```
Usage: symdiff [OPTION...] EQUATION
SYMDIFF -- symbolic derivative and more
example: symdiff 3*x^2 -d x
nexample: symdiff 3*x^2 + y -d [x,y]

  -e, --evaluate             Evaluate the derivative
  -p, --print-steps          Print derivation steps
  -g, --gradient             Compute the gradient 
  -H, --hessian              Compute Hessian matrix
  -j, --jacobian             Compute Jacobian matrix
  -t, --tex                  Print latex output
  -i, --interactive          Interactive mode
  -?, --help                 Give this help list
  -d, --derivate=VARIABLE(s) Compute derivative w.r.t. VARIABLE(s)
  -o, --output=FILE          Output to FILE instead of standard output
  -q, --quiet                Don't produce any output
      --usage                Give a short usage message
  -v, --verbose              Produce verbose output
  -V, --version              Print program version

Report bugs to <github_issue>.
```
## Examples
- Symbolic differentiate: 
```
./symdiff 3*x+4*y+5*z -d x
x: 3*1+4*0+5*0
```

```
./symdiff 3*x+4*y+5*z -d [x,y,z]
dx: 3*1+4*0+5*0
dy: 3*0+4*1+5*0
dz: 3*0+4*0+5*1
```

- Gradient:
```
./symdiff 3*x+4*y+5*z -g
dx: 3*1+4*0+5*0
dy: 3*0+4*1+5*0
dz: 3*0+4*0+5*1
```

- Evaluate the function:
```
./symdiff 3*x+4*y+5*z -e [[x,1],[y,2],[z,3]]
26
```

- Evaluate the derivative(s):
```
./symdiff 3*x+4*y+5*z -d [x,y,z] -e [[x,1],[y,2],[z,3]]
[3,4,5]
```

- Print steps:
```
./symdiff 3*x+4*y+5*z -d x -p
dx: 3*1+4*0+5*0
[sum_rule,sum_rule,constant*function,one_variable,constant*function,one_variable,constant*function,one_variable]
[(d/d(x:3*x+4*y+5*z)->3*1+4*0+5*0),(d/d(x:3*x+4*y)->3*1+4*0),(d/d(x:3*x)->3*1),(d/d(x:x)->1),(d/d(x:4*y)->4*0),(d/d(x:y)->0),(d/d(x:5*z)->5*0),(d/d(x:z)->0)]
```
```
./symdiff 3*x+4*y+5*z -d [x,y] -p
dx: 3*1+4*0+5*0
[sum_rule,sum_rule,constant*function,one_variable,constant*function,one_variable,constant*function,one_variable]
[(d/d(x:3*x+4*y+5*z)->3*1+4*0+5*0),(d/d(x:3*x+4*y)->3*1+4*0),(d/d(x:3*x)->3*1),(d/d(x:x)->1),(d/d(x:4*y)->4*0),(d/d(x:y)->0),(d/d(x:5*z)->5*0),(d/d(x:z)->0)]
dy: 3*0+4*1+5*0
[sum_rule,sum_rule,constant*function,one_variable,constant*function,one_variable,constant*function,one_variable]
[(d/d(y:3*x+4*y+5*z)->3*0+4*1+5*0),(d/d(y:3*x+4*y)->3*0+4*1),(d/d(y:3*x)->3*0),(d/d(y:x)->0),(d/d(y:4*y)->4*1),(d/d(y:y)->1),(d/d(y:5*z)->5*0),(d/d(y:z)->0)]
```

## Return Values
See `src/errors.h`:
- `FORK_ERROR_EXIT -2`
- `PIPE_ERROR_EXIT -3`
- `EXECLP_ERROR_EXIT -4`
- `FOPEN_ERROR_EXIT -5`
- `EXEC_NULL_ERROR_EXIT -6`

## C API Example
You can find the following example in the folder test
```
#include <stdio.h>
#include "../src/symdiff.h"

int main() {
    printf("%s\n",evaluate_expr("3*x+4*y+5*z","[[x,1],[y,2],[z,3]]"));
    return 0;
}
```
Compile it with `gcc test_c_api.c -L../src/ -lsymdiff -Wl,-rpath,../src/`
Then run it with `./a.out`.

## Repository Structure
```
.
├── include
│   └── symdiff.h -> symdiff.h
├── README.md
├── src
│   ├── compile.sh
│   ├── differentiate.pl
│   ├── errors.h
│   ├── main.c
│   ├── Makefile
│   ├── parser.c
│   ├── parser.h
│   ├── symdiff
│   ├── symdiff.c
│   ├── symdiff.h
└── test
    ├── test_c_api.c
    └── test.pl
```

## Future Steps
- Dynamic memory allocation, especially in writing from pipe
- Read functions from file
- Interface (GUI)
- Print latex format
- Plot the functions