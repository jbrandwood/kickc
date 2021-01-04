// C-based implementation of VSP "Vertical Screen Position" effect - scrolling the screen
// https://bumbershootsoft.wordpress.com/2015/04/19/variable-screen-placement-the-vic-iis-forbidden-technique/
// http://www.zimmers.net/cbmpics/cbm/c64/vic-ii.txt (Section 3.14.6. DMA delay)
//
// To utilize this create a hardware IRQ at raster line 0x2d and as the very first thing call vsp_perform().
// The variable vsp_scroll controls the VSP scroll value.

// The number of chars to scroll the screen by VSP. 
// Legal values are 0-40.
//  0 shows the normal screen (no scrolling)
// 20 shows char #20 in the top left corner of the screen, effectively scrolling the screen left 20 chars.
extern volatile __zp char vsp_scroll;

// Perform VSP scrolling of the screen
// This only works if it is called as the very first thing in a HARDWARE IRQ scheduled on raster line 0x02d.
// It will stabilize the raster (using the double IRQ method) and modify $D011 to scroll the screen according to the value in vsp_scroll
// Any sprites on lines 0x2d-0x2f will interfere and prevent the effect from working.
// After execution it is necessary to
// - Acknowledge the raster IRQ 
// - Set the raster IRQ to occur on line 0x2d (since this modifies the IRQ line)
// - Set the hardware IRQ vector (since this modifies the hardware IRQ vector)
void inline vsp_perform(); 