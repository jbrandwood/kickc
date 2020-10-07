// Test loop invariant computation detection
// http://www.cs.toronto.edu/~pekhimenko/courses/cscd70-w18/docs/Lecture%205%20[LICM%20and%20Strength%20Reduction]%2002.08.2018.pdf
// In a double loop a constant expression in the inner loop is hoisted out into the outer loop
// SCREEN + (unsigned int)y*40 can be hoisted to the outer y-loop
char * const SCREEN = 0x0400;
void main() {
    for(char y=0;y<25;y++) {
        for(char x=0;x<40;x++) {
            char * p = SCREEN + (unsigned int)y*40 + x;
           *p = '*';
        }
    }
}