typedef void (*IRQ_TYPE)(void);

IRQ_TYPE* const KERNEL_IRQ = (IRQ_TYPE*)$0314;
byte* const BG_COLOR = (byte*)$d020;
volatile byte col = 0;

void main() {
    *KERNEL_IRQ = &irq;
    while(true) {
        col++;
    }
}

__interrupt void irq() {
    asm {
        lda $dc0d
    }
    *BG_COLOR = col;
}
