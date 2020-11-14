# SYMBOLICDIFF
A Prolog - C project to implement symbolic differentiation.
The front end is built in C (command line interpretation, read function from file ecc), while the actual derivation is performed in Prolog.
The idea is to call this from the command line.
Maybe also develop an interface to plot the function?

## Requirements
SWI-Prolog
    
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
  -H, --hessian              Compute Hessian
  -j, --jacobian             Compute Jacobian
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
Symbolic differentiate: 
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

Gradient:
```
./symdiff 3*x+4*y+5*z -g
dx: 3*1+4*0+5*0
dy: 3*0+4*1+5*0
dz: 3*0+4*0+5*1
```

Evaluate the function:
```
./symdiff 3*x+4*y+5*z -e [[x,1],[y,2],[z,3]]
26
```

Evaluate the derivative(s):
```
./symdiff 3*x+4*y+5*z -d [x,y,z] -e [[x,1],[y,2],[z,3]]
[3,4,5]
```

## Return values
See `src/errors.h`:
- `FORK_ERROR_EXIT -2`
- `PIPE_ERROR_EXIT -3`
- `EXECLP_ERROR_EXIT -4`
- `FOPEN_ERROR_EXIT -5`

## Repository Structure
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
