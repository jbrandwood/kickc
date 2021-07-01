// Linear table generator
// Work in progress towards a sine generator
#include <division.h>
#include <c64-print.h>

void main() {
    word lintab1[20];
    lin16u_gen(557, 29793, lintab1, 20);
    word lintab2[20];
    lin16u_gen(31179, 63361, lintab2, 20);
    word lintab3[20];
    lin16u_gen(0, $6488, lintab3, 20);
    print_cls();
    print_str("   ");
    print_uint(557);
    print_str(" ");
    print_uint(31179);
    print_str(" ");
    print_uint(0);
    print_ln();
    for(byte i=0; i<20; i++) {
        print_uchar(i);
        print_str(" ");
        print_uint(lintab1[i]);
        print_str(" ");
        print_uint(lintab2[i]);
        print_str(" ");
        print_uint(lintab3[i]);
        print_ln();
    }
    print_str("   ");
    print_uint(29793);
    print_str(" ");
    print_uint(63361);
    print_str(" ");
    print_uint($6488);
    print_ln();
}

// Generate word linear table
// lintab - the table to generate into
// length - the number of points in a total sine wavelength (the size of the table)
void lin16u_gen(word min, word max, word* lintab, word length) {
    word ampl = max-min;
    word stepi = divr16u(ampl, length-1, 0);
    word stepf = divr16u(0, length-1, rem16u);
    dword step = MAKELONG( stepi, stepf );
    dword val = MAKELONG( min, 0 );
    for(word i=0; i<length; i++) {
        *lintab = WORD1(val);
        val = val + step;
        lintab++;
    }
}
