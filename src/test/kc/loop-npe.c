// Illustrated compiler NPE when doing ranged loop without declaring the loop variable.


void main() {
    byte* SCREEN = 0x0400;
    clear_line(SCREEN);
}


void clear_line(byte *line) {
    for (i: 0..39)
        line[i] = 0;
}