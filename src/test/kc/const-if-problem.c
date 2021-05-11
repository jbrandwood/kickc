// Constant if() contains call to (unused) function - should be optimized away

byte* SCREEN = (char*)$400;

void main() {
	if(1==1) {
		SCREEN[0] = 'a';
	} else {
		doit();
	}
}

byte cc = 'b';

void doit() {
	SCREEN[1] = cc;
	doit2();
}

void doit2() {
	SCREEN[2] = cc;
}
