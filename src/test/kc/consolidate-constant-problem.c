byte* const screen = (byte*)$400;

void main() {
    inline for( byte j: 0..1) {
	    *(screen+40*j+39) = 0;
	    screen[40*j+37] = 0;
    }
}