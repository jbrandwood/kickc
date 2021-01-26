#include <stdio.h>


void main() {
    byte test = 0;
    while(test==0) test=fgetc();
    printf("\nchar = %u\n", test);
}