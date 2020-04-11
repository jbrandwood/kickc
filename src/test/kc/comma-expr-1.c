// Tests simple comma-expression (in parenthesis)

void main() {
    byte* const SCREEN = $400;
    byte b = (1,2,3);
    byte c = (1+1,b+1);
    SCREEN[1,0] = c;
}