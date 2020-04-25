// Tests printf function call rewriting
// Test parameter field syntax %2$d

#include <printf.h>

void main() {
    printf_cls();
    printf("%%d %%d:     %d %d\n",1, 2);
    printf("%%1$d %%2$d: %1$d %2$d\n",1, 2);
    printf("%%1$d %%1$d: %1$d %1$d\n",1, 2);
    printf("%%2$d %%2$d: %2$d %2$d\n",1, 2);
    printf("%%2$d %%1$d: %2$d %1$d\n",1, 2);
}

