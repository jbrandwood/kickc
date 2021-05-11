// Tests that for()-loops can have empty increments

void main() {
    byte* const SCREEN = (char*)$400;
    for(unsigned char i=0;i<10;) {
        SCREEN[i] = i++;
    }
}