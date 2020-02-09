// C standard library string.h
// Functions to manipulate C strings and arrays.

typedef word size_t ;

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
    if((word)destination<(word)source) {
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
char* strcpy( char* destination, byte* source ) {
    char* src = source;
    char* dst = destination;
    while(*src) *dst++ = *src++;
    *dst = 0;
    return destination;
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