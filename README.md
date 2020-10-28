# SYMBOLICDIFF
A Prolog - C project to implement symbolic differentiation.
The front end is built in C (command line interpretation, read function from file ecc), while the actual derivation is performed in Prolog.
The idea is to call this from the command line.
Maybe also develop an interface to plot the function?

## Requirements
SWI-Prolog

## Repository Structure

## Usage
Read from the command line the function in the following form:
differentiate(function,variable)
If variable is a list of variables, then the result will be a list of derivatives
differentiate(x*y*z,x,y) -> y*z, x*z
gradient(x*y*z) -> y*z, x*z, x*y
jacobian(x*y*z) -> prints the jacobian matrix
hessian(x*y*z) -> prints the hessian matrix

Also evaluate derivatives?
Print steps? This is interesting
C api?

## Command Line Options
--evaluate
--print-steps

others