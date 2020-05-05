// Test the pseudorandom number generator in stdlib.h
// Source http://www.retroprogramming.com/2017/07/xorshift-pseudorandom-numbers-in-z80.html
// Information https://en.wikipedia.org/wiki/Xorshift

#include <stdlib.h>
#include <stdio.h>
#include <c64.h>

void main() {
    clrscr();
    textcolor(WHITE);
    printf("generating unique randoms...");
    unsigned int first = rand();
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
        rnd = rand();
    } while(rnd!=first);
    gotoxy(28,0);
    textcolor(WHITE);
    printf("found %lu",cnt);
}
