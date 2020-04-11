// Tests minimal inline dword

void main() {
    dword w = { 0x01234, 0x5678 };
    dword* screen = 0x0400;
    screen[0] = w;
}