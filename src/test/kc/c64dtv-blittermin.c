#include <c64dtv.c>

byte* const SCREEN = $400;
const byte SRCA[] = { 'c', 'a', 'm', 'e', 'l', 'o', 't', '!', ' '};
const byte SRCA_LEN = 9;
const byte SRCB[] = { $80 };

void main() {

    *DTV_FEATURE = DTV_FEATURE_ENABLE;

    // Instruct blitter not to continue previous blit
    *DTV_BLITTER_CONTROL2 = DTV_BLIT_CLEAR_IRQ;

    *DTV_BLITTER_SRCA_LO = <SRCA;
    *DTV_BLITTER_SRCA_MI = >SRCA;
    *DTV_BLITTER_SRCA_HI = 0;
    *DTV_BLITTER_SRCA_MOD_LO = 0;
    *DTV_BLITTER_SRCA_MOD_HI = 0;
    *DTV_BLITTER_SRCA_LIN_LO = <$100uw;
    *DTV_BLITTER_SRCA_LIN_HI = >$100uw;
    *DTV_BLITTER_SRCA_STEP = $10; // Step 1.0

    *DTV_BLITTER_SRCB_LO = <SRCB;
    *DTV_BLITTER_SRCB_MI = >SRCB;
    *DTV_BLITTER_SRCB_HI = 0;
    *DTV_BLITTER_SRCB_MOD_LO = 0;
    *DTV_BLITTER_SRCB_MOD_HI = 0;
    *DTV_BLITTER_SRCB_LIN_LO = <$100uw;
    *DTV_BLITTER_SRCB_LIN_HI = >$100uw;
    *DTV_BLITTER_SRCB_STEP = $00; // Step 0.0

    *DTV_BLITTER_DEST_LO = <SCREEN;
    *DTV_BLITTER_DEST_MI = >SCREEN;
    *DTV_BLITTER_DEST_HI = 0;
    *DTV_BLITTER_DEST_MOD_LO = 0;
    *DTV_BLITTER_DEST_MOD_HI = 0;
    *DTV_BLITTER_DEST_LIN_LO = <$100uw;
    *DTV_BLITTER_DEST_LIN_HI = >$100uw;
    *DTV_BLITTER_DEST_STEP = $10; // Step 1.0

    *DTV_BLITTER_LEN_LO = SRCA_LEN;
    *DTV_BLITTER_LEN_HI = 0;

    *DTV_BLITTER_ALU = DTV_BLIT_ADD;
    *DTV_BLITTER_TRANSPARANCY = DTV_BLIT_TRANSPARANCY_NONE;

    // Start blitter
    *DTV_BLITTER_CONTROL = DTV_BLIT_FORCE_START | DTV_BLIT_SRCA_FWD | DTV_BLIT_SRCB_FWD| DTV_BLIT_DEST_FWD;
    // Instruct blitter to continue at DEST and restart SRC A/B
    *DTV_BLITTER_CONTROL2 = DTV_BLIT_DEST_CONT;

    // Start a 8 more times when ready
    for( byte r: 0..7 ) {
        // wait til blitter is ready
        do {} while((*DTV_BLITTER_CONTROL2 & DTV_BLIT_STATUS_BUSY)!=0);
        // restart
        *DTV_BLITTER_CONTROL = DTV_BLIT_FORCE_START | DTV_BLIT_SRCA_FWD | DTV_BLIT_SRCB_FWD| DTV_BLIT_DEST_FWD;
     }


}