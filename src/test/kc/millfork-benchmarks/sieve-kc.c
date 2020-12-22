#include <print.h>
#include "benchcommon.c"

const unsigned int COUNT = 16384;
const char SQRT_COUNT = 128;

__align(0x0100) char Sieve[COUNT];

void round(void) {
    register char* S;
    register char  I;
    for(char* p=Sieve;p<Sieve+COUNT;++p)
        *p = 0;
    I = 2;
    while (I < SQRT_COUNT) {
        if (Sieve[I] == 0) {
            /* Prime number - mark multiples */
            S = Sieve + I<<1;
            while (S < Sieve + COUNT) {
                *S = 1;
                S += I;
            }
        }
        ++I;
    }
}

int main (void)
{
    start();
    
    round();
    round();
    round();
    round();
    round();
    
    round();
    round();
    round();
    round();
    round();
    
    end();
    return 0;
}


