// Tests printf function call rewriting
// USe parameter field syntax for a subset of fields

#include <printf.h>

void main() {
    printf("%d %1$d",1,1);
}

