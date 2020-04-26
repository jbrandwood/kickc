// A minimal working raster IRQ

void()** const  KERNEL_IRQ = $0314;
void()** const  HARDWARE_IRQ = $fffe;
byte* const RASTER = $d012;
byte* const VIC_CONTROL = $d011;
byte* const IRQ_STATUS = $d019;
byte* const IRQ_ENABLE = $d01a;
const byte IRQ_RASTER = %00000001;
const byte IRQ_COLLISION_BG = %00000010;
const byte IRQ_COLLISION_SPRITE = %00000100;
const byte IRQ_LIGHTPEN = %00001000;
byte* const BGCOL = $d020;
byte* const FGCOL = $d021;
const byte WHITE = 1;
const byte BLACK = 0;

byte* const CIA1_INTERRUPT = $dc0d;
const byte CIA_INTERRUPT_CLEAR = $7f;

// Processor port data direction register
byte* const PROCPORT_DDR = $00;
// Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
const byte PROCPORT_DDR_MEMORY_MASK = %00000111;

// Processor Port Register controlling RAM/ROM configuration and the datasette
byte* const PROCPORT = $01;
// RAM in $A000, $E000 I/O in $D000
const byte PROCPORT_RAM_IO          = %00110101;
// RAM in $A000, $E000 CHAR ROM in $D000

void main() {
    asm { sei }
    // Disable kernal & basic
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;
    // Disable CIA 1 Timer IRQ
    CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR;
    // Set raster line to $100
    *VIC_CONTROL |=$80;
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
interrupt(hardware_stack) void irq() {
    *BGCOL = WHITE;
    *BGCOL = BLACK;
    // Acknowledge the IRQ
    *IRQ_STATUS = IRQ_RASTER;
}