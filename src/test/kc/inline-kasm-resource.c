// Example of inline kickasm resource data

__address(0x0c00) byte SPRITE[] = kickasm(resource "balloon.png") {{
    .var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)
}};

byte* const SCREEN= $400;
byte* const SPRITES_ENABLE = $d015;
byte* const SPRITES_XPOS = $d000;
byte* const SPRITES_YPOS = $d001;

void main() {
    *(SCREEN+$3f8) = (byte)((word)SPRITE/$40);
    *SPRITES_ENABLE = 1;
    *SPRITES_XPOS = 100;
    *SPRITES_YPOS = 100;
}
