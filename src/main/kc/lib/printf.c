#include <stdlib.h>
#include <string.h>
#include <printf.h>

#define PRINTF_SCREEN_ADDRESS 0x0400
#define PRINTF_SCREEN_WIDTH 40
#define PRINTF_SCREEN_HEIGHT 25
#define PRINTF_SCREEN_BYTES PRINTF_SCREEN_WIDTH*PRINTF_SCREEN_HEIGHT

// X-position of cursor
__ma char printf_cursor_x = 0;
// Y-position of cursor
__ma char printf_cursor_y = 0;
// Pointer to cursor address
__ma char* printf_cursor_ptr = PRINTF_SCREEN_ADDRESS;

// Buffer used for stringified number being printed
struct printf_buffer_number printf_buffer;

// Print a formatted string.
// https://en.wikipedia.org/wiki/Printf_format_string
// This implementation supports decimal, octal and hexadecimal radix. It supports min length, left/right justify, zero-padding and always-sign.
__intrinsic void printf(char* format, ...);

// Clear the screen. Also resets current line/char cursor.
void printf_cls() {
    memset(PRINTF_SCREEN_ADDRESS, ' ', PRINTF_SCREEN_BYTES);
    printf_cursor_ptr = PRINTF_SCREEN_ADDRESS;
    printf_cursor_x = 0;
    printf_cursor_y = 0;
}

// Print a single char
// If the end of the screen is reached scroll it up one char and place the cursor at the
void printf_char(char ch) {
    *(printf_cursor_ptr++) = ch;
    if(++printf_cursor_x==PRINTF_SCREEN_WIDTH) {
        printf_cursor_x = 0;
        ++printf_cursor_y;
        if(printf_cursor_y==PRINTF_SCREEN_HEIGHT) {
            memcpy(PRINTF_SCREEN_ADDRESS, PRINTF_SCREEN_ADDRESS+PRINTF_SCREEN_WIDTH, PRINTF_SCREEN_BYTES-PRINTF_SCREEN_WIDTH);
            memset(PRINTF_SCREEN_ADDRESS+PRINTF_SCREEN_BYTES-PRINTF_SCREEN_WIDTH, ' ', PRINTF_SCREEN_WIDTH);
            printf_cursor_ptr = printf_cursor_ptr-PRINTF_SCREEN_WIDTH;
            printf_cursor_y--;
        }
    }
}

// Print a newline
void printf_ln() {
    printf_cursor_ptr =  printf_cursor_ptr - printf_cursor_x + PRINTF_SCREEN_WIDTH;
    printf_cursor_x = 0;
    printf_cursor_y++;
}

// Print a padding char a number of times
void printf_padding(char pad, char length) {
    for(char i=0;i<length; i++)
        printf_char(pad);
}

// Print a zero-terminated string
// Handles escape codes such as newline
void printf_str(char* str) {
    while(true) {
        char ch = *str++;
        if(ch==0) break;
        if(ch=='\n')
            printf_ln();
        else
            printf_char(ch);
    }
}

// Print a signed long using a specific format
void printf_slong(signed long value, struct printf_format_number format) {
    // Handle any sign
    printf_buffer.sign = 0;
    if(value<0) {
        // Negative
         value = -value;
         printf_buffer.sign = '-';
    } else {
        // Positive
        if(format.sign_always)
            printf_buffer.sign = '+';
    }
    // Format number into buffer
    unsigned long uvalue = (unsigned long)value;
    ultoa(uvalue, printf_buffer.digits, format.radix);
    // Print using format
    printf_number_buffer(printf_buffer, format);
}

// Print an unsigned int using a specific format
void printf_ulong(unsigned long uvalue, struct printf_format_number format) {
    // Handle any sign
    printf_buffer.sign = format.sign_always?'+':0;
    // Format number into buffer
    ultoa(uvalue, printf_buffer.digits, format.radix);
    // Print using format
    printf_number_buffer(printf_buffer, format);
}

// Print a signed integer using a specific format
void printf_sint(signed int value, struct printf_format_number format) {
    // Handle any sign
    printf_buffer.sign = 0;
    if(value<0) {
        // Negative
         value = -value;
         printf_buffer.sign = '-';
    } else {
        // Positive
        if(format.sign_always)
            printf_buffer.sign = '+';
    }
    // Format number into buffer
    unsigned int uvalue = (unsigned int)value;
    utoa(uvalue, printf_buffer.digits, format.radix);
    // Print using format
    printf_number_buffer(printf_buffer, format);
}

// Print an unsigned int using a specific format
void printf_uint(unsigned int uvalue, struct printf_format_number format) {
    // Handle any sign
    printf_buffer.sign = format.sign_always?'+':0;
    // Format number into buffer
    utoa(uvalue, printf_buffer.digits, format.radix);
    // Print using format
    printf_number_buffer(printf_buffer, format);
}

// Print a signed char using a specific format
void printf_schar(signed char value, struct printf_format_number format) {
    // Handle any sign
    printf_buffer.sign = 0;
    if(value<0) {
        // Negative
         value = -value;
         printf_buffer.sign = '-';
    } else {
        // Positive
        if(format.sign_always)
            printf_buffer.sign = '+';
    }
    // Format number into buffer
    unsigned char uvalue = (unsigned char)value;
    uctoa(uvalue, printf_buffer.digits, format.radix);
    // Print using format
    printf_number_buffer(printf_buffer, format);
}

// Print an unsigned char using a specific format
void printf_uchar(unsigned char uvalue, struct printf_format_number format) {
    // Handle any sign
    printf_buffer.sign = format.sign_always?'+':0;
    // Format number into buffer
    uctoa(uvalue, printf_buffer.digits, format.radix);
    // Print using format
    printf_number_buffer(printf_buffer, format);
}

// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
void printf_number_buffer(struct printf_buffer_number buffer, struct printf_format_number format) {
    signed char padding = 0;
    if(format.min_length) {
        // There is a minimum length - work out the padding
        signed char len = (signed char)strlen(buffer.digits);
        if(buffer.sign) len++;             
        padding = (signed char)format.min_length - len;
        if(padding<0) padding = 0;
    }
    if(!format.justify_left && !format.zero_padding && padding)
        printf_padding(' ',(char)padding);
    if(buffer.sign)
        printf_char(buffer.sign);
    if(format.zero_padding && padding)
        printf_padding('0',(char)padding);
    if(format.upper_case) {
        strupr(buffer.digits);
    }
    printf_str(buffer.digits);
    if(format.justify_left && !format.zero_padding && padding)
        printf_padding(' ',(char)padding);
}

// Print a string value using a specific format
// Handles justification and min length 
void printf_string(char* str, struct printf_format_string format) {
    signed char padding = 0;
    if(format.min_length) {
        signed char len = (signed char)strlen(str);
        padding = (signed char)format.min_length  - len;
        if(padding<0) padding = 0;
    }
    if(!format.justify_left && padding)
        printf_padding(' ',(char)padding);
    printf_str(str);
    if(format.justify_left && padding)
        printf_padding(' ',(char)padding);
}

