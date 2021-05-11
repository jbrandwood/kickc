byte* const SCREEN = (char*)$400;

void main() {
    byte a;
    for( byte i : 0..39) {
        SCREEN[i] = a = i;
        (SCREEN+80)[i] = a;
    }
}