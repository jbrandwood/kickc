// Tests creating pointers to non-args no-return functions

void main() {
    byte* const SCREEN = $400;

    void()* f;
    f = &fn1;
    SCREEN[0] = <(word)f;
    SCREEN[1] = >(word)f;
    f = &fn2;
    SCREEN[2] = <(word)f;
    SCREEN[3] = >(word)f;

}

void fn1() {
    byte* const BORDER_COLOR = $d020;
    (*BORDER_COLOR)++;
}

void fn2() {
    byte* const BG_COLOR = $d021;
    (*BG_COLOR)++;
}