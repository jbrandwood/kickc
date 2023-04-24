#pragma target(cx16)
#include <cx16.h>
#include <kernal.h>
#include <stdio.h>

// Find the value of a keypress as returned by conio kbhit()
void main() {
    printf("\npress a key\n");
    char test = 0;
    while(test==0) test=kbhit();
    printf("\nchar = %u\n", test);
}