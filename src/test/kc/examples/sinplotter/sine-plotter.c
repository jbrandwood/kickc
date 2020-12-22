// Generate a big sine and plot it on a bitmap

#include <c64.h>
#include <sine.h>
#include <string.h>
#include <bitmap2.h>

char* SCREEN = $400;
char* BITMAP = $2000;

const unsigned int SIN_SIZE = 512;

signed int __align($100) sin[512];

signed int sin2[512] = kickasm {{
    .for(var i=0; i<512; i++) {
  	  .word sin(toRadians([i*360]/512))*320
    }
}};

void main() {
    asm { sei }  // Disable normal interrupt
    // Disable kernal & basic
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;
    *D011 = VIC_BMM|VIC_DEN|VIC_RSEL|3;
    vicSelectGfxBank(SCREEN);
    *D016 = VIC_CSEL;
    *D018 = toD018(SCREEN, BITMAP);

    bitmap_init(BITMAP, SCREEN);
    bitmap_clear(BLACK, WHITE);
    sin16s_gen2(sin, SIN_SIZE, -320, 320);
    render_sine();
    while(true) {
        (VICII->BG_COLOR)++;
    }
}

void render_sine() {
    unsigned int xpos = 0;
    for(unsigned int sin_idx=0; sin_idx<SIN_SIZE; sin_idx++) {
        signed int sin_val = *(sin+sin_idx);
        char ypos = wrap_y(sin_val);
        bitmap_plot(xpos,ypos);

        signed int sin2_val = *(sin2+sin_idx);
        char ypos2 = wrap_y(sin2_val+10);
        bitmap_plot(xpos,ypos2);

        xpos++;
        if(xpos==320) {
            xpos = 0;
        }
    }
}

char wrap_y(signed int y) {
    while(y>=200) {
        y -= 200;
    }
    while(y<0) {
        y += 200;
    }
    return (char)y;
}