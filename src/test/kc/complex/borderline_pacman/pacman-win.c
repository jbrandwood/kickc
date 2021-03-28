// Victory graphics 25 xcol * 25 ypos bytes
char WIN_GFX_CRUNCHED[] = kickasm(resource "pacman-win.png", uses WIN_GFX) {{
    .modify B2() {
        .pc = WIN_GFX "WIN GRAPHICS"                           //       00:BLACK, 01:BLUE, 10:YELLOW, 11:RED
        .var pic_win = LoadPicture("pacman-win.png", List().add($000000, $352879, $bfce72, $883932))
        .for(var xcol=0; xcol<25; xcol++) {
            .for(var ypos=0; ypos<25; ypos++) {
                .byte pic_win.getMulticolorByte(xcol,ypos)
            }
        }
    }
}};
