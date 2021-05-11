// Tests creating and assigning pointers to non-args return with function value

void main() {
    byte* const SCREEN = (char*)$400;

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
    byte* const BORDER_COLOR = (char*)$d020;
    (*BORDER_COLOR)++;
    return *BORDER_COLOR;
}

byte fn2() {
    byte* const BG_COLOR = (char*)$d021;
    (*BG_COLOR)++;
    return *BG_COLOR;
}