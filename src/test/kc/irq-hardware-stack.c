// A minimal working raster IRQ

#pragma cpu(rom6502x)

typedef void (*IRQ_TYPE)(void);
IRQ_TYPE* const KERNEL_IRQ = (IRQ_TYPE*)$0314;
IRQ_TYPE* const HARDWARE_IRQ = (IRQ_TYPE*)$fffe;
byte* const RASTER = (byte*)$d012;
byte* const VICII_CONTROL1 = (byte*)$d011;
byte* const IRQ_STATUS = (byte*)$d019;
byte* const IRQ_ENABLE = (byte*)$d01a;
const byte IRQ_RASTER = %00000001;
const byte IRQ_COLLISION_BG = %00000010;
const byte IRQ_COLLISION_SPRITE = %00000100;
const byte IRQ_LIGHTPEN = %00001000;
byte* const BG_COLOR = (byte*)$d020;
byte* const FGCOL = (byte*)$d021;
const byte WHITE = 1;
const byte BLACK = 0;

byte* const CIA1_INTERRUPT = (byte*)$dc0d;
const byte CIA_INTERRUPT_CLEAR_ALL = $7f;

// Processor port data direction register
byte* const PROCPORT_DDR = (byte*)$00;
// Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
const byte PROCPORT_DDR_MEMORY_MASK = %00000111;

// Processor Port Register controlling RAM/ROM configuration and the datasette
byte* const PROCPORT = (byte*)$01;
// RAM in $A000, $E000 I/O in $D000
const byte PROCPORT_RAM_IO          = %00110101;
// RAM in $A000, $E000 CHAR ROM in $D000

void main() {
    asm { sei }
    // Disable kernal & basic
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;
    // Disable CIA 1 Timer IRQ
    *CIA1_INTERRUPT = CIA_INTERRUPT_CLEAR_ALL;
    // Set raster line to $100
    *VICII_CONTROL1 |=$80;
    *RASTER = $00;
    // Enable Raster Interrupt
    *IRQ_ENABLE = IRQ_RASTER;
    // Set the IRQ routine
    *HARDWARE_IRQ = &irq;
    asm { cli }
    while(true) {
        (*FGCOL)++;
    }
}

// Interrupt Routine
__interrupt(hardware_all) void irq() {
    *BG_COLOR = WHITE;
    *BG_COLOR = BLACK;
    // Acknowledge the IRQ
    *IRQ_STATUS = IRQ_RASTER;
}