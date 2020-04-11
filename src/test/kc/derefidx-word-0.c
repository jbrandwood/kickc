// Tests that array-indexing by a word variable is turned into pointer addition

void main() {
    byte* const screen = 0x0400;
    for( word i=0;i<1000;i+=40) {
        screen[i] = 'a';
    }

}

