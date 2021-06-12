// Tests simple word pointer math
void main() {
    word* words = (word*)$0400;
    byte* const SCREEN = (byte*)$400+6*40;
    word w1 = *(words+1);
    SCREEN[0] = BYTE0(w1);
    SCREEN[1] = BYTE1(w1);
    word w2 = *(words+2);
    SCREEN[2] = BYTE0(w2);
    SCREEN[3] = BYTE1(w2);
}
