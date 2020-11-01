// The following casuses an exception in pass 2
// https://gitlab.com/camelot/kickc/-/issues/561

char const * r = 0x8000;

void main() {
	enableDLI(&fn1);
}

void fn1() {
	*r = 1;
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
