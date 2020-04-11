// Tests pointer plus 0 elimination

byte msg1[] = "hello world!";
byte msg2[] = "goodbye sky?";

void main() {
    byte* const SCREEN = $0400;
    SCREEN[0] = *(first(msg1)+0);
    SCREEN[1] = *(first(msg2)+0);
}

byte* first(byte* msg) {
    return (byte*)(msg+0);
}
