// Tests different rotate left commands
#include <stdio.h>
#include <conio.h>

void main() {
    unsigned long vals[] = { 0xdeadbeef, 0xfacefeed };
    char i=0;
    while(1) {
        clrscr();
        rol_fixed(vals[i]);
        while(!kbhit()) ;
        clrscr();
        ror_fixed(vals[i]);
        while(!kbhit()) ;
        clrscr();
        rol_var(vals[i]);
        while(!kbhit()) ;
        clrscr();
        ror_var(vals[i]);
        while(!kbhit()) ;
        i = (i+1)&1;
    }

}

void rol_fixed(unsigned long val) {
    printf("rol fixed\n");
    printf("%2d: %08lx\n", 0, val<<0);
    printf("%2d: %08lx\n", 1, val<<1);
    printf("%2d: %08lx\n", 2, val<<2);
    printf("%2d: %08lx\n", 3, val<<3);
    printf("%2d: %08lx\n", 4, val<<4);
    printf("%2d: %08lx\n", 5, val<<5);
    printf("%2d: %08lx\n", 6, val<<6);
    printf("%2d: %08lx\n", 7, val<<7);
    printf("%2d: %08lx\n", 8, val<<8);
    printf("%2d: %08lx\n", 9, val<<9);
    printf("%2d: %08lx\n", 12, val<<12);
    printf("%2d: %08lx\n", 15, val<<15);
    printf("%2d: %08lx\n", 16, val<<16);
    printf("%2d: %08lx\n", 17, val<<17);
    printf("%2d: %08lx\n", 20, val<<20);
    printf("%2d: %08lx\n", 23, val<<23);
    printf("%2d: %08lx\n", 24, val<<24);
    printf("%2d: %08lx\n", 25, val<<25);
    printf("%2d: %08lx\n", 28, val<<28);
    printf("%2d: %08lx\n", 31, val<<31);
    printf("%2d: %08lx\n", 32, val<<32);
}

void ror_fixed(unsigned long val) {
    printf("ror fixed\n");
    printf("%2d: %08lx\n", 0, val>>0);
    printf("%2d: %08lx\n", 1, val>>1);
    printf("%2d: %08lx\n", 2, val>>2);
    printf("%2d: %08lx\n", 3, val>>3);
    printf("%2d: %08lx\n", 4, val>>4);
    printf("%2d: %08lx\n", 5, val>>5);
    printf("%2d: %08lx\n", 6, val>>6);
    printf("%2d: %08lx\n", 7, val>>7);
    printf("%2d: %08lx\n", 8, val>>8);
    printf("%2d: %08lx\n", 9, val>>9);
    printf("%2d: %08lx\n", 12, val>>12);
    printf("%2d: %08lx\n", 15, val>>15);
    printf("%2d: %08lx\n", 16, val>>16);
    printf("%2d: %08lx\n", 17, val>>17);
    printf("%2d: %08lx\n", 20, val>>20);
    printf("%2d: %08lx\n", 23, val>>23);
    printf("%2d: %08lx\n", 24, val>>24);
    printf("%2d: %08lx\n", 25, val>>25);
    printf("%2d: %08lx\n", 28, val>>28);
    printf("%2d: %08lx\n", 31, val>>31);
    printf("%2d: %08lx\n", 32, val>>32);
}

// The different ROL/ROR values
char rols[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 15, 16, 17, 20, 23, 24, 25, 28, 31 ,32 };

void rol_var(unsigned long val) {
    printf("rol var\n");
    for(char i=0;i<sizeof(rols);i++)
        printf("%2u: %08lx\n", rols[i], val<<rols[i]);
}


void ror_var(unsigned long val) {
    printf("ror var\n");
    for(char i=0;i<sizeof(rols);i++)
        printf("%2u: %08lx\n", rols[i], val>>rols[i]);
}