// Tests the speed of printf()
#include <stdio.h>
#include <c64-tod.h>

void main() {
  tod_init(TOD_ZERO);
  for(unsigned int i=0;i<10000;i++) {
    if((i&0x7f) == 0) { 
        gotoxy(0,16);
        printf("%u",i);
        gotoxy(0,0);  
    }
    printf("qwe ");
  }
  gotoxy(0, 22);
  printf("time: %s",tod_str(tod_read()));
}