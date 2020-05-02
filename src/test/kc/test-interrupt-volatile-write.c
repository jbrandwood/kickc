// Tests that volatile variables can be both read & written inside & outside interrupts
// Currently fails because the modification is optimized away

void()** const  KERNEL_IRQ = $0314;
byte* const BG_COLOR = $d020;
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
    *BG_COLOR = col;
    if(col!=0) {
        col++;
    } else {
        col += 2;
    }
}
