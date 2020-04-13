#include <stdlib.h>
#include <string.h>

char* print_screen = $0400;
char* print_line_cursor = print_screen;
char* print_char_cursor = print_line_cursor;

// Print a number of zero-terminated strings, each followed by a newline.
// The sequence of lines is terminated by another zero.
void print_str_lines(char* str) {
    while(*str) {
        do {
            char ch = *(str++);
            if(ch) {
                *(print_char_cursor++) = ch;
            }
        } while (ch);
        print_ln();
    }
}

// Print a zero-terminated string followed by a newline
void print_str_ln(char* str) {
    print_str(str);
    print_ln();
}

// Print a zero-terminated string
void print_str(char* str) {
    while(*str) {
        *(print_char_cursor++) = *(str++);
    }
}

// Print a string at a specific screen position
void print_str_at(char* str, char* at) {
    while(*str) {
        *(at++) = *(str++);
    }
}

// Print a newline
void print_ln() {
    do {
        print_line_cursor = print_line_cursor + $28;
    } while (print_line_cursor<print_char_cursor);
    print_char_cursor = print_line_cursor;
}

// Print a signed int as HEX
void print_sint(signed int w) {
    if(w<0) {
        print_char('-');
        w = -w;
    } else {
        print_char(' ');
    }
    print_uint((unsigned int)w);
}

// Print a signed char as HEX
void print_schar(signed char b) {
    if(b<0) {
        print_char('-');
        b = -b;
    } else {
        print_char(' ');        
    }
    print_uchar((char)b);
}

// Prints a signed char as HEX at a specific position on the screen
// row and col are 0-based indices
inline void print_schar_pos(signed char sb, char row, char col) {
    print_schar_at(sb, print_screen+row*40+col);
}

// Print a signed char as hex at a specific screen position
void print_schar_at(signed char b, char* at) {
    if(b<0) {
        print_char_at('-', at);
        b = -b;
    } else {
        print_char_at(' ', at);        
    }
    print_uchar_at((char)b, at+1);
}

// Print a unsigned int as HEX
void print_uint(unsigned int w) {
    print_uchar(>w);
    print_uchar(<w);
}

// Digits used for storing the decimal unsigned int
char decimal_digits[6];

// Print a char as DECIMAL
void print_uchar_decimal(char b) {
    utoa((unsigned int)b, decimal_digits, DECIMAL);
    print_str(decimal_digits);
}

// Print a unsigned int as DECIMAL
void print_uint_decimal(unsigned int w) {
    utoa(w, decimal_digits, DECIMAL);
    print_str(decimal_digits);
}

// Print a unsigned int as HEX at a specific position
void print_uint_at(unsigned int w, char* at) {
    print_uchar_at(>w, at);
    print_uchar_at(<w, at+2);
}

// Print a unsigned long as HEX
void print_ulong(unsigned long dw) {
    print_uint(>dw);
    print_uint(<dw);
}

// Digits used for storing the decimal unsigned int
char decimal_digits_long[11];

// Print a unsigned long as DECIMAL
void print_ulong_decimal(unsigned long w) {
    ultoa(w, decimal_digits_long, DECIMAL);
    print_str(decimal_digits_long);
}

// Print a unsigned long as HEX at a specific position
void print_ulong_at(unsigned long dw, char* at) {
    print_uint_at(>dw, at);
    print_uint_at(<dw, at+4);
}

// Print a signed long as HEX
void print_slong(signed long dw) {
    if(dw<0) {
        print_char('-');
        dw = -dw;
    } else {
        print_char(' ');
    }
    print_ulong((unsigned long)dw);
}

const char print_hextab[] = "0123456789abcdef"z;

// Print a char as HEX
void print_uchar(char b) {
    // Table of hexadecimal digits
    print_char(print_hextab[b>>4]);
    print_char(print_hextab[b&$f]);
}

// Prints a char as HEX at a specific position on the screen
// row and col are 0-based indices
inline void print_uchar_pos(char b, char row, char col) {
    print_uchar_at(b, print_screen+row*40+col);
}

// Print a char as HEX at a specific position
void print_uchar_at(char b, char* at) {
    // Table of hexadecimal digits
    print_char_at(print_hextab[b>>4], at);
    print_char_at(print_hextab[b&$f], at+1);
}

// Print a single char
void print_char(char ch) {
    *(print_char_cursor++) = ch;
}

// Print a single char
void print_char_at(char ch, char* at) {
    *(at) = ch;
}

// Clear the screen. Also resets current line/char cursor.
void print_cls() {
    memset(print_screen, ' ', 1000);
    print_line_cursor = print_screen;
    print_char_cursor = print_line_cursor;
}

// Set the screen to print on. Also resets current line/char cursor.
void print_set_screen(char* screen) {
    print_screen = screen;
    print_line_cursor = print_screen;
    print_char_cursor = print_line_cursor;
}
