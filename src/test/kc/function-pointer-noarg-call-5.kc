// Tests calling into arrays of pointers to non-args no-return functions

void fn1() {
    byte* const BORDERCOL = $d020;
    (*BORDERCOL)++;
}

void fn2() {
    byte* const BGCOL = $d021;
    (*BGCOL)++;
}

void()* fns[2] = { &fn1, &fn2 };

void main() {
    byte i = 0;
    while(true) {
        void()* f = fns[++i&1];
        (*f)();
    }
}

