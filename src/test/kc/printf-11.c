// Tests printf function call rewriting
// A simple number - with the printf-sub funtions in the same file.

__intrinsic void printf(char* format, ...);

char * screen = (char*)0x0400;
char idx = 0;

void cputs(char* str) {
    while(*str) {
        *screen++ = *str++;
    }
}

// The different supported radix
enum RADIX { BINARY=2, OCTAL=8, DECIMAL=10, HEXADECIMAL=16 };

// Format specifying how to format a printed number
struct printf_format_number {
    // The minimal number of chars to output (used for padding with spaces or 0)
    char min_length;
    // Justify left instead of right, which is the default.
    char justify_left;
    // Always show a sign for a number, even if is is positive. (Default is to only show sign for negative numbers)
    char sign_always;
    // Pad the number with zeros to get the min width
    char zero_padding;
    // Upper-case the letters in the number
    char upper_case;
    // The number radix to use for formatting
    enum RADIX radix;
};

const char printf_hextab[] = "0123456789abcdef"z;

// Print an unsigned int using a specific format
// Always prints hexadecimals - ignores min_length and flags
void printf_uint(unsigned int uvalue, struct printf_format_number format) {
    *screen++ = printf_hextab[(>uvalue)>>4];
    *screen++ = printf_hextab[(>uvalue)&0xf];
    *screen++ = printf_hextab[(<uvalue)>>4];
    *screen++ = printf_hextab[(<uvalue)&0xf];
}

void main() {
    unsigned int pct = 342;
    printf("Commodore is %x cool", pct);
}

