// Stars array of struct
#include <stdio.h>
#include <conio.h>

typedef struct {
    char star_x;
    char star_y;
    char speed_x;
    char speed_y;
} star_t;

star_t stars[5] = { 
    {50, 50, 2, 7},
    {40, 70, 2, 7},
    {30, 20, 2, 7},
    {70, 10, 2, 7},
    {40, 80, 2, 7}
};

void main() 
{
    clrscr();
    star_t *pStar = stars;
    for( char i=0;i<5;i++) {     
        printf("%p %u %u\n", pStar, pStar->star_x, pStar->star_y);
        pStar++;
    }
}