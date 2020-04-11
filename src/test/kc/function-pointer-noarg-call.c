// Tests creating, assigning and calling pointers to non-args no-return functions

void fn1() {
    byte* const BORDERCOL = $d020;
    (*BORDERCOL)++;
}

void main() {
    void()* f = &fn1;
    (*f)();
}

