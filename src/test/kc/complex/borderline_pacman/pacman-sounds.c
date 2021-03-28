// Sound effects for pacman

#include <c64.h>

void pacman_sound_init() {
    // Set master volume
    SID->VOLUME_FILTER_MODE = 0x0f;

    // Channel 1 is Pacman eating sound
    SID->CH1_FREQ = 0;
    SID->CH1_PULSE_WIDTH = 0;
    SID->CH1_CONTROL = 0;
    SID->CH1_ATTACK_DECAY = 0;
    SID->CH1_SUSTAIN_RELEASE = 0xf0;

}

// Pacman eating sound
char PACMAN_CH1_FREQ_HI[] = {0x23, 0x1d, 0x1a, 0x17, 0x15, 0x12, 0x00, 0x00, 0x00, 0x00, 0x00, 0x19, 0x1a, 0x1c, 0x1d, 0x20, 0x23, 0x00, 0x00, 0x00, 0x00, 0x00, }; 
char PACMAN_CH1_CONTROL[] = {0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x00, 0x00, 0x00, 0x00, 0x00, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x00, 0x00, 0x00, 0x00, 0x00, }; 

// Is the pacman eating sound enabled
volatile char pacman_ch1_enabled = 0;
// Index into the eating sound
volatile char pacman_ch1_idx = 0;

void pacman_sound_play() {    
    if(pacman_ch1_enabled) {
        // Play the entire sound - and then reset and disable it
        *SID_CH1_FREQ_HI = PACMAN_CH1_FREQ_HI[pacman_ch1_idx];
        SID->CH1_CONTROL = PACMAN_CH1_CONTROL[pacman_ch1_idx];
        if(++pacman_ch1_idx==sizeof(PACMAN_CH1_FREQ_HI)) {
            pacman_ch1_idx = 0;
            pacman_ch1_enabled = 0;
        }
    }
}
