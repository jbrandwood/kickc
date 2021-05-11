// Tests that array-indexing by a constant word is turned into a constant pointer

void main() {
    byte* const screen = (char*)0x0400;
    screen[40*10] = 'a';
}

