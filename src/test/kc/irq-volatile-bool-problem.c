// Illustrates a problem where a volatile bool modified at the end of an IRQ is not stored properly
// because it is assigned to the A register

typedef void (*IRQ_TYPE)(void);
IRQ_TYPE* const  KERNEL_IRQ = (IRQ_TYPE*)$0314;
byte* const RASTER = (byte*)$d012;
byte* const VICII_CONTROL1 = (byte*)$d011;
byte* const IRQ_STATUS = (byte*)$d019;
byte* const IRQ_ENABLE = (byte*)$d01a;
const byte IRQ_RASTER = %00000001;
byte* const BG_COLOR = (byte*)$d020;

byte* const CIA1_INTERRUPT = (byte*)$dc0d;
const byte CIA_INTERRUPT_CLEAR_ALL = $7f;


void main() {
    asm { sei }
    // Disable CIA 1 Timer IRQ
    *CIA1_INTERRUPT = CIA_INTERRUPT_CLEAR_ALL;
    // Set raster line to $0fd
    *VICII_CONTROL1 &=$7f;
    *RASTER = $fd;
    // Enable Raster Interrupt
    *IRQ_ENABLE = IRQ_RASTER;
    // Set the IRQ routine
    *KERNEL_IRQ = &irq;
    asm { cli }
    while(true) {
        if(*RASTER<20)
            framedone = true;
    }
}

volatile bool framedone = false;

__interrupt void irq() {
    (*BG_COLOR)++;
    *IRQ_STATUS = IRQ_RASTER;
    if (*RASTER>50) {
        framedone = false;
    }
    (*BG_COLOR)--;
}