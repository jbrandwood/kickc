// Tests creating and assigning pointers to non-args no-return functions

void main() {
    byte* const SCREEN = $400;

    void()* f;

    for ( byte i: 0..100) {
        if((i&1)==0) {
            f = &fn1;
        } else {
            f = &fn2;
        }
    }
}

void fn1() {
    byte* const BORDERCOL = $d020;
    (*BORDERCOL)++;
}

void fn2() {
    byte* const BGCOL = $d021;
    (*BGCOL)++;
}