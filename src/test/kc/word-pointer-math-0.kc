// Tests simple word pointer math
void main() {
    word* words = $0400;
    byte* const SCREEN = $400+6*40;
    word w1 = *(words+1);
    SCREEN[0] = <w1;
    SCREEN[1] = >w1;
    word w2 = *(words+2);
    SCREEN[2] = <w2;
    SCREEN[3] = >w2;
}
