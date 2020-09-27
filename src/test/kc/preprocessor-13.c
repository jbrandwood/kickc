// Test the preprocessor
// No whitespace allowed between macro name and parenthesis when defining function-like macro
// http://www-tcad.stanford.edu/local/DOC/cpp_11.html

// Define FOO to take an argument and expand into double the argument
#define FOO(x) 2 * (x)

// Define BAR to take no argument and always expand into (x) + 2 * (x).
#define BAR (x) + 2 * (x)

void main() {
    char x = 7;
    char * const SCREEN = 0x0400;
    // Call without spaces
    SCREEN[0] = FOO(1);
    // Call with spaces
    SCREEN[1] = FOO ( 2 );
    // Call macro without parameters
    SCREEN[2] = BAR;
}