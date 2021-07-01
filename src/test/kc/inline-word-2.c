// Tests minimal inline word

void main() {
    word w = MAKEWORD( 0x01, 0x02ub );
    word* screen = (word*)0x0400;
    screen[0] = w;
}