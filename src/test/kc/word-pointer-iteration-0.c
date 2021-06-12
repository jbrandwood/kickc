// Tests simple word pointer iteration
void main() {
    byte* const SCREEN = (char*)$400+40*6;
    word* wp = (word*)$0400;
    wp++;
    SCREEN[0] = BYTE0(*wp);
    SCREEN[1] = BYTE1(*wp);
    wp++;
    SCREEN[2] = BYTE0(*wp);
    SCREEN[3] = BYTE1(*wp);
    wp--;
    SCREEN[4] = BYTE0(*wp);
    SCREEN[5] = BYTE1(*wp);

}
