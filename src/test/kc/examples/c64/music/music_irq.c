// A simple SID music player using RASTER IRQ
#include <c64.h>

// SID tune at an absolute address
__address(0x1000) char MUSIC[] = kickasm(resource "toiletrensdyr.sid") {{
    .const music = LoadSid("toiletrensdyr.sid")
    .fill music.size, music.getData(i)
}};
// Pointer to the music init routine
void()* musicInit = (void()*) MUSIC;
// Pointer to the music play routine
void()* musicPlay = (void()*) MUSIC+3;

// Setup Raster IRQ and initialize SID player
void main() {
    asm { sei }
    (*musicInit)();
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
__interrupt(rom_sys_c64) void irq_play() {
    (VICII->BORDER_COLOR)++;
    // Play SID
    (*musicPlay)();
    // Acknowledge the IRQ
    VICII->IRQ_STATUS = IRQ_RASTER;
    (VICII->BORDER_COLOR)--;
}