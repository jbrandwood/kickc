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
    for(signed char y=0;y<25;y++) {
        for(signed char x=0;x<40;x++) {
            // xd = x-19.5 
            // Multiply everything by 2 to allow integer math to calculate with .5 precision
            signed char xd = x*2-39; 
            // yd = y-12 
            signed char yd = y*2-24;
            // dist_sq = xd*xd + yd*yd
            signed int dist_sq = mul8s(xd,xd) + mul8s(yd,yd); 
            // is dist_sq < 9*9 (distance to center is less than 9)
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