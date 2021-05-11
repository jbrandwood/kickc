// Tests static initialization code
// Currently placed outside any function scope and pushed into @begin block.
// To be put into an initializer function.

// Initialize a volatile ZP-variable (will be done in the initializer)
volatile char c1 = 'o';

char * const SCREEN = (char*)0x0400;

void main() {
    SCREEN[0] = c1;
    SCREEN[1] = c2;
}

// Initialize another volatile ZP-variable (will be done in the initializer)
volatile char c2 = 'k';
