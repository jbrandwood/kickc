
void main() {
    plot(5,5);
    plot(5,5,5);
}


void plot(byte x, byte y) {
    byte* const screen = (byte*)$400;
    byte* pos = screen+x+y;
    *pos = 1;
}