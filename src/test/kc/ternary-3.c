// Tests the ternary operator - when the condition is constant

void main() {
    byte* const SCREEN = (char*)$400;
    for( byte i: 0..9) {
        SCREEN[i] = cond(i)?m1(i):m2(i);
    }
}

bool cond(byte b) {
    return b<5;
}

byte m1(byte i) {
    return 5+i;
}

byte m2(byte i) {
    return 10+i;
}
