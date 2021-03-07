#pragma target(cx16)
#include <cx16.h>
#include <cx16-kernal.h>
#include <stdio.h>

// Find the value of a keypress as returned by kernal getin()
void main() {
    printf("\npress a key\n");
    char test = 0;
    while(test==0) test=getin();
    printf("\nchar = %u\n", test);
}