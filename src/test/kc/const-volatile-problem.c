// Demonstrates problem where a pointer with constant value is never assigned - because it is only used in an IRQ
// PLEX_SCREEN_PTR1 is never assigned - while PLEX_SCREEN_PTR2 receives it's value.
// PLEX_SCREEN_PTR2 is saved by only being assigned once - thus is is identified as a constant.
// All assignments for PLEX_SCREEN_PTR1 are optimized away because it is only used in the IRQ.
// A potential fix is https://gitlab.com/camelot/kickc/-/issues/430

// The address of the sprite pointers on the current screen (screen+0x3f8).
char* PLEX_SCREEN_PTR1 = 0x400;
char* PLEX_SCREEN_PTR2 = 0x500;
volatile char idx = 0;

void()** const IRQ = 0x314;

void main() {
    PLEX_SCREEN_PTR1 = 0x400;
    *IRQ = &irq;
}

// Interrupt Routine
interrupt(kernel_keyboard) void irq() {
    PLEX_SCREEN_PTR1[idx]++;
    PLEX_SCREEN_PTR2[idx]++;
    idx++;
}
