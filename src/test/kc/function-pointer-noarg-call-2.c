// Tests creating, assigning and calling pointers to non-args no-return functions

void main() {
    byte* const SCREEN = (char*)$400;

    void (*f)();

    byte i = 0;
    while(true) {
        ++i;
        if((i&1)==0) {
            f = &fn1;
        } else {
            f = &fn2;
        }
       (*f)();
    }
}

void fn1() {
    byte* const BORDER_COLOR = (char*)$d020;
    (*BORDER_COLOR)++;
}

void fn2() {
    byte* const BG_COLOR = (char*)$d021;
    (*BG_COLOR)++;
}