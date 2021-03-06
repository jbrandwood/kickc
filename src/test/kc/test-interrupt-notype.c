typedef void (*IRQ_TYPE)(void);
IRQ_TYPE* const  KERNEL_IRQ = (IRQ_TYPE*)$0314;
byte* const BG_COLOR = (byte*)$d020;
byte* const FGCOL = (byte*)$d021;

void main() {
    *KERNEL_IRQ = &irq;
    while(true) {
        (*FGCOL)++;
    }
}

__interrupt void irq() {
    (*BG_COLOR)++;
    asm {
        lda $dc0d
    }
}
