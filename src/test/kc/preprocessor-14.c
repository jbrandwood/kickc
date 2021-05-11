// Test the preprocessor
// Test for existence of the __KICKC__ define

void main() {
    char * const SCREEN = (char*)0x0400;
    #ifdef __KICKC__
        *SCREEN = 1;
    #endif
}