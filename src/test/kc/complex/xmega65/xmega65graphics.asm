#importonce

// Creates a palette for a picture.
// The palette is a hashtable mapping color RGB in hexadeciaml RRGGBB format to the index of the color.
// The size of the palette is the number of different RGB-colors present in the picture
// Parameters
// - picture: a picture loaded using LoadPicture()
.function getPalette(picture) {
	.var palette = Hashtable()
	.var colIdx = 0;
	.for (var x=0; x<picture.width; x++) {
		.for (var y=0; y<picture.height; y++) {
			.var col = toHexString(picture.getPixel(x,y),6)
			.if(palette.get(col)==null) .eval palette.put(col,colIdx++)
		}
	}
	.return palette
}

// Get the RGB value of a palette color
// Parameters
// - palette: A palette typically created using getPalette(picture)
// - idx: The index of the color in the palette to get the red value
// Returns the RGB value of the color with the given index. 0 if the index is not defined.
.function getPaletteRgb(palette, idx) {
	.if(idx>=palette.keys().size())
		.return 0
	.var colHex = palette.keys().get(idx)
	.return colHex.asNumber(16)
}

// Get the red value of a palette color
// Parameters
// - palette: A palette typically created using getPalette(picture)
// - idx: The index of the color in the palette to get the red value
.function getPaletteRed(palette, idx) {
	.return getPaletteRgb(palette, idx)>>16 & $ff
}

// Get the green value of a palette color
// Parameters
// - palette: A palette typically created using getPalette(picture)
// - idx: The index of the color in the palette to get the green value
.function getPaletteGreen(palette, idx) {
	.return getPaletteRgb(palette, idx)>>8 & $ff
}

// Get the blue value of a palette color
// Parameters
// - palette: A palette typically created using getPalette(picture)
// - idx: The index of the color in the palette to get the blue value
.function getPaletteBlue(palette, idx) {
	.return getPaletteRgb(palette, idx) & $ff
}

// Get the index in a color palette for a single pixel in a picture
// Parameters
// - picture: a picture loaded using LoadPicture()
// - x: the x-coordinate of the pixel
// - y: the y-coordinate of the pixel
// - palette: a palette for the picture typically created using getPalette(picture)
.function getPaletteColour(picture, palette, x, y) {
	.return palette.get(toHexString(picture.getPixel(x,y),6))
}


// Converts 1 pixels to a single color byte using the palette
// - picture: a picture loaded using LoadPicture()
// - x: the x-coordinate of the pixel
// - y: the y-coordinate of the pixel
// - palette: a palette for the picture typically created using getPalette(picture)
.function getFullcolourByte(picture, palette, x, y) {
	.return getPaletteColour(picture, palette, x, y) & $ff
}

// Converts 2 pixels to a multi color byte (2 4-bit color nybbles) using the palette
// - picture: a picture loaded using LoadPicture()
// - x: the x-coordinate of the first pixel.
// - y: the y-coordinate of the pixel
// - palette: a palette for the picture. Only the first 16 colors of the palette is used.
// Returns: A byte containing two pixels. The high nybble is the color at (x,y) the low nybble is the color at (x+1,y)
.function getSixteencolourByte(picture, palette, x, y) {
	.return ((getPaletteColour(picture, palette, x, y) & $f) << 4) | (getPaletteColour(picture, palette, x+1, y) &$f)
}