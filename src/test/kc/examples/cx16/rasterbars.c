// Example program for the Commander X16
// Displays raster bars in the border

#pragma target(cx16) 
#include <cx16.h>
#include <6502.h>

align(0x100)char BARS[] = { 

    0x10, 0, 0x11, 0, 0x12, 0, 0x13, 0,  
    0x14, 0, 0x15, 0, 0x16, 0, 0x17, 0,  
    0x18, 0, 0x19, 0, 0x1a, 0, 0x1b, 0,  
    0x1c, 0, 0x1d, 0, 0x1e, 0, 0x1f, 0,  
    0x1f, 0, 0x1e, 0, 0x1d, 0, 0x1c, 0,  
    0x1b, 0, 0x1a, 0, 0x19, 0, 0x18, 0,  
    0x17, 0, 0x16, 0, 0x15, 0, 0x14, 0,  
    0x13, 0, 0x12, 0, 0x11, 0, 0x10, 0,  

    0x10, 0, 0x11, 0, 0x12, 0, 0x13, 0,  
    0x14, 0, 0x15, 0, 0x16, 0, 0x17, 0,  
    0x18, 0, 0x19, 0, 0x1a, 0, 0x1b, 0,  
    0x1c, 0, 0x1d, 0, 0x1e, 0, 0x1f, 0,  
    0x1f, 0, 0x1e, 0, 0x1d, 0, 0x1c, 0,  
    0x1b, 0, 0x1a, 0, 0x19, 0, 0x18, 0,  
    0x17, 0, 0x16, 0, 0x15, 0, 0x14, 0,  
    0x13, 0, 0x12, 0, 0x11, 0, 0x10, 0,  

    0x10, 0, 0x11, 0, 0x12, 0, 0x13, 0,  
    0x14, 0, 0x15, 0, 0x16, 0, 0x17, 0,  
    0x18, 0, 0x19, 0, 0x1a, 0, 0x1b, 0,  
    0x1c, 0, 0x1d, 0, 0x1e, 0, 0x1f, 0,  
    0x1f, 0, 0x1e, 0, 0x1d, 0, 0x1c, 0,  
    0x1b, 0, 0x1a, 0, 0x19, 0, 0x18, 0,  
    0x17, 0, 0x16, 0, 0x15, 0, 0x14, 0,  
    0x13, 0, 0x12, 0, 0x11, 0, 0x10, 0,  

    0x10, 0, 0x11, 0, 0x12, 0, 0x13, 0,  
    0x14, 0, 0x15, 0, 0x16, 0, 0x17, 0,  
    0x18, 0, 0x19, 0, 0x1a, 0, 0x1b, 0,  
    0x1c, 0, 0x1d, 0, 0x1e, 0, 0x1f, 0,  
    0x1f, 0, 0x1e, 0, 0x1d, 0, 0x1c, 0,  
    0x1b, 0, 0x1a, 0, 0x19, 0, 0x18, 0,  
    0x17, 0, 0x16, 0, 0x15, 0, 0x14, 0,  
    0x13, 0, 0x12, 0, 0x11, 0, 0x10, 0,  

};

void main() {
    // Enable LINE IRQ (also set line bit 8 to 0)
    SEI();
    *KERNEL_IRQ = &irq_zero;
    *VERA_IEN = VERA_LINE; 
    *VERA_IRQLINE_L = 0;
    CLI();
    // Wait forever
    for(;;) ;
}

// The horizontal start
volatile char hstart = 0/4;
// The horizontal stop
volatile char hstop = 640/4;
// The countdown
volatile char cnt = 2;

// Interrupt Routine at raster 0
void irq_zero() {
    // Update the border
    *VERA_CTRL |= VERA_DCSEL;
    *VERA_DC_HSTART = hstart;
    *VERA_DC_HSTOP = hstop;

    // Show color raster bars in the border
    *VERA_CTRL &= ~VERA_DCSEL;
    for(char l=0;l!=255;l++) {
        *VERA_DC_BORDER = BARS[l];
        for(char i=0;i<23;i++) ;
    }
    *VERA_DC_BORDER = 0;
    *VERA_CTRL |= VERA_DCSEL;

    // Animate the border
    if(--cnt==0) {
        cnt = 2;
        if(hstart<=320/4) {
            hstart++;
            hstop--;
        }
    }

    // Reset the LINE interrupt
    *VERA_ISR = VERA_LINE;
    // Exit CX16 KERNAL IRQ
    asm {
        // soft exit (keep kernal running)
        // jmp $e034 
        // hard exit (no kernal activity)
        ply
        plx
        pla
        rti        
    }

}