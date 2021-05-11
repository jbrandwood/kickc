// Tests that chained assignments work as intended

void main() {
    byte* screen = (char*)$400;
    byte a;
    screen[0] = a = 'c';
    screen[40] = a;
    a = screen[1] = 'm';
    screen[41] = a;
    screen[2] = 1 + (a = 'l'); // Chained assignment with a modification of the result
    screen[42] = a;
}