#include <print.h>
#include <time.h>


unsigned int last_time;
unsigned int Ticks;

void start(void) {
    unsigned int* const LAST_TIME = &last_time;
    asm {
        jsr $FFDE
        sta LAST_TIME
        stx LAST_TIME + 1
    }

}
void end(void) {
    Ticks = last_time;
    start();
    last_time -= Ticks;
    Ticks = last_time;
    print_uint(Ticks);
    print_ln();
}