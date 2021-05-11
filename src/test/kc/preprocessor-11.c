// Test the preprocessor
// #error that is not used

#ifdef ERR
#error Preprocessor causing an error!
#endif

char * const SCREEN = (char*)0x0400;

void main() {
    SCREEN[0] = 'a';
}