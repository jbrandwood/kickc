// Plot a r=9 circle on the screen using chars - count how many chars are used
#include <string.h>
#include <multiply.h>
#include <conio.h>
#include <stdio.h>

char* const SCREEN = 0x0400;


void main() {
    memset(SCREEN, ' ', 1000);
    unsigned int count = 0;
    char* sc = SCREEN;
    for(char y=0;y<25;y++) {
        for(char x=0;x<40;x++) {
            signed char xd = (signed char)x*2-39; 
            signed char yd = (signed char)y*2-24;
            signed int dist_sq = mul8s(xd,xd) + mul8s(yd,yd); 
            if(dist_sq<2*9*2*9) {
                *sc = '*';
                count++;
            }
            sc++;
        }
    }
    gotoxy(0,0);
    printf("%u chars",count);
}