// Tests word pointer math - subtracting two word pointers
void main() {
    word* w1 = (word*)0x1000;
    word* w2 = (word*)0x1140;
    word wd = w2 - w1;
    word* const SCREEN = (word*)0x0400;
    *SCREEN = wd;
}
