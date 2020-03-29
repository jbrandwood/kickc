// Tests that long branch fixing works with interrupt exits (to $ea81)

void()** const  KERNEL_IRQ = $0314;
byte* const BGCOL = $d020;
volatile byte col = 0;

void main() {
    *KERNEL_IRQ = &irq;
    while(true) {
        if(col>10) {
            col = 0;
        }
    }
}

interrupt(kernel_min) void irq() {
    asm {
        lda $dc0d
    }
    *BGCOL = col;
    if(col!=0) {
        col++;
    }
}
