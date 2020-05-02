// Tests creating, assigning returning and calling pointers to non-args no-return functions

void main() {
    byte i = 0;
    while(true) {
        (*getfn(++i))();
    }
}

void()* getfn(byte b) {
    return &fn1;
}

void fn1() {
    byte* const BORDER_COLOR = $d020;
    (*BORDER_COLOR)++;
}

