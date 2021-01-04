#include <c64.h>
#include <string.h>

char* SCREEN = $400;
__address(0x2000) char LOGO[6*40*8] = kickasm(resource "logo.png") {{
    .var logoPic = LoadPicture("logo.png", List().add($444444, $808080, $000000, $ffffff))
    .for (var y=0; y<6	; y++)
        .for (var x=0;x<40; x++)
            .for(var cp=0; cp<8; cp++)
                .byte logoPic.getMulticolorByte(x,cp+y*8)
}};

void main() {
    VICII->BORDER_COLOR = WHITE;
    VICII->BG_COLOR = VICII->BG_COLOR1 = DARK_GREY;
    VICII->BG_COLOR2 = BLACK;
    *D018 = toD018(SCREEN, LOGO);
    *D016 = VICII_MCM | VICII_CSEL;
    memset(SCREEN, BLACK, 40*25);
    memset(COLS, WHITE|8, 40*25);
    for(char ch: 0..239) {
        SCREEN[ch] = ch;
    }
    while(true) {
        (*(SCREEN+999))++;
        kickasm {{ inc $d020 }}
    }
}
