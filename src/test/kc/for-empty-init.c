// Tests that for()-loops can have empty inits

void main() {
    byte* const SCREEN = (char*)$400;
    unsigned char i=0;
    for(;i<10;i++) {
        SCREEN[i] = i;
    }
}