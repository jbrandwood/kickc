// Test the xorshift pseudorandom number generator
// Source http://www.retroprogramming.com/2017/07/xorshift-pseudorandom-numbers-in-z80.html
// Information https://en.wikipedia.org/wiki/Xorshift

#include <stdio.h>
#include <c64.h>

void main() {
    clrscr();
    textcolor(WHITE);
    printf("generating unique randoms...");
    unsigned int first = _rand();
    unsigned long cnt = 0;
    textcolor(LIGHT_BLUE);
    char col = 3, row = 1;
    unsigned int rnd = first;
    do {
        cnt++;        
        if((char)cnt==0) {
            gotoxy(col,row);
            printf("%5u",rnd);
            if(++row==25) {
                row = 1;
                col+=6;
                if(col>40-5) 
                    col = 3;
            }
        }
        rnd = _rand();
    } while(rnd!=first);
    gotoxy(28,0);
    printf("found %lu",cnt);
}


// The maximal random value
#define RAND_MAX 65335

// The random state variable
unsigned int _rand_state = 1;

// Returns a pseudo-random number in the range of 0 to RAND_MAX (65535)
unsigned int _rand() {
    _rand_state ^= _rand_state << 7;
    _rand_state ^= _rand_state >> 9;
    _rand_state ^= _rand_state << 8;
    return _rand_state;
}

// Seeds the random number generator used by the function rand.
void _srand(unsigned int seed) {
    _rand_state = seed;
}