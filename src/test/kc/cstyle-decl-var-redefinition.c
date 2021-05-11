// Test declarations of variables
// Redefinition

//First definition
char * const SCREEN = (char*)0x0400;

//Second definition
char * const SCREEN = (char*)0x0400;
char idx;

// And a little code using them
void main() {
    SCREEN[idx++] = 'c';
    SCREEN[idx++] = 'm';
    SCREEN[idx++] = 'l';
}







