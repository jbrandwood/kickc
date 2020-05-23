// Nintendo Entertainment System (NES
// https://en.wikipedia.org/wiki/Nintendo_Entertainment_System_(Model_NES-101)
// https://github.com/gregkrsak/first_nes
#include <ricoh_2c02.h>
#include <ricoh_2a03.h>

// NES Picture Processing Unit (PPU)
struct RICOH_2C02 * PPU = 0x2000;

// NES CPU and audion processing unit (APU)
struct RICOH_2A03 * APU = 0x4000;

// Pointer to the start of RAM memory
char * const MEMORY = 0;

// Disable audio output
void disableAudioOutput();

// Disable video output. This will cause a black screen and disable vblank.
void disableVideoOutput();

// Enable video output. This will enable vblank.
void enableVideoOutput();

// Wait for vblank to start
void waitForVBlank();

// Clear the vblank flag
void clearVBlankFlag();
