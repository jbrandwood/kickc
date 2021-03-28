// Game Over graphics 25 xcol * 25 ypos bytes
char GAMEOVER_GFX_CRUNCHED[] = kickasm(resource "pacman-gameover.png", uses GAMEOVER_GFX) {{
    .modify B2() {
        .pc = GAMEOVER_GFX "GAMEOVER GRAPHICS"                           //       00:BLACK, 01:BLUE, 10:YELLOW, 11:RED
        .var pic_gameover = LoadPicture("pacman-gameover.png", List().add($000000, $352879, $bfce72, $883932))
        .for(var xcol=0; xcol<25; xcol++) {
            .for(var ypos=0; ypos<25; ypos++) {
                .byte pic_gameover.getMulticolorByte(xcol,ypos)
            }
        }
    }
}};
