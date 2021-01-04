// KickAssembler functions for converting a Picture to a multi-color bitmap
// Based on Code by Cruzer/CML, April 2011 (https://codebase64.org/doku.php?id=base:double_screen_horizontal_scroller&s[]=koala) 
// Based on a routine from Codebase64 by Martin Piper
//---------------------------------------------------------------------------------------------------------------------
// Picture - a result from LoadPicture()
// - The upper line is used for defining the c64 palette, with multicolor sized pixels
// - The pixel to the right of the palette defines the background color

// Usage:
// #import "mcbitmap.asm"
// .var mcBmmData = getMcBitmapData(LoadPicture("bitmap.png"))
// *=$0c00 "SCREEN";  
// .for (var y=0; y<25; y++)
//     .for (var x=0; x<40; x++)
//         .byte getMcScreenData(x, y, mcBmmData)
// *=$1c00 "COLORS"
// colorRam:
// .for (var y=0; y<25; y++)
//     .for (var x=0; x<40; x++)
//        .byte getMcColorData(x, y, mcBmmData)
// *=$2000 "BITMAP";            
// .for (var y=0; y<25; y++)
//     .for (var x=0; x<40; x++)
//        .fill 8, getMcPixelData(x, y, i, mcBmmData)

#importonce

.struct McBitmapPalette {
    // Hashtable mapping RGB to C64 color
	// rgb2c64.get(rgb) returns a C64 color (0-15)
    rgb2c64,
    // The (C64) background color of the image
    bgColor
}

// Bitmap data for a single (4x8 MC pixel) block
.struct McBitmapBlock {
    // List() with 8 pixel bytes
    pixels, 
    // C64 color for %01 pixels
    color1,
    // C64 color for %10 pixels
    color2,
    // C64 color for %11 pixels
    color3,
    // Byte for screen (color1*$10 + color2)
    screendata, 
    // Byte for color (color3)
    colordata
}

// Bitmap data for an entire picture
.struct McBitmapData {
	// The McBitmapPalette
	palette,
	// The number of X-blocks (40 for a normal full screen bitmap)
	width, 
	// The number of Y-blocks (25 for a normal full screen bitmap)
	height,
    // List with width*height McBitmapBlock ordered row by row. 
	// blocks.get(y*width+x) is the block at (x,y)
    blocks
}

// Get multicolor-bitmap data for a picture. The first row of the picture contains the palette and is discarded. (pixel #0-#15 as colors representing C64 color black, white, ... pixel #16 representing the background color)
.function getMcBitmapData(pic) {
	.var palette = findMcPalette(pic)
	.var width = floor(pic.width/8)	
	.var height = floor((pic.height-1)/8) // -1 to account for the first line containing the palette
	.var blocks = List()
	.for (var y=0; y<height; y++)
    	.for (var x=0; x<width; x++)	
			.eval blocks.add(createMcBlock(x, y, pic, palette))
	.return McBitmapData(palette, width, height, blocks)
}

// Get the screen data for a specific bitmap block (1 char: 4x8 MC pixels). bmData is created by getMcBitmapData()
.function getMcScreenData(x, y, bmData) {
	.return bmData.blocks.get(y*bmData.width + x).screendata
}

// Get the color data for a specific bitmap block (1 char: 4x8 MC pixels). bmData is created by getMcBitmapData()
.function getMcColorData(x, y, bmData) {
	.return bmData.blocks.get(y*bmData.width + x).colordata
}

// Get pixel data for a specific bitmap block (1 char: 4x8 MC pixels). i is the pixel row (0-7). bmData is created by getMcBitmapData()
.function getMcPixelData(x, y, i, bmData) {
	.return bmData.blocks.get(y*bmData.width + x).pixels.get(i)
}

// Find the C64 palette RGB values to use.
// Looks at the first 16 pixels in the first line (0,0)..(0,15) of an image to find the palette.
// Looks at pixel number 17 in the first line (0,16) to identify the background color to use. 
// Returns McBitmapPalette
.function findMcPalette(pic) {
	.var rgb2c64 = Hashtable()
	.for (var i=0; i<16; i++) {
		.var rgb = pic.getPixel(i*2,0)
		.eval rgb2c64.put(rgb, i)
	}
	.var bgRgb = pic.getPixel(16*2,0)
	.var bgColor = rgb2c64.get(bgRgb)
	.return McBitmapPalette(rgb2c64, bgColor)
}

// Get the C64 color for a specific pixel (0-15)
// Assumes multicolor with 2-pixel wide 
// Uses the passed palette to identify the C64 color
.function getMcC64Color(xPos, yPos, pic, palette) {
	.var rgb = pic.getPixel(xPos*2, yPos+1)
	.var c64Color = palette.rgb2c64.get(rgb)
	.return c64Color
}

// Get the C64 colors to use for a bitmap block (1 char: 4x8 MC pixels).
// Returns a list with 16 values (one per C64 color). 
// The values in the list is 0 for unused (or bgColor) and 1, 2, 3 for each used color.
// cols.get(c64Color) will return %01, %10, %11 when passed the C64 color matching each multi-color. This is exactly the pixel value to use for the color.
.function findMcBlockColors(chrX, chrY, pic, palette) {
	.var colorCounts = List()
	.for (var i=0; i<16; i++) .eval colorCounts.add(0)
	.for (var pixY=0; pixY<8; pixY++) {
	    .for (var pixX=0; pixX<4; pixX++) {
		    .var c64Color = getMcC64Color(chrX*4 + pixX, chrY*8 + pixY, pic, palette)
		    .eval colorCounts.set(c64Color, colorCounts.get(c64Color) + 1)
	    }
    }
	.eval colorCounts.set(palette.bgColor,0)
	.for (var i=0; i<16; i++) .eval colorCounts.set(i, [colorCounts.get(i) << 4] | i)
	.eval colorCounts.sort()
	.eval colorCounts.reverse()
	.var blockColors = List()
	.for (var i=0; i<16; i++) .eval blockColors.add(0)
	    .for (var i=0; i<3; i++) {
		    .var c64Color = colorCounts.get(i) & $0f
		    .eval blockColors.set(c64Color, i+1)
	    }
	.return blockColors
}

// Get the bitmap bytes for a a bitmap block (1 char: 4x8 MC pixels).
// Returns BitmapBlock containing pixel data and color data for the bitmap block
.function createMcBlock(chrX, chrY, pic, palette) {
	.var blockColors = findMcBlockColors(chrX, chrY, pic, palette)
	.var pixelData = List()
	.for (var pixY=0; pixY<8; pixY++) {
		.var bitmapByte = 0
	    .for (var pixX=0; pixX<4; pixX++) {
		    .var c64Color = getMcC64Color(chrX*4 + pixX, chrY*8 + pixY, pic, palette)
		    .var multiColor = blockColors.get(c64Color)
		    .eval bitmapByte = bitmapByte | [multiColor << [6 - pixX*2]]
	    }
        .eval pixelData.add(bitmapByte)
	}
    .var bitmapBlock = McBitmapBlock()
    .eval bitmapBlock.pixels = pixelData
    // Find the three C64 multi-colors
    .for (var i=1; i<16; i++) {
        .if (blockColors.get(i) == %01) .eval bitmapBlock.color1 = i
        .if (blockColors.get(i) == %10) .eval bitmapBlock.color2 = i
        .if (blockColors.get(i) == %11) .eval bitmapBlock.color3 = i
    }
    // Convert multi-colors to screen data and color data
    .eval bitmapBlock.screendata = (bitmapBlock.color1 << 4) | (bitmapBlock.color2 & $f)
    .eval bitmapBlock.colordata = bitmapBlock.color3
	.return bitmapBlock
}
