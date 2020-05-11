// Test writing to the Plus/4 TED HSCAN_POS
#pragma target(plus4basic)

#include <plus4.h>

void main() {
    #ifdef __PLUS4__
    DEFAULT_SCREEN[0] = 'a';
    #else
    DEFAULT_SCREEN[0] = 'b';
    #endif
}
