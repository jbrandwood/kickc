// Demonstrates const pointer to pointer

void ** const IRQ = (void **)0xfffe;

void main() {
    *IRQ = (void*) 0x1003;
}