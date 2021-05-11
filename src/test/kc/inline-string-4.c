// Test casting the address of an inline string to a dword.

void main() {
    const char msg[] = "camelot";
    unsigned long dw = (unsigned long)msg;
    output(dw);
}

unsigned long* const screen = (char*)0x0400;

void output(unsigned long dw) {
    *screen = dw;
}