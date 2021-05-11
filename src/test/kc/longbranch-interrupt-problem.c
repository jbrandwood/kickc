// Tests that long branch fixing works with interrupt exits (to $ea81)

typedef void (*IRQ_TYPE)(void);
IRQ_TYPE*  KERNEL_IRQ = (IRQ_TYPE*)$0314;
byte* const BG_COLOR = (byte*)$d020;
volatile byte col = 0;

void main() {
    *KERNEL_IRQ = &irq;
    while(true) {
        if(col>10) {
            col = 0;
        }
    }
}

__interrupt void irq() {
    asm {
        lda $dc0d
    }
    *BG_COLOR = col;
    if(col!=0) {
        col++;
    }
}
