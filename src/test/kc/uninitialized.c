// Tests uninitialized values of variables.

byte b;
word w;
byte* ptr;

byte* const SCREEN = (char*)$400;

void main() {
    SCREEN[0] = b;
    SCREEN[2] = <w;
    SCREEN[3] = >w;
    SCREEN[5] = (byte)<ptr;
    SCREEN[5] = (byte)>ptr;
}
