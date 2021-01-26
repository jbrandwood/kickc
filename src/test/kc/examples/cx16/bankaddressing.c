// Example program for the Commander X16


#include <cx16.h>
#include <6502.h>
#include <veralib.h>
#include <conio.h>
#include <printf.h>
#include <stdio.h>

void main() {

    dword src = (dword)0x02000;
    dword num = 64*64*2;

    word inc = 0x0123;

    for(dword src=0x0000;src<0x3F000;src+=num) {

        dword calcbeg = src;
        dword calcend = src+num+(-1); // TODO code fragment needed.
        byte bankbeg = (byte)(((((word)<(>calcbeg)<<8)|>(<calcbeg))>>5)+((word)<(>calcbeg)<<3));
        byte bankend = (byte)(((((word)<(>calcend)<<8)|>(<calcend))>>5)+((word)<(>calcend)<<3));
        const word borderbeg = 0xA000;
        const word borderend = 0xA000+0x1FFF;
        word beg = ((<calcbeg)&0x1FFF); // stip off the top 3 bits, which are representing the bank of the word!
        word end = ((<calcend)&0x1FFF); // same for the end;
        beg += borderbeg;
        end += borderbeg;

        printf("cbeg=%x, add=%x, cend=%x, bbeg=%x, bend=%x, beg=%x, end=%x\n", calcbeg, num, calcend, bankbeg, bankend, beg, end );
        num+=inc;
    }
}