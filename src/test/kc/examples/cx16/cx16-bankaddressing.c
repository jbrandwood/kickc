// Example program for the Commander X16
// Demonstrates some bank addressing calculations

#pragma target(cx16)

#include <cx16.h>
#include <6502.h>
#include <cx16-veralib.h>
#include <conio.h>
#include <printf.h>
#include <stdio.h>

void main() {

    dword src = (dword)0x02000;
    dword num = 64*64*2;

    word inc = 0x0123;

    for(dword src=0x0000;src<0x3F000;src+=num) {

        dword calcbeg = src;
        dword calcend = src+num+(-1);
        byte bankbeg = BYTE2(calcbeg)<<3 | BYTE1(calcbeg)>>5 ; //(byte)(((((word)<(>calcbeg)<<8)|>(<calcbeg))>>5)+((word)<(>calcbeg)<<3));
        byte bankend = BYTE2(calcend)<<3 | BYTE1(calcend)>>5 ; //(byte)(((((word)<(>calcend)<<8)|>(<calcend))>>5)+((word)<(>calcend)<<3));
        const word borderbeg = 0xA000;
        const word borderend = 0xA000+0x1FFF;
        word beg = (WORD0(calcbeg)&0x1FFF); // stip off the top 3 bits, which are representing the bank of the word!
        word end = (WORD0(calcend)&0x1FFF); // same for the end;
        beg += borderbeg;
        end += borderbeg;

        printf("cbeg=%x, add=%x, cend=%x, bbeg=%x, bend=%x, beg=%x, end=%x\n", calcbeg, num, calcend, bankbeg, bankend, beg, end );
        num+=inc;
    }
}