// Functions for printing formatted strings
#include <stdlib.h>
#include <conio.h>

// Print a formatted string.
// https://en.wikipedia.org/wiki/Printf_format_string
// This implementation supports decimal, octal and hexadecimal radix. It supports min length, left/right justify, zero-padding and always-sign.
void printf(char* format, ...);

// Print a padding char a number of times
void printf_padding(char pad, char length);

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

// Buffer used for stringified number being printed
struct printf_buffer_number {
    // Sign used for printing numbers (0 if no sign, '-' if a minus-sign, '+' if a plus-sign)
    char sign;
    // The buffer used for the digits. Size is chosen because it fits LONG_MAX in octal.
    char digits[11];
};

// Print a signed long using a specific format
void printf_slong(signed long value, struct printf_format_number format);

// Print an unsigned int using a specific format
void printf_ulong(unsigned long uvalue, struct printf_format_number format);

// Print a signed integer using a specific format
void printf_sint(signed int value, struct printf_format_number format);

// Print an unsigned int using a specific format
void printf_uint(unsigned int uvalue, struct printf_format_number format);

// Print a signed char using a specific format
void printf_schar(signed char value, struct printf_format_number format);

// Print an unsigned char using a specific format
void printf_uchar(unsigned char uvalue, struct printf_format_number format);

// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
void printf_number_buffer(struct printf_buffer_number buffer, struct printf_format_number format);

// Format specifying how to format a printed string
struct printf_format_string {
    // The minimal number of chars to output (used for padding with spaces or 0).
    char min_length;
    // Justify left instead of right, which is the default.
    char justify_left;
};

// Print a string value using a specific format
// Handles justification and min length
void printf_string(char* str, struct printf_format_string format);