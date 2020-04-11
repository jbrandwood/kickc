byte *SCREEN = $0400;

void main() {
    byte c = (*SCREEN);
    fillscreen(c);
}

void fillscreen(byte c) {
    for(byte j : 0..249) {
        byte* SCREEN2 = SCREEN+250;
        byte* SCREEN3 = SCREEN+500;
        byte* SCREEN4 = SCREEN+750;
        SCREEN[j] = c;
        SCREEN2[j] = c;
        SCREEN3[j] = c;
        SCREEN4[j] = c;
    }
}

