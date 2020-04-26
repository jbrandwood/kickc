// Test interrupt routine using a variable between calls (irq_idx)
#include <c64.h>

byte* const SCREEN  = $0400;

void main() {
    asm { sei }
    // Disable CIA 1 Timer IRQ
    CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR;
    // Set raster line to $60
    *VIC_CONTROL &=$7f;
    *RASTER = $60;
    // Enable Raster Interrupt
    *IRQ_ENABLE = IRQ_RASTER;
    // Acknowledge any IRQ
    *IRQ_STATUS = IRQ_RASTER;
    // Setup the table driven IRQ routine
    *KERNEL_IRQ = &table_driven_irq;
    asm { cli }
}

byte * const VIC_BASE = $D000;
const byte VIC_SIZE = 48;
const byte IRQ_CHANGE_NEXT = $7f;

byte IRQ_CHANGE_IDX[] = { $20, $21, IRQ_CHANGE_NEXT, $20, $21, IRQ_CHANGE_NEXT, $20, $21, IRQ_CHANGE_NEXT, $20, $21, IRQ_CHANGE_NEXT };
byte IRQ_CHANGE_VAL[] = { $0b, $0b,             $63, $00, $00,             $80, $07, $07,             $83, $00, $00,             $60 };

volatile byte irq_idx = 0;

interrupt(kernel_min) void table_driven_irq() {
    do {
        byte idx = IRQ_CHANGE_IDX[irq_idx];
        byte val = IRQ_CHANGE_VAL[irq_idx];
        irq_idx++;
        if (idx < VIC_SIZE) {
            VIC_BASE[idx] = val;
        } else if (idx < VIC_SIZE + 8) {
            SCREEN[idx + $3f8 - VIC_SIZE] = val;
        } else {
            *IRQ_STATUS = IRQ_RASTER;
            *RASTER = val;
            if (val < *RASTER)
                irq_idx = 0;
            return;
        }
    } while (true);
}