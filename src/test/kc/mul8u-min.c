// Minimal test of mul8u

#include <multiply.h>

void main() {

    word* const screen = 0x0400;
    byte i = 0;

    for(byte a: 0..5)
        for (byte b: 0..5)
            screen[i++] = mul8u(a,b);

}