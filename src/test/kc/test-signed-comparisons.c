// Test signed char comparisons

#include <stdio.h>
#include <conio.h>
#include <string.h>

void main() {
    clrscr();
    printf(" val  <-50 < 0  < 50 >-50 > 0  >50  \n");
    for(signed char val=-100; val<=100;val+=10) {
        char lt_m50 = (char)(val<-50);
        char lt_0 = (char)(val<0);
        char lt_p50 = (char)(val<50);
        char gt_m50 = (char)(val>-50);
        char gt_0 = (char)(val>0);
        char gt_p50 = (char)(val>50);

        printf("%4d    %1u    %1u    %1u    %1u    %1u    %1u\n", val, lt_m50, lt_0, lt_p50, gt_m50, gt_0, gt_p50);

    }

    for(;;) ;


}