

void main() {
    dword a = 4000000000;
    for( byte i: 0..100) {
        dword b = a + i;
        byte c = (byte) b;
        byte* const SCREEN = $400;
        SCREEN[i] = c;
    }
}