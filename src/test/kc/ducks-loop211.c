#include <peekpoke.h>
#include <6502.h>

const unsigned byte brick=230;

void chrout(volatile char petscii)
{
    asm {
        lda petscii
        jsr $ffd2
    }
}

void main()
{
    char k=1;
    do {
        POKE(211,k*4);
        chrout(brick);
        ++k;
    } while (k<5);
}