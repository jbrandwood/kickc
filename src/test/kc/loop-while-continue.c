// Tests break statement in a simple loop

byte* const SCREEN = $400;

void main() {
    byte i=0;
    while(++i<40*6) {
        if(SCREEN[i]==' ')
            continue;
        SCREEN[i]++;
    }
}