#include <multiply.h>

void main() {
    word* screen = (char*)0x0400;
    for( byte y: 0..5) {
	    word z1 = mul8u(y,40);
	    *screen++ = z1;
	    word z2 = mul8u(y,40);
	    *screen++ = z2;
    }
}
