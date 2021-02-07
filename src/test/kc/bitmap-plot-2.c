// Tests the simple bitmap plotter - and counts plots per frame in an IRQ
// Plots a spiral
#include <c64.h>
#include <sine.h>
#include <multiply.h>
#include <c64-bitmap.h>

byte* BITMAP = 0x2000;
byte* SCREEN = 0x0400;

byte plots_per_frame[0x100];

__align(0x100) signed word SINE[512];

void main() {
    sin16s_gen2(SINE, 512, -0x1001, 0x1001);
    bitmap_init(BITMAP, SCREEN);
    bitmap_clear(BLACK, WHITE);
    *D011 = VICII_BMM|VICII_DEN|VICII_RSEL|3;
    *D018 = toD018(SCREEN, BITMAP);
    init_irq();
    word idx_x = 0;
    word idx_y = 0x80;
    signed word r = 0;
    byte r_add = 32;
    while(true) {
        signed word cos_x = SINE[idx_x];
        signed dword xpos = mul16s(r, cos_x);
        word x = (word)(160 + ((signed word)>xpos)>>2);
        signed word sin_y = SINE[idx_y];
        signed dword ypos = mul16s(r, sin_y);
        word y = (word)(100 + ((signed word)>ypos)>>2);
        bitmap_plot(x, (byte)y);
        plots_per_frame[frame_cnt]++;
        idx_x += r_add;
        if(idx_x>=512) idx_x = 0;
        idx_y += r_add;
        if(idx_y>=512) idx_y = 0;
        r += r_add;
        if((idx_x==0) && (r_add!=1)) r_add /= 2;
        if(r>=512*12+256) break;
    }
    while(true)
        (*BORDER_COLOR)++;
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
    CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR;
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