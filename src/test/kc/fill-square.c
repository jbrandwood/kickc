// Fill a square on the screen

byte* SCREEN = 0x0400;

void main() {
    for( byte y: 5..15) {
        byte* line = SCREEN+(word)y*40;
        for( byte x: 5..15)
            line[x] = x+y;
    }
}