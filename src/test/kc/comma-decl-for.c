// Tests comma-separated declarations inside for()

void main() {
    byte* const SCREEN = (char*)$400;
    for(byte i, j='g'; i<10; i++, j++) {
        SCREEN[i] = j;
    }
}