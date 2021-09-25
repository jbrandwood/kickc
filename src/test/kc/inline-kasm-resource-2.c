// Example of inline kickasm resource data - using #pramga resource()

#pragma resource("balloon.png")

__address(0x0c00) byte SPRITE[] = kickasm {{
    .var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)
}};

char* const SCREEN= (char*)0x400;
char* const SPRITES_ENABLE = (char*)0xd015;
char* const SPRITES_XPOS = (char*)0xd000;
char* const SPRITES_YPOS = (char*)0xd001;

void main() {
    *(SCREEN+0x3f8) = (char)((unsigned int)SPRITE/$40);
    *SPRITES_ENABLE = 1;
    *SPRITES_XPOS = 100;
    *SPRITES_YPOS = 100;
}
