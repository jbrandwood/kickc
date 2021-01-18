

#include <printf.h>

void main() {
word value = 0xf801;
dword dw_value[2] = {0,0};
for(word t:0..1) {
    dw_value[t] = 0xf800;
}
clrscr();
printf("f801 = %x\n", dw_value[1] );
}