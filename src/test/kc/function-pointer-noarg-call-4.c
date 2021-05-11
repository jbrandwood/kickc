// Tests creating, assigning returning and calling pointers to non-args no-return functions

void main() {
    byte i = 0;
    while(true) {
        (*getfn(++i))();
    }
}

// declare getfn as function (char b) returning pointer to function (void) returning void
void (*getfn(char b))(void) {
    return &fn1;
}

void fn1() {
    byte* const BORDER_COLOR = (char*)$d020;
    (*BORDER_COLOR)++;
}

