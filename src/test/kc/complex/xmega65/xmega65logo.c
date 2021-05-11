// Import an XMega65 8bit-per-color logo
// Fill the palette values into

void main() {
    char* const SCREEN = (char*)0x0400;
    for(byte i:0..0xff) {
        (SCREEN+40*0)[i] = LOGO256_RED[i];
        (SCREEN+40*8)[i] = LOGO256_GREEN[i];
        (SCREEN+40*16)[i] = LOGO256_BLUE[i];
    }
}

// Import a 128x128 8bit-per-color logo using inline KickAsm
char LOGO256[] = kickasm(resource "mega65-256.png", resource "xmega65graphics.asm") {{
    #import "xmega65graphics.asm"
    .var logo256 = LoadPicture("mega65-256.png")
    .var palette256 = getPalette(logo256)
    .print "width: "+logo256.width + " height: "+logo256.height + " colors: "+palette256.keys().size()
    // Output the graphics
    .for (var x=0; x<logo256.width; x++)
	    .for (var y=0; y<logo256.height; y++)
		    .byte getFullcolourByte(logo256, palette256, x, y)
    // Output the RGB-values of the palette
    .fill 256, getPaletteRed(palette256,i)
    .fill 256, getPaletteGreen(palette256,i)
    .fill 256, getPaletteBlue(palette256,i)
}};
// Create pointers to the palette RGBs in the logo (assumes dimensions are 128x128)
char* LOGO256_RED = LOGO256+128*128;
char* LOGO256_GREEN = LOGO256_RED+256;
char* LOGO256_BLUE = LOGO256_GREEN+256;



