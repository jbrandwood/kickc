// Splash screen 25 xcol * 147 ypos bytes
char SPLASH_CRUNCHED[] = kickasm(resource "pacman-splash.png", uses SPLASH) {{
    .modify B2() {
        .pc = SPLASH "SPLASH SCREEN"                           //       00:BLACK, 01:BLUE, 10:YELLOW, 11:RED
        .var pic_splash_mc = LoadPicture("pacman-splash.png", List().add($000000, $352879, $bfce72, $883932))
                                                           //                0:BLACK, 1:YELLOW
        .var pic_splash_yellow = LoadPicture("pacman-splash.png", List().add($000000, $bfce72))
                                                           //                0:BLACK, 1:BLUE
        .var pic_splash_blue = LoadPicture("pacman-splash.png", List().add($000000, $352879))
        .for(var xcol=0; xcol<25; xcol++) {
            .for(var ypos=0; ypos<147; ypos++) {
                .if(ypos>25 && ypos<123) {
                    // Sprites in the sides are in single color blue on splash screen
                    .byte pic_splash_blue.getSinglecolorByte(xcol,ypos)
                } else .if(xcol>2 && xcol<21) {
                    // Sprites 2-7 are in single color yellow on splash screen
                    .byte pic_splash_yellow.getSinglecolorByte(xcol,ypos)
                } else {
                    // Sprites 0&1 are in multi color on splash screen
                    .byte pic_splash_mc.getMulticolorByte(xcol,ypos)
                }
            }        
        }
    }
}};
