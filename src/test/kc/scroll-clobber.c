byte* SCREEN = (byte*)$400;
byte* SCROLL = (byte*)$d016;
byte TEXT[] = "01234567";

void main() {
    byte* nxt = TEXT;
    byte i=0;
    do {
        byte c = *nxt;
        if(c==0) {
           nxt = TEXT;
           c = *nxt;
        }
        SCREEN[++i] = c;
        nxt++;
    } while (true);
}
