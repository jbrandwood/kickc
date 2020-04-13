// Counting cycles using a CIA timer

#include <c64.h>
#include <time.h>
#include <print.h>

byte* const SCREEN = 0x0400;

void main() {

    while(true) {
        // Reset & start the CIA#2 timer A+B
        clock_start();
        asm { nop }
        // Calculate the cycle count - 0x12 is the base usage of start/read
        dword cyclecount = clock()-CLOCKS_PER_INIT;
        // Print cycle count
        print_ulong_at(cyclecount, SCREEN);
    }
}
