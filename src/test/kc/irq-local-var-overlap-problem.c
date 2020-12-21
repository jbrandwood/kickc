// Illustrates a problem where local variables inside an IRQ are assigned the same zeropage as a variable outside the IRQ

void()** const  KERNEL_IRQ = $0314;
byte* const RASTER = $d012;
byte* const VIC_CONTROL = $d011;
byte* const IRQ_STATUS = $d019;
byte* const IRQ_ENABLE = $d01a;
const byte IRQ_RASTER = %00000001;
byte* const BG_COLOR = $d020;
byte* const FGCOL = $d021;

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
        for( byte i: 0..10 )
            for( byte j: 0..10 )
                for( byte k: 0..10 ) {
                    *FGCOL = i+j+k;
                    sub_main();
                }
    }
}

__interrupt void irq() {
    (*BG_COLOR)++;
    for( byte i: 0..10 )
        for( byte j: 0..10 )
            for( byte k: 0..10 ) {
                *FGCOL = i+j+k;
                sub_irq();
            }
    *IRQ_STATUS = IRQ_RASTER;
    (*BG_COLOR)--;
}

void sub_main() {
    for( byte i: 0..10 )
        for( byte j: 0..10 )
            for( byte k: 0..10 )
                *BG_COLOR = i+j+k;
}

void sub_irq() {
    for( byte i: 0..10 )
        for( byte j: 0..10 )
            for( byte k: 0..10 )
                *BG_COLOR = i+j+k;
}