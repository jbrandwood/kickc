// C standard library time.h
//  Functions to get and manipulate date and time information.
#include <time.h>
#include <c64.h>


// Returns the processor clock time used since the beginning of an implementation defined era (normally the beginning of the program).
// This uses CIA #2 Timer A+B on the C64, and must be initialized using clock_start()
clock_t clock(void) {
    return 0xffffffff - *CIA2_TIMER_AB;
}

// Reset & start the processor clock time. The value can be read using clock().
// This uses CIA #2 Timer A+B on the C64
void clock_start(void) {
    // Setup CIA#2 timer A to count (down) CPU cycles
    CIA2->TIMER_A_CONTROL = CIA_TIMER_CONTROL_STOP | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_A_COUNT_CYCLES;
    CIA2->TIMER_B_CONTROL = CIA_TIMER_CONTROL_STOP | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A;
    *CIA2_TIMER_AB = 0xffffffff;
    CIA2->TIMER_B_CONTROL = CIA_TIMER_CONTROL_START | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A;
    CIA2->TIMER_A_CONTROL = CIA_TIMER_CONTROL_START | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_A_COUNT_CYCLES;
}
