byte b[3] = { 1, 2, 3, 4, 5 };

void main() {
    byte* SCREEN = (char*)$400;
    SCREEN[0] = b[0];
}