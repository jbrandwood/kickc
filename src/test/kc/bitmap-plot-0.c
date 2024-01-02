// Tests the simple bitmap plotter - and counts plots per frame in an IRQ
// Plots simple plots
#include <c64.h>
#include <c64-bitmap.h>

byte* BITMAP = (byte*)0x2000;
byte* SCREEN = (byte*)0x0400;

byte plots_per_frame[0x100];

void main() {
    bitmap_init(BITMAP, SCREEN);
    bitmap_clear(BLACK, WHITE);
    *D011 = VICII_BMM|VICII_DEN|VICII_RSEL|3;
    *D018 = toD018(SCREEN, BITMAP);
    init_irq();
    word x = 0;
    byte y = 0;
    word vx = 1;
    byte vy = 1;
    while(true) {
        bitmap_plot(x, y);
        x += vx;
        y += vy;
        if(x==319 || x==0) vx = -vx;
        if(y==199 || y==0) vy = -vy;
        plots_per_frame[frame_cnt]++;
    }
}

// Counts frames - updated by the IRQ
volatile byte frame_cnt = 1;

// Setup the IRQ
void init_irq() {
    asm { sei }
    // Disable kernal & basic
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;
    // Disable CIA 1 Timer IRQ
    CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR_ALL;
    // Set raster line to $100
    *VICII_CONTROL1 |=$80;
    *RASTER = $00;
    // Enable Raster Interrupt
    *IRQ_ENABLE = IRQ_RASTER;
    // Set the IRQ routine
    *HARDWARE_IRQ = &irq;
    asm { cli }
}

// Interrupt Routine counting frames
__interrupt(hardware_clobber) void irq() {
    *BG_COLOR = WHITE;
    if(frame_cnt) frame_cnt++;
    *BG_COLOR = BLACK;
    // Acknowledge the IRQ
    *IRQ_STATUS = IRQ_RASTER;
}