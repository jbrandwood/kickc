// Demonstrates problem where reserved ZP addresses can still be coalesced if they are explicitly __address() assigned to variables
// https://gitlab.com/camelot/kickc/-/issues/550

#pragma target(atarixl)
#pragma zp_reserve(0x00..0x7f)

void main() {
	benchmarkCountdownFor();
	benchmarkLandscape();
}

char landscapeBase[] = kickasm {{
		.fill 14, 0
	}};

char * const lms = 0xa000;

void benchmarkCountdownFor() {
	__address(0x41) signed char a;
	__address(0x4b) signed char b;
	for(a = 1; a >= 0; a--) {
		for(b = 9; b >= 0; b--) {
		}
	}
}

void benchmarkLandscape() {
	char colHeight[14];

	for(char z: 0..9) {
		for (char i: 0..13) { colHeight[i] = landscapeBase[i]; }
		for (signed char x = 39; x >= 0; x--) {
			char *screenAddress = lms + x;
			char start = 0;
			for (signed char c = 13; c >= 0; c--) {
				char uc = (char) c;
				char stop = colHeight[uc];
				while (start < stop) {
					*screenAddress = ((*screenAddress) & 0xf) | (uc << 4);
					screenAddress += 40;
					start++;
				}
				start = stop;
			}
		}
	}
}
