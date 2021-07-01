// Tests minimal inline word

void main() {
    word w = MAKEWORD( 0x01, 0x02 );
    word* screen = (char*)0x0400;
    screen[0] = w;
}