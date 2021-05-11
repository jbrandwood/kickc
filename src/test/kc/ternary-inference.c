// Type inference into the ternary operator

void main() {
    byte* const screen = (char*)0x400;
    for(byte i: 0..10) {
        screen[i] = (i<5?0x57:'0')+i;
    }
}