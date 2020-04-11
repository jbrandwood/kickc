// Test a for-loop with two iterating variables
// Illustrates that for()-loops currently cannot contain two variable declarations.

void main() {
    byte* const SCREEN = 0x400;
    byte *sc=SCREEN+39;
    for( byte i=0; i<40; i++, sc--)
        *sc = i;
}
