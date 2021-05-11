// Tests a complex constant binary

void main() {
	char bError = 7;
	bError &= ~(0x10 | 0x20 | 0x40);
	char* const screen = (char*)0x0400;
	*screen = bError;
}

