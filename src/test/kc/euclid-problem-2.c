// Demonstrates a problem where wrong alive ranges result in clobbering an alive variable
// The compiler does not realize that A is alive in the statement b=b-a - and thus can clobber it.

char* const SCREEN = 0x0400;
char idx = 0;

void main() {
    SCREEN[idx++] = euclid(128,2);
    SCREEN[idx++] = euclid(169,69);
    SCREEN[idx++] = euclid(255,155);
    SCREEN[idx++] = euclid(99,3);
}

// Calculate least common denominator using euclids subtraction method
unsigned char euclid(unsigned char a, unsigned char b) {
	while (a!=b) {
		if(a>b) {
			a = a-b;
		} else {
			b = b-a;
		}
	}
	return a;
}

