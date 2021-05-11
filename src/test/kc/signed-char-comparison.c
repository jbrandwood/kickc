// Illustrates problem with > comparison of signed chars.
// Reported by Danny Spijksma

void main() {
    for(signed char dy:-128..127)
        debug(dy);
}

char *SCREEN = (char*)0x0400;

void debug(signed char dy) {
    char i = (char)dy;
    if (dy > -120) {
        SCREEN[i] = 10;
    }
}