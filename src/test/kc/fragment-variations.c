// Tests that ASM fragment variations works
// ASM fragment variations "cast" constants to different types

void main() {
    dword* screen = (dword*)0x400;
    word w = 10;
    screen[0] = mul16u(w, w);
    w = 1000;
    screen[1] = mul16u(w, w);
}

dword mul16u(word b, word a) {
    dword mb = b;
    return mb+a;
}

