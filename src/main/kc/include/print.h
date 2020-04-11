#include <print.h>

// Print a number of zero-terminated strings, each followed by a newline.
// The sequence of lines is terminated by another zero.
void print_str_lines(byte*  str);

// Print a zero-terminated string followed by a newline
void print_str_ln(byte*  str);

// Print a zero-terminated string
void print_str(byte*  str);

// Print a string at a specific screen position
void print_str_at(byte*  str, byte*  at);

// Print a newline
void print_ln();

// Print a int as HEX
void print_sword(signed word w);

// Print a signed byte as HEX
void print_sbyte(signed byte b);

// Prints a signed byte as HEX at a specific position on the screen
// row and col are 0-based indices
inline void print_sbyte_pos(signed byte sb, byte row, byte col);

// Print a signed byte as hex at a specific screen position
void print_sbyte_at(signed byte b, byte*  at);

// Print a word as HEX
void print_word(word w);

// Print a byte as DECIMAL
void print_byte_decimal(byte b);

// Print a word as DECIMAL
void print_word_decimal(word w);

// Print a word as HEX at a specific position
void print_word_at(word w, byte* at);

// Print a dword as HEX
void print_dword(unsigned dword dw);

// Print a unsigned long as DECIMAL
void print_dword_decimal(unsigned dword w);

// Print a unsigned long as HEX at a specific position
void print_dword_at(unsigned dword dw, byte*  at);

// Print a signed long as HEX
void print_sdword(signed dword dw);

// Print a byte as HEX
void print_byte(byte b);

// Prints a byte as HEX at a specific position on the screen
// row and col are 0-based indices
void print_byte_pos(byte b, byte row, byte col);

// Print a byte as HEX at a specific position
void print_byte_at(byte b, byte*  at);

// Print a single char
void print_char(byte ch);

// Print a single char
void print_char_at(byte ch, byte* at);

// Clear the screen. Also resets current line/char cursor.
void print_cls();

// Set the screen to print on. Also resets current line/char cursor.
void print_set_screen(byte*  screen);