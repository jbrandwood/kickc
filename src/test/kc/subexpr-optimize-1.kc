// A sub-expression that should not be optimized (+1 to a pointer)

void main() {
    byte* SCREEN = 0x0400;
    for(byte i: 0..38) {
        SCREEN[i] = SCREEN[i+1];
        (SCREEN+40)[i] = (SCREEN+40)[i+1];
        (SCREEN+80)[i] = (SCREEN+80)[i+1];
        (SCREEN+120)[i] = (SCREEN+120)[i+1];
    }

}