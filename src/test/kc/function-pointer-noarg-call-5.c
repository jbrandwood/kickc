// Tests calling into arrays of pointers to non-args no-return functions

void fn1() {
    byte* const BORDER_COLOR = (char*)$d020;
    (*BORDER_COLOR)++;
}

void fn2() {
    byte* const BG_COLOR = (char*)$d021;
    (*BG_COLOR)++;
}

// declare fns as array 2 of pointer to function (void) returning void
void (*fns[2])(void) = { &fn1, &fn2 };

void main() {
    byte i = 0;
    while(true) {
        void (*f)() = fns[++i&1];
        (*f)();
    }
}

