#include <conio.h>
#include <stdlib.h>
#include <string.h>
#include <printf.h>

// Buffer used for stringified number being printed
struct printf_buffer_number printf_buffer;

// Print a formatted string.
// https://en.wikipedia.org/wiki/Printf_format_string
// This implementation supports decimal, octal and hexadecimal radix. It supports min length, left/right justify, zero-padding and always-sign.
__intrinsic void printf(char* format, ...);

// Print a padding char a number of times
void printf_padding(char pad, char length) {
    for(char i=0;i<length; i++)
        cputc(pad);
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
        cputc(buffer.sign);
    if(format.zero_padding && padding)
        printf_padding('0',(char)padding);
    if(format.upper_case) {
        strupr(buffer.digits);
    }
    cputs(buffer.digits);
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
    cputs(str);
    if(format.justify_left && padding)
        printf_padding(' ',(char)padding);
}

