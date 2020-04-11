// Tests the simple bitmap plotter - and counts plots per frame in an IRQ
// Plots a fullscreen elipsis
#include <c64.c>
#include <sinus.c>
#include <multiply.c>
#include <bitmap2.c>

byte* BITMAP = 0x2000;
byte* SCREEN = 0x0400;

byte plots_per_frame[0x100];

align(0x100) signed word SINUS[512];

void main() {
    sin16s_gen2(SINUS, 512, -0x1001, 0x1001);
    bitmap_init(BITMAP, SCREEN);
    bitmap_clear(BLACK, WHITE);
    *D011 = VIC_BMM|VIC_DEN|VIC_RSEL|3;
    *D018 = toD018(SCREEN, BITMAP);
    init_irq();
    word idx_x = 0;
    word idx_y = 0x80;
    while(true) {
        signed word cos_x = SINUS[idx_x];
        signed dword xpos = mul16s(160, cos_x);
        word x = (word)(160 + >(xpos<<4));
        signed word sin_y = SINUS[idx_y];
        signed dword ypos = mul16s(100, sin_y);
        word y = (word)(100 + >(ypos<<4));
        bitmap_plot(x, (byte)y);
        if(++idx_x==512) idx_x = 0;
        if(++idx_y==512) idx_y = 0;
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
    *CIA1_INTERRUPT = CIA_INTERRUPT_CLEAR;
    // Set raster line to $100
    *VIC_CONTROL |=$80;
    *RASTER = $00;
    // Enable Raster Interrupt
    *IRQ_ENABLE = IRQ_RASTER;
    // Set the IRQ routine
    *HARDWARE_IRQ = &irq;
    asm { cli }
}

// Interrupt Routine counting frames
interrupt(hardware_clobber) void irq() {
    *BGCOL = WHITE;
    if(frame_cnt) frame_cnt++;
    *BGCOL = BLACK;
    // Acknowledge the IRQ
    *IRQ_STATUS = IRQ_RASTER;
}