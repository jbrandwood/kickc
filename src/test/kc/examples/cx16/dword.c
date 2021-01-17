
#include <conio.h>
#include <printf.h>

dword test_address[2] = {0,0};

void method(char layer, dword dw1, dword dw2) {
    test_address[layer] = dw1;
    printf("test = %x\n",test_address[layer]);
}

void main() {
    method(1,0x0002,0x12000);
    method(2,0x0001,0x12000);
}