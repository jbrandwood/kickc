// A simple SID music player using RASTER IRQ
#include <c64.h>

char* const MUSIC = $1000;

// Load the SID
kickasm(resource "toiletrensdyr.sid") {{
    .const music = LoadSid("toiletrensdyr.sid")
}}

// Place the SID into memory
kickasm(pc MUSIC) {{
    .fill music.size, music.getData(i)
}}


// Setup Raster IRQ and initialize SID player
void main() {
    asm { 
        sei
        jsr music.init
    }
    // Disable CIA 1 Timer IRQ
    CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR;
    // Set raster line to $fd
    VICII->CONTROL1 &=$7f;
    VICII->RASTER = $fd;
    // Enable Raster Interrupt
    VICII->IRQ_ENABLE = IRQ_RASTER;
    // Set the IRQ routine
    *KERNEL_IRQ = &irq_play;
    asm { cli }
}

// Raster IRQ Routine playing music
interrupt(kernel_keyboard) void irq_play() {
    (VICII->BORDER_COLOR)++;
    // Play SID
    asm { jsr music.play }
    // Acknowledge the IRQ
    VICII->IRQ_STATUS = IRQ_RASTER;
    (VICII->BORDER_COLOR)--;
}