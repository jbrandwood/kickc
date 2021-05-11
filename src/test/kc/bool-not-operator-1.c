// Test the boolean NOT operator
// Bool not operator used in ternary operator
// Fails due to "Number integer type not resolved to fixed size integer type"
// https://gitlab.com/camelot/kickc/issues/199

void main() {
    char* const screen = (char*)0x0400;
    for(char i: 0..7) {
        bool b = (i&1)==1;
        char c = !b ? 1 : 0 ;
        screen[i] = c;
    }
}