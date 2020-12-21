// Illustrates problem where volatiles reuse ZP addresses of other variables
void()** const  KERNEL_IRQ = $0314;
byte* const IRQ_STATUS = $d019;
byte* const CIA1_INTERRUPT = $dc0d;

byte* const SCREEN=$400;
volatile byte col1 = 0;

void main() {
    *KERNEL_IRQ = &irq;
    while(true) {
        for(byte x: 0..10) {
            for(byte y: 0..10) {
                for (byte a:0..10) {
                    SCREEN[x] = a+y;
                }
            }
        }
    }
}

__interrupt void irq() {
    // Acknowledge the IRQ
    *IRQ_STATUS = 1;
    asm { lda $dc0d }
    SCREEN[40] = col1++;
}
