// Setup and run a simple CIA-timer

#include <c64.h>
#include <time.h>
#include <print.h>

byte* const SCREEN = 0x0400;

void main() {

    // Reset & start the CIA#2 timer A+B
    clock_start();
    // Continously print cycle count since timer start
    while(true) {
        print_ulong_at(clock(), SCREEN);
    }
}
