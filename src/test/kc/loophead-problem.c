// Demonstrates a problem where constant loophead unrolling results in an error
// The result is a NullPointerException
// The cause is that the Unroller does not handle the variable opcode correctly.
// The Unroller gets the verwions for opcode wrong because it misses the fact that it is modified inside call to popup_selector()

byte* const screen = (byte*)$400;

byte opcode = 'a'; // Offending unroll variable

void main() {
    screen[40] = opcode;
    popup_selector();
    screen[41] = opcode;
}

void popup_selector() {
	for (byte k = 0; k <= 2; k++) {
		opcode = 'b';
		screen[k] = opcode;
	}
}


