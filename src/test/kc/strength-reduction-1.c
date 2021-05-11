// Test loop invariant computation detection
// http://www.cs.toronto.edu/~pekhimenko/courses/cscd70-w18/docs/Lecture%205%20[LICM%20and%20Strength%20Reduction]%2002.08.2018.pdf
char * SCREEN = (char*)0x0400;
void main() {
    char x = *SCREEN;
    for(char c=0;c<40;c++) {
        // x+5 is a loop invariant computation
        SCREEN[c] = x+5;
    }
} 