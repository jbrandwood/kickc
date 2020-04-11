void()** const  KERNEL_IRQ = $0314;
byte* const BGCOL = $d020;
byte* const FGCOL = $d021;

void main() {
    *KERNEL_IRQ = &irq;
    while(true) {
        (*FGCOL)++;
    }
}

interrupt(kernel_min) void irq() {
    (*BGCOL)++;
    asm {
        lda $dc0d
    }
}
