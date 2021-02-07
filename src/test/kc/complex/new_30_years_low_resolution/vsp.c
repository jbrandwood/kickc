// C-based implementation of VSP "Vertical Screen Position" effect - scrolling the screen
// https://bumbershootsoft.wordpress.com/2015/04/19/variable-screen-placement-the-vic-iis-forbidden-technique/
// http://www.zimmers.net/cbmpics/cbm/c64/vic-ii.txt (Section 3.14.6. DMA delay)
//
// To utilize this create a hardware IRQ at raster line 0x2d and as the very first thing call vsp_perform().
// The variable vsp_scroll controls the VSP scroll value.

#include <c64.h>
#include "vsp.h"

// The number of chars to scroll the screen by VSP. 
// Legal values are 0-40.
//  0 shows the normal screen (no scrolling)
// 20 shows char #20 in the top left corner of the screen, effectively scrolling the screen left 20 chars.
volatile __zp char vsp_scroll = 0;

// Perform VSP scrolling of the screen
// This only works if it is called as the very first thing in a HARDWARE IRQ scheduled on raster line 0x02d.
// It will stabilize the raster (using the double IRQ method) and modify $D011 to scroll the screen according to the value in vsp_scroll
// Any sprites on lines 0x2d-0x2f will interfere and prevent the effect from working.
// After execution it is necessary to
// - Acknowledge the raster IRQ 
// - Set the raster IRQ to occur on line 0x2d (since this modifies the IRQ line)
// - Set the hardware IRQ vector (since this modifies the hardware IRQ vector)
void inline vsp_perform() {
    kickasm(uses vsp_scroll, uses HARDWARE_IRQ, uses RASTER, uses IRQ_STATUS, uses IRQ_RASTER, uses VICII_CONTROL1, clobbers "AX") {{
        // Stabilize the raster by using the double IRQ method
        // Acknowledge the IRQ
        lda #IRQ_RASTER
        sta IRQ_STATUS
        // Set-up IRQ for the next line
        inc RASTER
        // Point IRQ to almost stable code
        lda #<stable
        sta HARDWARE_IRQ
        lda #>stable
        sta HARDWARE_IRQ+1
        tsx       // Save stack pointer
        cli       // Reenable interrupts
        // Wait for new IRQ using NOP's to ensure minimal jitter when it hits
        .fill 15, NOP
        .align $100
    stable:
        txs             // Restore stack pointer
        ldx #9          // Wait till the raster has almost crossed to the next line (48 cycles)
        !: dex
        bne !-
        nop
        lda RASTER
        cmp RASTER
        bne !+          // And correct the last cycle of potential jitter
        !:
        // Raster is now completely stable! (Line $2f cycle 7)
        // Perform VSP by waiting an exact number of cycles and then enabling the display
        // See http://www.zimmers.net/cbmpics/cbm/c64/vic-ii.txt (Section 3.14.6. DMA delay)
        ldx #8          // Wait 45 cycles to get the VSP timing right
        !: dex
        bne !-
        nop
        nop
        lda vsp_scroll
        lsr         //  Put bit 0 into carry 
        bcc dma1    // Spend 2 or 3 cycles depending on the carry (bit 0)
    dma1:
        sta dma2+1  // Update the branch
        clv
    dma2:
        bvc dma2    // This branch is updated with vsp_scroll/2 - changing the number of NOP's executed
        // 20 NOP's - enabling vsp scroll from 0-40
        .fill 20, NOP
        ldx #$18
        lda #$1b  // TODO: To control Y-scrolling this must be flexible!
        // The STX $d011 must be line $30 cycle $10 for vsp_scroll==0
        stx VICII_CONTROL1 // Enable the display - starts DMA
        sta VICII_CONTROL1
    }}
}
