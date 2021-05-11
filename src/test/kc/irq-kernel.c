// A minimal working raster IRQ

typedef void (*IRQ_TYPE)(void);
IRQ_TYPE* const KERNEL_IRQ = (IRQ_TYPE*)$0314;
byte* const RASTER = (byte*)$d012;
byte* const VICII_CONTROL1 = (byte*)$d011;
byte* const IRQ_STATUS = (byte*)$d019;
byte* const IRQ_ENABLE = (byte*)$d01a;
const byte IRQ_RASTER = %00000001;
const byte IRQ_COLLISION_BG = %00000010;
const byte IRQ_COLLISION_SPRITE = %00000100;
const byte IRQ_LIGHTPEN = %00001000;
byte* const BG_COLOR = (byte*)$d020;
const byte WHITE = 1;
const byte BLACK = 0;

byte* const CIA1_INTERRUPT = (byte*)$dc0d;
const byte CIA_INTERRUPT_CLEAR = $7f;

void main() {
    asm { sei }
    // Disable CIA 1 Timer IRQ
    *CIA1_INTERRUPT = CIA_INTERRUPT_CLEAR;
    // Set raster line to $100
    *VICII_CONTROL1 |=$80;
    *RASTER = $00;
    // Enable Raster Interrupt
    *IRQ_ENABLE = IRQ_RASTER;
    // Set the IRQ routine
    *KERNEL_IRQ = &irq;
    asm { cli }
}

// Interrupt Routine
__interrupt(rom_sys_c64) void irq() {
    *BG_COLOR = WHITE;
    *BG_COLOR = BLACK;
    // Acknowledge the IRQ
    *IRQ_STATUS = IRQ_RASTER;
}