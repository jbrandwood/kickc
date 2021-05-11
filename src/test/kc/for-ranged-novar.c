// Tests that ranged for()-loops must have an iterator variable

void main() {
    byte* const SCREEN = (char*)$400;

    for( : 0..10) {
        SCREEN[i] = i;
    }
}