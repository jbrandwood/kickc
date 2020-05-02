// Tests creating, assigning and calling pointers to non-args no-return functions

void fn1() {
    byte* const BORDER_COLOR = $d020;
    (*BORDER_COLOR)++;
}

void main() {
    void()* f = &fn1;
    (*f)();
}

