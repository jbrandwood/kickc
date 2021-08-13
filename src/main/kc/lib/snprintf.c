/// Implementation of snprintf

/// Composes a string with the same text that would be printed if format was used on printf(),
/// but instead of being printed, the content is stored as a C string in the buffer pointed by s
/// (taking n as the maximum buffer capacity to fill).
/// @param s Pointer to a buffer where the resulting C-string is stored. The buffer should have a size of at least n characters.
/// @param n Maximum number of bytes to be used in the buffer. The generated string has a length of at most n-1, leaving space for the additional terminating null character.
/// @param format C string that contains a format string that follows the same specifications as format in printf (see printf for details).
/// @param ...  Depending on the format string, the function may expect a sequence of additional arguments, each containing a value to be used to replace a format specifier in the format string (or a pointer to a storage location, for n).
/// There should be at least as many of these arguments as the number of values specified in the format specifiers. Additional arguments are ignored by the function.
/// @return The number of characters that would have been written if n had been sufficiently large, not counting the terminating null character.
/// Notice that only when this returned value is non-negative and less than n, the string has been completely written.
__intrinsic int snprintf ( char * s, size_t n, const char * format, ... );

/// The capacity of the buffer (n passed to snprintf())
/// Used to hold state while printing
volatile size_t __snprintf_capacity;
// The number of chars that would have been filled when printing without capacity. Grows even after size>capacity.
/// Used to hold state while printing
volatile size_t __snprintf_size;
/// Current position in the buffer being filled ( initially *s passed to snprintf()
/// Used to hold state while printing
char * __snprintf_buffer;

/// Initialize the snprintf() state
void snprintf_init(char * s, size_t n) {
    __snprintf_capacity = n;
    __snprintf_size = 0;
    __snprintf_buffer = s;
}

/// Print a character into snprintf buffer
/// Used by snprintf()
/// @param c The character to print
void snputc(char c) {
    // Increment size
    ++__snprintf_size;
    // If buffer full - do nothing
    if(__snprintf_size > __snprintf_capacity)
        return;
    // If capacity reached append '\0'
    if(__snprintf_size==__snprintf_capacity)
        c = 0;
    // Append char
    *(__snprintf_buffer++) = c;
}
