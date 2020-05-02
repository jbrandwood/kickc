void()** const  KERNEL_IRQ = $0314;
byte* const BG_COLOR = $d020;
volatile byte col = 0;

void main() {
    *KERNEL_IRQ = &irq;
    while(true) {
        col++;
    }
}

interrupt(kernel_min) void irq() {
    asm {
        lda $dc0d
    }
    *BG_COLOR = col;
}
