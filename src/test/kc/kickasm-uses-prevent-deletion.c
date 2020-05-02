// Ensure that an inline kickasm uses-clause is anough to prevent a function from being deleted

// The vector used when the KERNAL serves IRQ interrupts
void()** const  KERNEL_IRQ = $0314;
byte* const BG_COLOR = $d021;
const byte BLACK = $0;
const byte WHITE = $1;


void main() {
    kickasm(uses irq, uses KERNEL_IRQ) {{
        sei
        lda #<irq;
        sta KERNEL_IRQ
        lda #>irq;
        sta KERNEL_IRQ+1
        cli
    }}
}


// The Interrupt Handler
interrupt(kernel_keyboard) void irq() {
    *BG_COLOR = WHITE;
    *BG_COLOR = BLACK;
}


