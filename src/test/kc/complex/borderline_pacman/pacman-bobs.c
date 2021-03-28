// BOB data: One table per bob byte (left/right, mask/pixels = 4 tables). The index into the table is the bob_id + row*BOB_ROW_SIZE.
char BOB_GRAPHICS_CRUNCHED[] = kickasm(resource "pacman-bobs.png", uses BOB_MASK_LEFT) {{
    .modify B2() {
        .pc = BOB_MASK_LEFT "BOB GRAPHICS TABLES"
        .var bobs_pic = LoadPicture("pacman-bobs.png", List().add($000000, $352879, $bfce72, $883932))
        // TABLE char BOB_MASK_LEFT[BOB_ROW_SIZE*6]
        .for(var row=0; row<6;row++) {
            .align BOB_ROW_SIZE
            .for(var pac=0; pac<9;pac++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(0,scroll*6+row)
            .for(var ghost=0; ghost<8;ghost++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(0,24+scroll*6+row)
            .for(var ghost=0; ghost<8;ghost++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(0,48+scroll*6+row)
        }    
        // TABLE char BOB_MASK_RIGT[BOB_ROW_SIZE*6]
        .for(var row=0; row<6;row++) {
            .align BOB_ROW_SIZE
            .for(var pac=0; pac<9;pac++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(1,scroll*6+row)
            .for(var ghost=0; ghost<8;ghost++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(1,24+scroll*6+row)
            .for(var blue=0; blue<8;blue++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(1,48+scroll*6+row)
        }    
        // TABLE char BOB_PIXEL_LEFT[BOB_ROW_SIZE*6]
        .for(var row=0; row<6;row++) {
            .align BOB_ROW_SIZE
            .for(var pac=0; pac<9;pac++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(2+pac*2,scroll*6+row)
            .for(var ghost=0; ghost<8;ghost++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(2+ghost*2,24+scroll*6+row)
            .for(var ghost=0; ghost<8;ghost++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(2+ghost*2,48+scroll*6+row)
        }    
        // TABLE char BOB_PIXEL_RIGT[BOB_ROW_SIZE*6]
        .for(var row=0; row<6;row++) {
            .align BOB_ROW_SIZE
            .for(var pac=0; pac<9;pac++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(3+pac*2,scroll*6+row)
            .for(var ghost=0; ghost<8;ghost++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(3+ghost*2,24+scroll*6+row)
            .for(var ghost=0; ghost<8;ghost++)
                .for(var scroll=0; scroll<4;scroll++)
                    .byte bobs_pic.getMulticolorByte(3+ghost*2,48+scroll*6+row)
        }  
    }  
}};




