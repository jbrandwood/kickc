// Tests creating and assigning pointers to non-args return with function value

void main() {
    byte* const SCREEN = $400;

    byte()* f;

    byte i = 0;
    while(true) {
        ++i;
        if((i&1)==0) {
            f = &fn1;
        } else {
            f = &fn2;
        }
       SCREEN[0] = (byte)f;
    }
}

byte fn1() {
    byte* const BORDERCOL = $d020;
    (*BORDERCOL)++;
    return *BORDERCOL;
}

byte fn2() {
    byte* const BGCOL = $d021;
    (*BGCOL)++;
    return *BGCOL;
}