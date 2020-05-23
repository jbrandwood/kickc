// Nintendo Entertainment System (NES
// https://en.wikipedia.org/wiki/Nintendo_Entertainment_System_(Model_NES-101)
// https://github.com/gregkrsak/first_nes
#include <nes.h>

// Disable audio output
inline void disableAudioOutput() {
    // Disable APU frame IRQ
    *FR_COUNTER = 0b01000000;
    // Disable digital sound IRQs
    APU->DMC_FREQ  = 0b01000000;
}

// Disable video output. This will cause a black screen and disable vblank.
inline void disableVideoOutput() {
    // Disable vertical blank interrupt
    PPU->PPUCTRL = 0;
    // Disable sprite rendering
    PPU->PPUMASK = 0;
}

// Enable video output. This will enable vblank.
inline void enableVideoOutput() {
    // Enable vertical blank interrupt
    PPU->PPUCTRL = 0b10000000;
    // Enable sprite rendering
    PPU->PPUMASK = 0b00010000;
}

// Wait for vblank to start
inline void waitForVBlank() {
    while(!(PPU->PPUSTATUS&0x80)) { }
}

// Clear the vblank flag
inline void clearVBlankFlag() {
    asm { lda PPU_PPUSTATUS }
}
