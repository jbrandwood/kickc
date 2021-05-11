// Tests simple comma-expressions (without parenthesis)

void main() {
    byte* const SCREEN = (char*)$400;
    byte b;
    byte c;
    b = 1,2,3;
    c = 1+3,b+1;
    SCREEN[1,0] = c;
}