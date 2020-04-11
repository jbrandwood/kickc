// Illustrates a problem where a volatile bool modified at the end of an IRQ is not stored properly
// because it is assigned to the A register

void()** const  KERNEL_IRQ = $0314;
byte* const RASTER = $d012;
byte* const VIC_CONTROL = $d011;
byte* const IRQ_STATUS = $d019;
byte* const IRQ_ENABLE = $d01a;
const byte IRQ_RASTER = %00000001;
byte* const BGCOL = $d020;

byte* const CIA1_INTERRUPT = $dc0d;
const byte CIA_INTERRUPT_CLEAR = $7f;


void main() {
    asm { sei }
    // Disable CIA 1 Timer IRQ
    *CIA1_INTERRUPT = CIA_INTERRUPT_CLEAR;
    // Set raster line to $0fd
    *VIC_CONTROL &=$7f;
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

interrupt(kernel_min) void irq() {
    (*BGCOL)++;
    *IRQ_STATUS = IRQ_RASTER;
    if (*RASTER>50) {
        framedone = false;
    }
    (*BGCOL)--;
}