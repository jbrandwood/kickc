// Rolling constants by a variable amount

void main() {
    byte* screen = $400;
    for( byte b: 0..7) {
        screen[b] = $55 << b;
    }

}