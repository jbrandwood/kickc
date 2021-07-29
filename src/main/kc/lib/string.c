// C standard library string.h
// Functions to manipulate C strings and arrays.
#include <string.h>
#include <ctype.h>

// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
void* memcpy( void* destination, void* source, size_t num ) {
    char* src = source;
    char* dst = destination;
    char* src_end = (char*)source+num;
    while(src!=src_end) *dst++ = *src++;
    return destination;
}

// Move block of memory
// Copies the values of num bytes from the location pointed by source to the memory block pointed by destination. Copying takes place as if an intermediate buffer were used, allowing the destination and source to overlap.
void* memmove( void* destination, void* source, size_t num ) {
    if((unsigned int)destination<(unsigned int)source) {
        memcpy(destination, source, num);
    } else {
        // copy backwards
        char* src = (char*)source+num;
        char* dst = (char*)destination+num;
        for( size_t i=0; i<num; i++) *--dst = *--src;
    }
    return destination;
}

// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
void *memset(void *str, char c, size_t num) {
    if(num>0) {
        char* end = (char*)str + num;
        for(char* dst = str; dst!=end; dst++)
            *dst = c;
    }
    return str;
}

// Copies the C string pointed by source into the array pointed by destination, including the terminating null character (and stopping at that point).
char* strcpy( char* destination, char* source ) {
    char* src = source;
    char* dst = destination;
    while(*src) *dst++ = *src++;
    *dst = 0;
    return destination;
}

/// Copies up to n characters from the string pointed to, by src to dst.
/// In a case where the length of src is less than that of n, the remainder of dst will be padded with null bytes.
/// @param dst − This is the pointer to the destination array where the content is to be copied.
/// @param src − This is the string to be copied.
/// @param n − The number of characters to be copied from source.
/// @return The destination
char *strncpy(char *dst, const char *src, size_t n) {
    for(size_t i = 0;i<n;i++) {
        char c = *src;
        if(c) src++;
        *dst++ = c;
    }
    return dst;
}

// Converts a string to uppercase.
char * strupr(char *str) {
    char * src = str;
    while(*src) {
        *src = toupper(*src);
        src++;
    }
    return str;
}

// Computes the length of the string str up to but not including the terminating null character.
size_t strlen(char *str) {
    size_t len = 0;
    while(*str) {
        len++;
        str++;
    }
    return len;
}

// Searches for the first occurrence of the character c (an unsigned char) in the first n bytes of the string pointed to, by the argument str.
// - str: The memory to search
// - c: A character to search for
// - n: The number of bytes to look through
// Return: A pointer to the matching byte or NULL if the character does not occur in the given memory area.
void *memchr(const void *str, char c, size_t n) {
    char * ptr = str;
    for(size_t i=0;i<n;i++) {
        if(*ptr==c)
            return ptr;
        ptr++;
    }
    return (void*)0;
}