
void main() {
	byte BLACK = 0;
	byte* screen = (byte*)$0400;
	byte* cols = (byte*)$d800;
	for(byte x:0..10) {
		byte y=x+12;
		screen[y] = 'a';
		cols[y] = BLACK;
	}	
}
