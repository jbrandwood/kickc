// Tests subtracting a number from a literal char

void main() {
    byte* const SCREEN = (char*)0x0400;
    *SCREEN = 'a' - 1;
}