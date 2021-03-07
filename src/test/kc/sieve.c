#include <string.h>
#include <c64-time.h>
#include <stdint.h>
#include <division.h>
#include <c64.h>
#include <c64-print.h>


char* const SCREEN = 0x0400;

const uint16_t COUNT = 16384;           /* Up to what number? */
const uint8_t SQRT_COUNT = 128;         /* Sqrt of COUNT */
uint8_t* sieve = 0x1000;

void main (void) {
    //Show lower case font
    *D018 = toD018(SCREEN, 0x1800);
    print_cls();
    print_str("Sieve benchmark - calculating primes");
    print_ln();
    print_str("between 2 and ");
    print_uint_decimal(COUNT);
    print_ln();

    // Fill sieve with zeros
    memset(sieve, 0, COUNT);

    clock_start();

    unsigned int i = 2;
    char* sieve_i = &sieve[i];
    while (i < SQRT_COUNT) {
        if (!*sieve_i) {
            /* Prime number - mark all multiples */
            unsigned int j = i*2;
            unsigned char* s = &sieve[j];
            while (j < COUNT) {
                *s = 1;
                s += i;
                j += i;
            }
        }
        i++;
        sieve_i++;
    }

    clock_t cyclecount = clock()-CLOCKS_PER_INIT;
    unsigned int sec100s = (unsigned int)div32u16u(cyclecount, (unsigned int)(CLOCKS_PER_SEC/100));

    print_str("100ths seconds used: ");
    print_uint_decimal(sec100s);
    print_str(" cycles: ");
    print_ulong_decimal(cyclecount);
    print_ln();
    for (i = 2; i < 1300; ++i)
        if (!sieve[i]) {
            print_uint_decimal(i);
            print_char(' ');
        }
    print_str("...");
    while(true) { (*(SCREEN+999))++; }
}
