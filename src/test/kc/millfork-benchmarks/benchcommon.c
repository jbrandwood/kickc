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
    rand_seed = 6474;
    
}
void end(void) {
    Ticks = last_time;
    start();
    last_time -= Ticks;
    Ticks = last_time;
    print_uint(Ticks);
    print_ln();
}

unsigned int rand_seed;

char rand() {
    unsigned int* const RAND_SEED = &rand_seed;
    asm{
        ldx #8
        lda RAND_SEED+0
    __rand_loop:
        asl
        rol RAND_SEED+1
        bcc __no_eor
        eor #$2D
    __no_eor:
        dex
        bne __rand_loop
        sta RAND_SEED+0
    }
    return (char)rand_seed;
}