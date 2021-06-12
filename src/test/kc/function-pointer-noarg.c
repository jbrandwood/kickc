// Tests creating pointers to non-args no-return functions

void main() {
    byte* const SCREEN = (char*)$400;

    void (*f)();
    f = &fn1;
    SCREEN[0] = BYTE0((word)f);
    SCREEN[1] = BYTE1((word)f);
    f = &fn2;
    SCREEN[2] = BYTE0((word)f);
    SCREEN[3] = BYTE1((word)f);

}

void fn1() {
    byte* const BORDER_COLOR = (char*)$d020;
    (*BORDER_COLOR)++;
}

void fn2() {
    byte* const BG_COLOR = (char*)$d021;
    (*BG_COLOR)++;
}