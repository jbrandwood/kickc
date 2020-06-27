// Tests that global variables with initializer gets their comments

// The screen (should become a var-comment in ASM)
__ma char * screen = 0x0400;

// The program entry point
void main() {
    // Put 'a' in screen
    *screen = 'a';
    screen++;
    // Put another 'a' in screen
    *screen = 'a';
}
