void main() {
	unsigned char* const SCREEN = (char*)0x0400;
	for( unsigned char i = 0; i<128; i+=2) {
		SCREEN[i] = 'a';
		 (*(unsigned char*)0xD020)=0;
	}
}

