// Fill screen using an word-based index

char * SCREEN = 0x0400;

void main() {
	for(unsigned int i=0;i<1000; i++) 
    	SCREEN[i] = ' ';
}
