// Setup and run a simple CIA-timer

#include <c64.h>
#include <c64-time.h>
#include <c64-print.h>

byte* const SCREEN = (char*)0x0400;

void main() {

    // Reset & start the CIA#2 timer A+B
    clock_start();
    // Continously print cycle count since timer start
    while(true) {
        print_ulong_at(clock(), SCREEN);
    }
}
