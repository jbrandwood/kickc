// Tests uninitialized values of variables.

byte b;
word w;
byte* ptr;

byte* const SCREEN = (char*)$400;

void main() {
    SCREEN[0] = b;
    SCREEN[2] = BYTE0(w);
    SCREEN[3] = BYTE1(w);
    SCREEN[5] = BYTE0(ptr);
    SCREEN[5] = BYTE1(ptr);
}
