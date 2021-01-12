// Example program for the Commander X16.
// Demonstrates the usage of the VERA layer 0 and 1.

// Author: Sven Van de Velde

// The default layer of the CX16 is layer 1.
// The CX16 starts in tile map mode, 1BPP in 16 color mode, and uses 8x8 tiles.
// The map base is address 0x00000 in VERA VRAM, the tile map is address 0x0F800.

#include <veralib.h>
#include <printf.h>
#include <6502.h>

void main() {

    textcolor(WHITE);
    bgcolor(GREEN);
    scroll(0); // Scrolling on conio is deactivated, so conio will output beyond the borders of the visible screen.
    clrscr();

    dword tilebase = vera_get_layer_tilebase_address(1);
    dword tilecolumn = tilebase;
    dword tilerow = tilebase;

    // Now we set the tile map width and height.
    vera_set_layer_map_width_128(1);
    vera_set_layer_map_height_128(1);
    clrscr();

    for(byte y:0..15) {
        tilerow = tilebase;
        for(byte r:0..7) {
            tilecolumn = tilerow;
            for(byte x:0..15) {
                vera_vram_address0(tilecolumn,VERA_INC_0);
                byte data = *VERA_DATA0;
                byte bit = data;
                for(byte b:8..1) {
                    bit = (data >> (b-1)) & $1;
                    printf("%c", (char)((bit)?'*':'.'));
                }
                tilecolumn += 8;
                printf("");
            }
            //printf("\n");
            tilerow += 1;
        }
        tilebase += 8*16;
    }

    // Enable VSYNC IRQ (also set line bit 8 to 0)
    SEI();
    *KERNEL_IRQ = &irq_vsync;
    *VERA_IEN = VERA_VSYNC;
    CLI();



}

// X sine index
volatile int scroll_x = 0;
volatile int scroll_y = 0;
volatile int delta_x = 2;
volatile int delta_y = 0;
volatile int speed = 2;

// VSYNC Interrupt Routine
__interrupt(rom_sys_cx16) void irq_vsync() {


    scroll_x += delta_x;
    scroll_y += delta_y;

    if( scroll_x>(128*8-80*8)) {
        delta_x = 0;
        delta_y = speed;
        scroll_x = (128*8-80*8);
    }
    if( scroll_y>(128*8-60*8)) {
        delta_x = -speed;
        delta_y = 0;
        scroll_y = (128*8-60*8);
    }
    if(scroll_x<0) {
        delta_x = 0;
        delta_y = -speed;
        scroll_x = 0;
    }
    if(scroll_y<0) {
        delta_x = speed;
        delta_y = 0;
        scroll_y = 0;
   }


    *VERA_L1_HSCROLL_L = <scroll_x;
    *VERA_L1_HSCROLL_H = >scroll_x;
    *VERA_L1_VSCROLL_L = <scroll_y;
    *VERA_L1_VSCROLL_H = >scroll_y;

    // Reset the VSYNC interrupt
    *VERA_ISR = VERA_VSYNC;
    // Exit CX16 KERNAL IRQ
    asm {
        // soft exit (keep kernal running)
        jmp $e034
    }
}