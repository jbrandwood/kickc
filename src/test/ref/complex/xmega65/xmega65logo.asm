// Import an XMega65 8bit-per-color logo
// Fill the palette values into
  // Commodore 64 PRG executable file
.file [name="xmega65logo.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  // Create pointers to the palette RGBs in the logo (assumes dimensions are 128x128)
  .label LOGO256_RED = LOGO256+$80*$80
  .label LOGO256_GREEN = LOGO256_RED+$100
  .label LOGO256_BLUE = LOGO256_GREEN+$100
.segment Code
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    // (SCREEN+40*0)[i] = LOGO256_RED[i]
    lda LOGO256_RED,x
    sta SCREEN,x
    // (SCREEN+40*8)[i] = LOGO256_GREEN[i]
    lda LOGO256_GREEN,x
    sta SCREEN+$28*8,x
    // (SCREEN+40*16)[i] = LOGO256_BLUE[i]
    lda LOGO256_BLUE,x
    sta SCREEN+$28*$10,x
    // for(byte i:0..0xff)
    inx
    cpx #0
    bne __b1
    // }
    rts
}
.segment Data
// Import a 128x128 8bit-per-color logo using inline KickAsm
LOGO256:
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

