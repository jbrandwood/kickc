#include "benchcommon.c"
#include <c64-print.h>

byte* const rom = (byte*)0xe000;

unsigned int sum(void) {
    unsigned int s;
    byte* p;
    byte page;
    byte i;
    byte tmp;
    p = rom;
    s = 0;
    /* doing it page-by-page is faster than doing just one huge loop */
    for (page = 0; page < 0x20; page++) {
        i = 0;
        do {
            tmp = p[i];
            s += tmp;
            i++;
        } while (i);
        p += 0x100;
    }
    return s;
}




int main (void)
{
    unsigned int i;
    start();
    for(i=0;i<6;i++) {
        print_uint_decimal(sum());
        print_ln();
    }
    end();    
    return 0;
}
