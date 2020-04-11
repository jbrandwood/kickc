// Tests comma-separated declarations with different array-ness

void main() {
    char* const SCREEN = $400;
    char b, c[3], d;
    SCREEN[0] = b;
    SCREEN[1] = c[0];
    SCREEN[2] = d;
}