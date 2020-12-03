#include <c64.h>
#include <sine.h>
#include <string.h>

char* SCREEN = $400;
__address(0x2000) char LOGO[6*40*8]  = kickasm(resource "logo.png") {{
    .var logoPic = LoadPicture("logo.png", List().add($444444, $808080, $000000, $ffffff))
    .for (var y=0; y<6	; y++)
        .for (var x=0;x<40; x++)
            .for(var cp=0; cp<8; cp++)
                .byte logoPic.getMulticolorByte(x,cp+y*8)
}};

const unsigned int XSIN_SIZE = 512;

signed int align($100) xsin[XSIN_SIZE];

void main() {
    asm { sei }
    VICII->BORDER_COLOR = WHITE;
    VICII->BG_COLOR = VICII->BG_COLOR1 = DARK_GREY;
    VICII->BG_COLOR2 = BLACK;
    *D018 = toD018(SCREEN, LOGO);
    *D016 = VIC_MCM;
    memset(SCREEN, BLACK, 1000);
    memset(COLS, WHITE|8, 1000);
    for(char ch: 0..239) {
        SCREEN[ch] = ch;
    }
    sin16s_gen2(xsin, XSIN_SIZE, -320, 320);
    loop();
}

unsigned int xsin_idx = 0;

void loop() {
    while(true) {
        // Wait for the raster to reach the bottom of the screen
        while(VICII->RASTER!=$ff) {}
        (VICII->BORDER_COLOR)++;
        signed int xpos = *(xsin+xsin_idx);
        render_logo(xpos);
        if(++xsin_idx==XSIN_SIZE) {
            xsin_idx = 0;
        }
        (VICII->BORDER_COLOR)--;
    }
}

void render_logo(signed int xpos) {
    char logo_idx;
    char screen_idx;
    *D016 = VIC_MCM|((char)xpos&7);
    signed char x_char = (signed char)(xpos/8);
    char line = 0;
    if(xpos<0) {
        // Render right side of the logo and some spaces
        logo_idx = (char)(-x_char);
        screen_idx = 0;
        while(logo_idx!=40) {
            inline for(line: 0..5) {
                (SCREEN+40*line)[screen_idx] = logo_idx+40*line;
            }
            screen_idx++;
            logo_idx++;
        }
        while(screen_idx!=40) {
            inline for(line: 0..5) {
                (SCREEN+40*line)[screen_idx] = $00;
            }
            screen_idx++;
        }
    } else {
        // Render some spaces and the left of the logo
        char logo_start = (char)x_char;
        screen_idx = 0;
        while(screen_idx!=logo_start) {
            inline for(line: 0..5) {
                (SCREEN+40*line)[screen_idx] = $00;
            }
            screen_idx++;
        }
        logo_idx = 0;
        while(screen_idx!=40) {
            inline for(line: 0..5) {
                (SCREEN+40*line)[screen_idx] = logo_idx+40*line;
            }
            screen_idx++;
            logo_idx++;
        }
    }
}
