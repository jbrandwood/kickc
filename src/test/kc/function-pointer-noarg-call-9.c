// Tests calling into a function pointer which modifies global volatile

byte* const SCREEN = $0400;

volatile byte idx = 0;

void fn1() {
    idx++;
}

void main() {
    void()* f = &fn1;
    (*f)();
    SCREEN[idx] = 'a';
    (*f)();
    SCREEN[idx] = 'a';
}


