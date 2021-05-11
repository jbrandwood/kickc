// Illustrates introducing local scopes inside loops etc

byte* const SCREEN = (char*)$400;
void main() {
    for (byte i: 0..5)
        SCREEN[i] = 'a';
    for (byte i: 0..5)
        SCREEN[40+i] = 'b';
}