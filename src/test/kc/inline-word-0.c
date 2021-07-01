// Tests minimal inline word

void main() {
    word w = MAKEWORD( 0x02ub, 0x01ub );
    word* screen = (char*)0x0400;
    screen[0] = w;
}