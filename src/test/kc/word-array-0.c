// Tests a simple word array
void main() {
    byte* const SCREEN = (char*)$400+6*40;
    word words[3] = (word*)$0400;
    word w1 = words[1];
    SCREEN[0] = <w1;
    SCREEN[1] = >w1;
    word w2 = words[2];
    SCREEN[2] = <w2;
    SCREEN[3] = >w2;
}
