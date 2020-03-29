// Tests variable coalescing over assignments

void main() {
    byte* const SCREEN = 0x0400;
    byte idx = 0;
    for( byte a: 0..5) {
        for( byte b: 0..5) {
            byte c = a;
            byte d = b;
            byte e = b+c;
            byte f = d+a;
            byte g = e+f;
            SCREEN[idx++] = g;
        }
    }
}