#include <print.h>

// Print a number of zero-terminated strings, each followed by a newline.
// The sequence of lines is terminated by another zero.
void print_str_lines(char*  str);

// Print a zero-terminated string followed by a newline
void print_str_ln(char*  str);

// Print a zero-terminated string
void print_str(char*  str);

// Print a string at a specific screen position
void print_str_at(char*  str, char*  at);

// Print a newline
void print_ln();

// Print a int as HEX
void print_sint(signed int w);

// Print a signed char as HEX
void print_schar(signed char b);

// Prints a signed char as HEX at a specific position on the screen
// row and col are 0-based indices
inline void print_schar_pos(signed char sb, char row, char col);

// Print a signed char as hex at a specific screen position
void print_schar_at(signed char b, char*  at);

// Print a unsigned int as HEX
void print_uint(unsigned int w);

// Print a char as DECIMAL
void print_uchar_decimal(char b);

// Print a unsigned int as DECIMAL
void print_uint_decimal(unsigned int w);

// Print a signed int as DECIMAL
void print_sint_decimal(int w);

// Print a unsigned int as HEX at a specific position
void print_uint_at(unsigned int w, char* at);

// Print a unsigned long as HEX
void print_ulong(unsigned long dw);

// Print a unsigned long as DECIMAL
void print_ulong_decimal(unsigned long w);

// Print a unsigned long as HEX at a specific position
void print_ulong_at(unsigned long dw, char*  at);

// Print a signed long as HEX
void print_slong(signed long dw);

// Print a char as HEX
void print_uchar(char b);

// Prints a char as HEX at a specific position on the screen
// row and col are 0-based indices
void print_uchar_pos(char b, char row, char col);

// Print a char as HEX at a specific position
void print_uchar_at(char b, char*  at);

// Print a single char
void print_char(char ch);

// Print a single char
void print_char_at(char ch, char* at);

// Clear the screen. Also resets current line/char cursor.
void print_cls();

// Set the screen to print on. Also resets current line/char cursor.
void print_set_screen(char*  screen);