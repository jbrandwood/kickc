// Tests minimal inline word

void main() {
    word w = { 0x01, 0x02ub };
    word* screen = (word*)0x0400;
    screen[0] = w;
}