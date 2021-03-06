// Tests using integer conditions in while() / for() / do..while
// This should produce 'ba ba@ ba@' at the top of the screen

byte* const SCREEN = (byte*)0x0400;
byte idx = 0;

void main() {
    // for()
    for( byte i=2;i;i--) {
        SCREEN[idx++] = i;
    }
    SCREEN[idx++] = ' ';
    // while()
    byte j=3;
    while( j-- ) {
        SCREEN[idx++] = j;
    }
    SCREEN[idx++] = ' ';
    // do...while()
    byte k = 2;
    do {
        SCREEN[idx++] = k;
    } while(k--);

}