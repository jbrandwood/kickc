// Tests that array-indexing by a word variable that is a sum of a constant word and a byte is turned back into derefidx

void main() {
    byte* const screen = (byte*)0x0400;
    for( byte i : 0..39) {
        screen[40*10+i] = 'a';
    }
}

