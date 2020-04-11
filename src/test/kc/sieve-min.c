#include <string.c>
#include <time.c>
#include <stdint.c>
#include <division.c>
#include <c64.c>
#include <print.c>


char* const SCREEN = 0x0400;
const uint16_t COUNT = 16384;           /* Up to what number? */
const uint8_t SQRT_COUNT = 128;         /* Sqrt of COUNT */
uint8_t* sieve = 0x1000;

void main (void) {
    // Fill sieve with zeros
    memset(sieve, 0, COUNT);
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
    for (i = 2; i < 0x04c7; ++i)
        if (!sieve[i]) {
            print_word(i);
            print_char(' ');
        }
    while(true) { (*(SCREEN+999))++; }
}
