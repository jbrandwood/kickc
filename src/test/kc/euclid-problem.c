// Demonstrates a problem where wrong alive ranges result in clobbering an alive variable
// The compiler does not realize that A is alive in the statement b=b-a - and thus can clobber it.

char* SCREEN = 0x0400;

void main() {
    char a = 128;
    char b = 2;
	while (a!=b) {
		if(a>b) {
			a = a-b;
		} else {
			b = b-a;
		}
	}
	*SCREEN = a;

}
