// Tests trouble passing a function pointer
// See https://gitlab.com/camelot/kickc/-/issues/557

#pragma target(atarixl)
#pragma encoding(atascii)
#pragma zp_reserve(0x00..0x7f)

#include <stdint.h>

uint8_t const * r = (uint8_t*)0x8000;

void main() {
	enableDLI(&fn1);
	enableDLI(&fn2);
}

void fn1() {
	*r = 1;
}

void fn2() {
	*r = 2;
}

void enableDLI(void *dliptr) {
	asm {
		lda dliptr
		sta dlivec
		lda dliptr+1
		sta dlivec+1

		jmp !+
		dlivec: .byte 0, 0
		!:
	}
}
