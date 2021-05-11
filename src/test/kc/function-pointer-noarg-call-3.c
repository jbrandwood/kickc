// Tests creating, assigning returning and calling pointers to non-args no-return functions

void main() {
    byte i = 0;
    while(true) {
        (*getfn(++i))();
    }
}

// declare getfn as function (char b) returning pointer to function (void) returning void
void (*getfn(char b))(void) {
    if((b&1)==0) {
        return &fn1;
    } else {
        return &fn2;
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