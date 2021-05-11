// Tests comma-separated declarations

void main() {
    byte* const SCREEN = (char*)$400;
    byte b = 'c', c = b+1, d = c+1;
    SCREEN[0] = b;
    SCREEN[1] = c;
    SCREEN[2] = d;
}