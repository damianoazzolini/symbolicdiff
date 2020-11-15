#include <stdio.h>
#include "../src/symdiff.h"

// gcc test_c_api.c -L../src/ -lsymdiff
// gcc test_c_api.c -L../src/ -lsymdiff -Wl,-rpath,../src/

int main() {
    printf("%s\n",evaluate_expr("3*x+4*y+5*z","[[x,1],[y,2],[z,3]]"));
}