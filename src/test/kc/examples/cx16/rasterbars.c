// Example program for the Commander X16
// Displays raster bars in the border

#pragma target(cx16)
#include <cx16.h>
#include <6502.h>
#include <string.h>

__align(0x100) char SIN[256] = kickasm {{
    .fill 256, 99+99*sin(i*2*PI/256)
}};

__align(0x100) char BARS[230];

__align(0x100) char BAR[32] = {
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
    0x1f, 0x1e, 0x1d, 0x1c, 0x1b, 0x1a, 0x19, 0x18, 0x17, 0x16, 0x15, 0x14, 0x13, 0x12, 0x11, 0x10,
};

void main() {
    // Enable LINE IRQ (also set line bit 8 to 0)
    SEI();
    *KERNEL_IRQ = &irq_line;
    *VERA_IEN = VERA_LINE; 
    *VERA_IRQLINE_L = 5;
    CLI();
    // Wait forever
    for(;;) ;
}

// The horizontal start
volatile char hstart = 0/4;
// The horizontal stop
volatile char hstop = 640/4;
// The vertical start
volatile char vstart = 0/2;
// The vertical stop
volatile char vstop = 480/2;
// The countdown
volatile char cnt = 2;
// The sin idx
volatile char sin_idx = 100;

// LINE Interrupt Routine
__interrupt void irq_line() {
    // Update the border
    *VERA_CTRL |= VERA_DCSEL;
    *VERA_DC_HSTART = hstart;
    *VERA_DC_HSTOP = hstop;
    *VERA_DC_VSTART = vstart;
    *VERA_DC_VSTOP = vstop;

    // Show color raster bars in the border
    *VERA_CTRL &= ~VERA_DCSEL;
    for(char l=0;l!=230;l++) {
        *VERA_DC_BORDER = BARS[l];
        for(char i=0;i<24;i++) ; // Wait exactly long enought to go to the next raster line
        *VERA_DC_BORDER = 0; 
        for(char i=0;i<23;i++) ; // Wait exactly long enought to go to the next raster line
        asm { nop nop }
    }

    // Animate the border
    if(--cnt==0) {
        cnt = 2;
        if(hstart<=320/4) {
            hstart++;
            hstop--;
            vstart++;
            vstop--;
        }
    }

    // Animate the bars
    memset(BARS, 0, sizeof(BARS));
    char idx = sin_idx--;
    for(char b=0;b<8;b++) {
        char * bar = BARS + SIN[idx];
        for(char i=0;i<sizeof(BAR);i++) {
            bar[i] = BAR[i];
        }
        idx += 13;
    }

    // Reset the LINE interrupt
    *VERA_ISR = VERA_LINE;
}