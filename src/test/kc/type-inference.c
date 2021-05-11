// Test inference of integer types in expressions

void main() {
    word* const screen = (char*)0x0400;
    for( byte b: 0..20) {
        screen[b] = -0x30+b;
    }
}

