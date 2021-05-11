// Test the preprocessor
// #define's with complex token bodies

#define USE_SCREEN_DEFAULT char * const SCREEN = (char*)0x0400;
#define START_MAIN void main() {
#define END_MAIN }

USE_SCREEN_DEFAULT

START_MAIN
    *SCREEN = 'a';
END_MAIN
