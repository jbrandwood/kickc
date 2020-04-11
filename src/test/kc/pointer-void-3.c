// Test void pointer - issues when assigning returns from malloc()


byte* const SCREEN = 0x0400;

void main() {
    byte* buf1 = malloc();
    byte* buf2 = malloc();
    *buf1 = 'a';
    *buf2 = 'b';
    SCREEN[0] = *buf1;
    SCREEN[1] = *buf2;
}


byte* heap_head = 0xc000;

void* malloc() {
    heap_head++;
    return heap_head;
}