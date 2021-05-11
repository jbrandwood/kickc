// Test a bit of array code from the NES forum
// https://forums.nesdev.com/viewtopic.php?f=2&t=18735

int wow[4] = { (int)0xCAFE, (int)0xBABE, 0x1234, 0x5678};

int foo(unsigned char x, int *y) {
       return wow[x] + *y;
}

void main() {
    int* SCREEN = (int*)0x400;
    int y1 = 0x1234;
    int y2 = 0x1234;
    *SCREEN++ = foo(1, &y1);
    *SCREEN++ = foo(2, &y2);

}