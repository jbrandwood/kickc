// Results in infinite compile loop as the compiler keeps trying to remove the same (empty) alias
byte* SCREEN = $400;
void main() {
	byte min = $ff;
	byte max = $0;
	byte pos = 0;
	while(true) {
		pos++;
		if(pos<min) {
			min = pos;
		}
		if(pos>max) {
			max = pos;
		}
		SCREEN[0] = min;
		SCREEN[1] = max;
		SCREEN[2] = pos;
	}
}
