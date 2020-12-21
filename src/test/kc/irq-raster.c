// A minimal working raster IRQ

void()** const  KERNEL_IRQ = $0314;
byte* const RASTER = $d012;
byte* const VIC_CONTROL = $d011;
byte* const IRQ_STATUS = $d019;
byte* const IRQ_ENABLE = $d01a;
const byte IRQ_RASTER = %00000001;
const byte IRQ_COLLISION_BG = %00000010;
const byte IRQ_COLLISION_SPRITE = %00000100;
const byte IRQ_LIGHTPEN = %00001000;
byte* const BG_COLOR = $d020;
const byte WHITE = 1;
const byte BLACK = 0;

byte* const CIA1_INTERRUPT = $dc0d;
const byte CIA_INTERRUPT_CLEAR = $7f;

void main() {
    asm { sei }
    // Disable CIA 1 Timer IRQ
    *CIA1_INTERRUPT = CIA_INTERRUPT_CLEAR;
    // Set raster line to $100
    *VIC_CONTROL |=$80;
    *RASTER = $00;
    // Enable Raster Interrupt
    *IRQ_ENABLE = IRQ_RASTER;
    // Set the IRQ routine
    *KERNEL_IRQ = &irq;
    asm { cli }
}

// Interrupt Routine
__interrupt void irq() {
    *BG_COLOR = WHITE;
    *BG_COLOR = BLACK;
    // Acknowledge the IRQ
    *IRQ_STATUS = IRQ_RASTER;
}