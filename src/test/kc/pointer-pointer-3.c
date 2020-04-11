// Tests pointer to pointer in a more complex setup


byte* screen = $400;

byte* screen1 = $400;
byte* screen2 = $400+40;

void main() {
    setscreen(&screen, screen1);
    screen[0] = 'a';
    setscreen(&screen, screen2);
    screen[0] = 'a';
}

void setscreen(byte** screen, byte* val) {
    *screen = val;
}
