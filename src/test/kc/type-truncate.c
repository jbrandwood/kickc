// Type match  bytes can be assigned from integers without issue
void main() {
    word w = 5000;
    byte b = w;
    byte* const screen = (char*)0x0400;
    screen[0] = b;
}