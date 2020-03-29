// Tests creating, assigning returning and calling pointers to non-args no-return functions

void main() {
    byte i = 0;
    while(true) {
        (*getfn(++i))();
    }
}

void()* getfn(byte b) {
    if((b&1)==0) {
        return &fn1;
    } else {
        return &fn2;
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