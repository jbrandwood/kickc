// Commodore 64 Registers and Constants
#include <c64.h>

// Get the value to store into D018 to display a specific screen and charset/bitmap
// Optimized for ASM from (char)((((unsigned int)screen&$3fff)/$40)|(((unsigned int)charset&$3fff)/$400));
inline char toD018(char*  screen, char*  gfx) {
    return BYTE1(((unsigned int)screen&$3fff)*4)|(((BYTE1((unsigned int)gfx))/4)&$f);
}

// Get the value to store into DD00 (CIA 2 port A) to choose a specific VIC bank
// Optimized for ASM from %00000011 ^ (char)((unsigned int)gfx/$4000)
inline char toDd00(char*  gfx) {
    return %00000011 ^ (BYTE1((unsigned int)gfx))/$40;
}

// Get the sprite pointer for a sprite.
// The sprite pointer is the index of the sprite within the graphics bank and equal to the sprite (char)(sprite_addr/64)
// The sprite pointers are stored SCREEN+$3f8+sprite_id to set the pointer of each sprite
inline char toSpritePtr(char*  sprite) {
	return (char)(((unsigned int)sprite)/$40);
}

// Select a specific VIC graphics bank by setting the CIA 2 port A ($dd00) as needed
inline void vicSelectGfxBank(char*  gfx) {
    CIA2->PORT_A_DDR = %00000011;
    CIA2->PORT_A = toDd00(gfx);
}

// Initialize SID voice 3 for random number generation
inline void sid_rnd_init() {
	SID->CH3_FREQ = 0xffff;
	SID->CH3_CONTROL = SID_CONTROL_NOISE;
}

// Get a random number from the SID voice 3,
// Must be initialized with sid_rnd_init()
inline char sid_rnd() {
	return SID->CH3_OSC;
}

