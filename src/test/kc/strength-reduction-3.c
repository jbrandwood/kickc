// Test loop invariant computation detection
// http://www.cs.toronto.edu/~pekhimenko/courses/cscd70-w18/docs/Lecture%205%20[LICM%20and%20Strength%20Reduction]%2002.08.2018.pdf
// Deref of a pointer cannot be hoisted
// *BGCOL+5 is NOT a loop invariant computation
char * const SCREEN = 0x0400;
char * const BGCOL = 0xd020;
void main() {
    volatile char x = SCREEN[0];
    for(char c=0;c<40;c++) {
        SCREEN[c] = *BGCOL+5;
    }
} 