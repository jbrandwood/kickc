void()** const  KERNEL_IRQ = $0314;
byte* const BG_COLOR = $d020;
byte* const FGCOL = $d021;

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
