// Test a constant word pointers (pointing to a word placed on zeropage).
// The result when running is "CML!" on the screen.

void main () {
    byte* screen = (char*)$400;
    word w = $0d03;
    word* wp = &w;
    screen[0] = BYTE0(*wp);
    screen[1] = BYTE1(*wp);
    *wp = $210c;
    screen[2] = BYTE0(*wp);
    screen[3] = BYTE1(*wp);
}
