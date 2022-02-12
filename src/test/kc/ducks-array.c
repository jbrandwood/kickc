#include <stdio.h>
unsigned byte points[]={1,2,3,4};

void chrout(volatile char register(A) petscii)
    { asm { jsr $ffd2 }}

void main()
{
chrout(149);
chrout(points[0]);
chrout(points[1]);
chrout(points[2]);
chrout(points[3]);
}
