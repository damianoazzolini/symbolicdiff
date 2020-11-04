#include <stdio.h>
#include "../src/symdiff.h"

// gcc test_c_api.c -L../src/ -lsymdiff
// gcc test_c_api.c -L../src/ -lsymdiff -Wl,-rpath,../src/

int main() {
    printf("%lf\n",evaluate(NULL,'0'));
}