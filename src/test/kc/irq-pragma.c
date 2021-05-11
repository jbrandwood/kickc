// A minimal working IRQ with #pragma defining the type

#pragma interrupt(rom_sys_c64)

// The vector used when the KERNAL serves IRQ interrupts

typedef void (*IRQ_TYPE)(void);
IRQ_TYPE* const KERNEL_IRQ = (IRQ_TYPE*)0x0314;
char*  const BG_COLOR = (char*)0xd021;


// Setup the IRQ routine
void main() {
    asm { sei }
    *KERNEL_IRQ = &irq;
    asm { cli }
}

// The Interrupt Handler
__interrupt void irq() {
    *BG_COLOR = 1;
    *BG_COLOR = 0;
}