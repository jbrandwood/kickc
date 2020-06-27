// Example of inline kickasm resource data

__address(0x0c00) byte SPRITE[] = kickasm(resource "balloon.png") {{
    .var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)
}};

char* const SCREEN= 0x400;
char* const SPRITES_ENABLE = 0xd015;
char* const SPRITES_XPOS = 0xd000;
char* const SPRITES_YPOS = 0xd001;

void main() {
    *(SCREEN+0x3f8) = (char)((unsigned int)SPRITE/$40);
    *SPRITES_ENABLE = 1;
    *SPRITES_XPOS = 100;
    *SPRITES_YPOS = 100;
}
