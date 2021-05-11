// Test legal definition of multiple local variables with the same name

char * const SCREEN = (char*)0x0400;
char idx;
char c;

// And a little code using them
void main() {
    char c;
    for( char c: 0..10)
        for( char c: 0..10)
            SCREEN[idx++] = '*';
}







