// Test loop invariant computation detection
// http://www.cs.toronto.edu/~pekhimenko/courses/cscd70-w18/docs/Lecture%205%20[LICM%20and%20Strength%20Reduction]%2002.08.2018.pdf
// Complex expressions can also be loop invariant computations
// (x+5)*2 is a loop invariant computations
char * const SCREEN = 0x0400;
char * const BGCOL = 0xd020;
void main() {
    char x = SCREEN[0];
    for(char c=0;c<40;c++) {
        SCREEN[c] = (x+5)*2;
    }
} 