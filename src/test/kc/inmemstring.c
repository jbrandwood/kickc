
byte* SCREEN = (byte*)$400;
byte TEXT[] = "camelot "z;

void main() {
    byte* cursor = SCREEN;
    byte i=0;
    do {
        *cursor = TEXT[i];
        if(++i==8) {
            i = 0;
        }
    } while(++cursor<SCREEN+1000);
}