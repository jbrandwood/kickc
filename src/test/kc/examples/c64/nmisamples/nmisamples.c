// NMI Sample Player using the SID volume register
// Code by Scan of Desire (Richard-William Loerakker)
// Sample from ART OF NOISE: MOMENTS IN LOVE

#include <c64.h>

const unsigned int SAMPLE_SIZE = 0x6100;
char SAMPLE[SAMPLE_SIZE] = kickasm(resource "moments_sample.bin") {{  .import binary "moments_sample.bin" }};

char* volatile sample = SAMPLE;

void main() {
    // Boosting 8580 Digis
    // See https://gist.github.com/munshkr/30f35e39905e63876ff7 (line 909)
    asm {
				lda #$ff
				sta $d406
				sta $d40d
				sta $d414

				lda #$49
				sta $d404				
				sta $d40b
				sta $d412	    
    }
    asm { sei }
    CIA2->INTERRUPT = CIA_INTERRUPT_CLEAR;
    *KERNEL_NMI = &nmi;
    CIA2->TIMER_A = 0x88; // speed
    CIA2->INTERRUPT = 0x81;
    CIA2->TIMER_A_CONTROL = 0x01;
    asm { cli }
}

__interrupt(hardware_clobber) void nmi() {
    (VICII->BORDER_COLOR)++;
    asm { lda CIA2_INTERRUPT }
    SID->VOLUME_FILTER_MODE = *sample & $0f;
    *KERNEL_NMI = &nmi2;
    (VICII->BORDER_COLOR)--;
}

__interrupt(hardware_clobber) void nmi2() {
    (VICII->BORDER_COLOR)++;
    asm { lda CIA2_INTERRUPT }
    SID->VOLUME_FILTER_MODE = *sample >> 4;
    sample++;
    if (>sample == >(SAMPLE+$6100)) {
        sample = SAMPLE;
    }
    *KERNEL_NMI = &nmi;
    (VICII->BORDER_COLOR)--;
}