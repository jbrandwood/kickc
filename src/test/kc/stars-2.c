// Stars struct of array
#include <stdio.h>
#include <conio.h>

typedef struct {
    char star_x[5];
    char star_y[5];
    char speed_x[5];
    char speed_y[5];
} star_t;

star_t stars = {
    {50, 40, 30, 70, 40},
    {50, 70, 20, 10, 80},
    { 2,  2,  2,  2,  2},
    { 7,  7,  7,  7,  7}
};

void main() 
{
    clrscr();
    for(char i=0;i<5;i++) {     
        printf("%u %u\n", stars.star_x[i], stars.star_y[i]);
 }
}