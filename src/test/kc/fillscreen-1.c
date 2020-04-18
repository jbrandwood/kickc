// Fill screen using an efficient char-based index

byte *SCREEN = $0400;

void main() {
    for(char i=0;i<250;i++) {
        SCREEN[i] = ' ';
        (SCREEN+250)[i] = ' ';
        (SCREEN+500)[i] = ' ';
        (SCREEN+750)[i] = ' ';
    }
}


