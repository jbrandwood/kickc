// Tests different ways of scrolling up the screen

byte* const screen = (char*)$400;

void main() {
    scrollup1();
    scrollup2();
    scrollup3();
}

void scrollup1() {
    for (word line = 0; line < 40*24; line += 40)
        for (byte c=0; c<40; ++c)
            screen[line+c] = screen[line+c+40];
}

void scrollup2() {
    byte* line1 = screen;
    byte* line2 = screen+40;
    for( byte l: 0..23 )
        for (byte c: 0..39)
            *line1++ = *line2++;
}

void scrollup3() {
    for (word line = 0; line < 40*24; line += 40) {
        word l2 = line;
        for (byte c=0; c<40; ++c)
            screen[l2++] = screen[l2+40];
    }
}
