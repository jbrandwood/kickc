// Complex procedure declaration and definition.

// Copy block of memory (forwards)
// Copies the values of num chars from the location pointed to by source directly to the memory block pointed to by destination.
void* memcpy( void* destination, void* source, unsigned int num );

// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
void* memcpy( void* destination, void* source, unsigned int num ) {
    char* src = source;
    char* dst = destination;
    char* src_end = (char*)source+num;
    while(src!=src_end) *dst++ = *src++;
    return destination;
}

char * const SCREEN = (char*)0x0400;

char STRING[] = "hello world";

void main() {
    memcpy(SCREEN, STRING, sizeof(STRING));
}
