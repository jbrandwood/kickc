// Test loop invariant computation detection
// http://www.cs.toronto.edu/~pekhimenko/courses/cscd70-w18/docs/Lecture%205%20[LICM%20and%20Strength%20Reduction]%2002.08.2018.pdf
// Only expressions on all execution paths in the loop can be hoisted out
// (y = 0;) is not on every loop execution path and should not be hoisted
char * const SCREEN = 0x0400;
char * const BGCOL = 0xd020;
void main() {
    char y = SCREEN[0];
    for(char c=0;c<40;c++) {
        if(c==10)
            y = 0;
    }
    SCREEN[80] = y;
}