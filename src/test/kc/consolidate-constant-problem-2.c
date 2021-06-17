// Constant consolidation produces a byte* + byte* error

char* const SCREEN = (char*)0x400;

void main() {

    for(char COLS=0;COLS<2;COLS++) {
        char* sc = SCREEN + COLS*4 + 2;
        for(char i=0;i<4;i++)
            sc[i] = COLS;
    }

}