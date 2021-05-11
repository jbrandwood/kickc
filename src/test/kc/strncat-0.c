// Test strncat() implementation

char hello[] = "hello";
char space[] = " ";
char world[] = "world war 3";

char build[40];

char* const SCREEN = (char*)0x0400;

void main() {
    strncat(build, hello, 5);
    strncat(build, space, 5);
    strncat(build, world, 5);

    char i=0;
    while(build[i]) {
        SCREEN[i] = build[i];
        i++;
    }
}

// Appends the first num characters of source to destination, plus a terminating null-character.
// If the length of the C string in source is less than num, only the content up to the terminating null-character is copied.
char *strncat(char *destination, const char *source, unsigned int num) {
	char *dst = destination;
	// Skip the existing string at dest
	while (*dst) dst++;
	// Copy up to num chars from src
	while (num && (*dst = *source++)) {
		--num;
		++dst;
	}
	// Add null-character
	*dst = 0;
	return destination;
}