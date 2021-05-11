// Pointer to procedure

char * const SCREEN = (char*)0x0400;

void proc1() {
    SCREEN[0] = 'a';
}

void proc2() {
    SCREEN[1] = 'b';
}

void (*proc_ptr)(void);

void main() {
    proc_ptr = &proc1;
    (*proc_ptr)();
    proc_ptr = &proc2;
    (*proc_ptr)();
}

