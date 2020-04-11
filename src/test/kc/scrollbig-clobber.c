// Clobber problem in next_char return value

byte* TEXT = "cml ";

void main() {
    byte* SCREEN = $400;
    for( byte i: 0..255) {
        SCREEN[i] = next_char();
    }
}

byte* nxt = TEXT;

// Find the next char of the text
byte next_char() {
    byte c = *nxt;
    if(c==0) {
        nxt = TEXT;
        c = *nxt;
    }
    nxt++;
    return c;
}

