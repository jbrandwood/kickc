// Commander X16 VERA (Versatile Embedded Retro Adapter) Video and Audio Processor
// https://github.com/commanderx16/x16-docs/blob/master/VERA%20Programmer's%20Reference.md

// Author: Sven Van de Velde

#include <cx16.h>
#include <veralib.h>

// --- VERA function encapsulation ---

// --- VERA layer management ---


// --- VERA addressing ---

void vera_vram_bank_offset(byte bank, word offset, byte incr) {
    // Select DATA0
    *VERA_CTRL &= ~VERA_ADDRSEL;
    // Set address
    *VERA_ADDRX_L = <(offset);
    *VERA_ADDRX_M = >(offset);
    *VERA_ADDRX_H = bank | incr;
}

void vera_vram_address0(dword bankaddr, byte incr) {
    word* word_l = &(<bankaddr);
    word* word_h = &(>bankaddr);
    // Select DATA0
    *VERA_CTRL &= ~VERA_ADDRSEL;
    // Set address
    *VERA_ADDRX_L = <(*word_l);
    *VERA_ADDRX_M = >(*word_l);
    *VERA_ADDRX_H = <(*word_h) | incr;
}

void vera_vram_address1(dword bankaddr, byte incr) {
    word* word_l = &(<bankaddr);
    word* word_h = &(>bankaddr);
    // Select DATA1
    *VERA_CTRL |= VERA_ADDRSEL;
    // Set address
    *VERA_ADDRX_L = <(*word_l);
    *VERA_ADDRX_M = >(*word_l);
    *VERA_ADDRX_H = <(*word_h) | incr;
}

// --- VERA active display management ---

void vera_display_set_scale_none() {
    *VERA_DC_HSCALE = 128;
    *VERA_DC_VSCALE = 128;
}

void vera_display_set_scale_double() {
    *VERA_DC_HSCALE = 64;
    *VERA_DC_VSCALE = 64;
}

void vera_display_set_scale_triple() {
    *VERA_DC_HSCALE = 32;
    *VERA_DC_VSCALE = 32;
}

byte vera_display_get_hscale() {
    byte hscale[4] = {0,128,64,32};
    byte scale = 0;
    for(byte s:1..3) {
        if(*VERA_DC_HSCALE==hscale[s]) {
            scale = s;
            break;
        }
    }
    return scale;
}

byte vera_display_get_vscale() {
    byte vscale[4] = {0,128,64,32};
    byte scale = 0;
    for(byte s:1..3) {
        if(*VERA_DC_VSCALE==vscale[s]) {
            scale = s;
            break;
        }
    }
    return scale;
}

word vera_display_get_height() {
    byte scale = vera_display_get_vscale();
    word height = (word)(*VERA_DC_VSTOP - *VERA_DC_VSTART);
    switch( scale ) {
        case 2:
            height = height >> 1;
            break;
        case 3:
            height = height >> 2;
            break;
    }
    return height<<1;
}


// --- VERA layer management ---

// Set the configuration of the layer.
// - layer: Value of 0 or 1.
// - config: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
void vera_layer_set_config(byte layer, byte config) {
    byte* addr = vera_layer_config[layer];
    *addr = config;
}

// Set the configuration of the layer.
// - layer: Value of 0 or 1.
// - config: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
byte vera_layer_get_config(byte layer) {
    byte* config = vera_layer_config[layer];
    return *config;
}

// Set the configuration of the layer.
// - layer: Value of 0 or 1.
// - color_mode: Specifies the color mode to be VERA_LAYER_CONFIG_16 or VERA_LAYER_CONFIG_256 for text mode.
void vera_layer_set_text_color_mode( byte layer, byte color_mode ) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_CONFIG_256C;
    *addr |= color_mode;
}

// Set the configuration of the layer to bitmap mode.
// - layer: Value of 0 or 1.
void vera_layer_set_bitmap_mode( byte layer ) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_CONFIG_MODE_BITMAP;
    *addr |= VERA_LAYER_CONFIG_MODE_BITMAP;
}

// Set the configuration of the layer to tilemap mode.
// - layer: Value of 0 or 1.
void vera_layer_set_tilemap_mode( byte layer ) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_CONFIG_MODE_BITMAP;
    *addr |= VERA_LAYER_CONFIG_MODE_TILE;
}

// Set the map width or height of the layer.
// - layer: Value of 0 or 1.
inline void vera_layer_set_width_32(byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_WIDTH_MASK;
    *addr |= VERA_LAYER_WIDTH_32;
}
inline void vera_layer_set_width_64(byte layer) {
    byte* addr = vera_layer_config[layer];
    //*addr &= (~VERA_CONFIG_WIDTH_MASK) | VERA_CONFIG_WIDTH_64;
    *addr &= ~VERA_LAYER_WIDTH_MASK;
    *addr |= VERA_LAYER_WIDTH_64;
}
inline void vera_layer_set_width_128(byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_WIDTH_MASK;
    *addr |= VERA_LAYER_WIDTH_128;
}
inline void vera_layer_set_width_256(byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_WIDTH_MASK;
    *addr |= VERA_LAYER_WIDTH_256;
}
inline void vera_layer_set_height_32(byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_HEIGHT_MASK;
    *addr |= VERA_LAYER_HEIGHT_32;
}
inline void vera_layer_set_height_64(byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_HEIGHT_MASK;
    *addr |= VERA_LAYER_HEIGHT_64;
}
inline void vera_layer_set_height_128(byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_HEIGHT_MASK;
    *addr |= VERA_LAYER_HEIGHT_128;
}
inline void vera_layer_set_height_256(byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_HEIGHT_MASK;
    *addr |= VERA_LAYER_HEIGHT_256;
}

// Get the map width or height of the layer.
// - layer: Value of 0 or 1.
word vera_layer_get_width(byte layer) {
    byte* config = vera_layer_config[layer];
    byte mask = (byte)VERA_LAYER_WIDTH_MASK;
    return VERA_LAYER_WIDTH[ (*config & mask) >> 4];
}

word vera_layer_get_height(byte layer) {
    byte* config = vera_layer_config[layer];
    byte mask = VERA_LAYER_HEIGHT_MASK;
    return VERA_LAYER_HEIGHT[ (*config & mask) >> 6];
}

// Set the color depth of the layer in terms of bit per pixel (BPP) of the tile base.
// - layer: Value of 0 or 1.
inline void vera_layer_set_color_depth_1BPP(byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *addr |= VERA_LAYER_COLOR_DEPTH_1BPP;
}
inline void vera_layer_set_color_depth_2BPP(byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *addr |= VERA_LAYER_COLOR_DEPTH_2BPP;
}
inline void vera_layer_set_color_depth_4BPP(byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *addr |= VERA_LAYER_COLOR_DEPTH_4BPP;
}
inline void vera_layer_set_color_depth_8BPP(byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *addr |= VERA_LAYER_COLOR_DEPTH_8BPP;
}

// Get the map width or height of the layer.
// - layer: Value of 0 or 1.
// - return: 1, 2, 4 or 8.
byte vera_layer_get_color_depth(byte layer) {
    byte* config = vera_layer_config[layer];
    byte mask = (byte)VERA_LAYER_COLOR_DEPTH_MASK;
    return VERA_LAYER_COLOR_DEPTH[(*config & mask)];
}

// Enable the layer to be displayed on the screen.
// - layer: 0 or 1.
inline void vera_layer_show(byte layer) {
    *VERA_DC_VIDEO |= vera_layer_enable[layer];
}


// Disable the layer to be displayed on the screen.
// - layer: 0 or 1.
inline void vera_layer_hide(byte layer) {
    *VERA_DC_VIDEO &= ~vera_layer_enable[layer];
}


// Is the layer shown on the screen?
// - returns: 1 if layer is displayed on the screen, 0 if not.
inline byte vera_layer_is_visible(byte layer) {
    return *VERA_DC_VIDEO & vera_layer_enable[layer];
}

// Set the base of the map layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - mapbase: Specifies the base address of the tile map.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
void vera_layer_set_mapbase(byte layer, byte mapbase) {
    byte* addr = vera_layer_mapbase[layer];
    *addr = mapbase;
}

// Set the base of the map layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - mapbase_address: a dword typed address (4 bytes), that specifies the full address of the map base.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective mapbase vera register.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
void vera_layer_set_mapbase_address(byte layer, dword mapbase_address) {

    mapbase_address = mapbase_address & 0x1FF00; // Aligned to 2048 bit zones.
    byte bank_mapbase = (byte)>mapbase_address;
    word offset_mapbase = <mapbase_address;

    vera_mapbase_address[layer] = mapbase_address;
    vera_mapbase_offset[layer] = offset_mapbase;
    vera_mapbase_bank[layer] = bank_mapbase;

    byte mapbase = >(<(mapbase_address>>1));
    vera_layer_set_mapbase(layer,mapbase);
}

// Get the map base address of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Specifies the map base address of the layer, which is returned as a dword.
//   Note that the register only specifies bits 16:9 of the 17 bit address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes!
dword vera_layer_get_mapbase_address(byte layer) {
    return vera_mapbase_address[layer];
}

// Get the map base bank of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Bank in vera vram.
byte vera_layer_get_mapbase_bank(byte layer) {
    return vera_mapbase_bank[layer];
}

// Get the map base lower 16-bit address (offset) of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Offset in vera vram of the specified bank.
word vera_layer_get_mapbase_offset(byte layer) {
    return vera_mapbase_offset[layer];
}

// Get the base of the map layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - return: Returns the base address of the tile map.
//   Note that the register is a byte, specifying only bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
byte vera_layer_get_mapbase(byte layer) {
    byte* mapbase = vera_layer_mapbase[layer];
    return *mapbase;
}

// Set the base of the tiles for the layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - tilebase: Specifies the base address of the tile map.
//   Note that the register only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
void vera_layer_set_tilebase(byte layer, byte tilebase) {
    byte* addr = vera_layer_tilebase[layer];
    *addr = tilebase;
}

// Get the base of the tiles for the layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - return: Specifies the base address of the tile map.
//   Note that the register only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
byte vera_layer_get_tilebase(byte layer) {
    byte* tilebase = vera_layer_tilebase[layer];
    return *tilebase;
}

// Set the base address of the tiles for the layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - tilebase_address: a dword typed address (4 bytes), that specifies the base address of the tile map.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective tilebase vera register.
//   Note that the resulting vera register holds only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
void vera_layer_set_tilebase_address(byte layer, dword tilebase_address) {

    tilebase_address = tilebase_address & 0x1FC00; // Aligned to 2048 bit zones.
    byte bank_tilebase = (byte)>tilebase_address;
    word word_tilebase = <tilebase_address;

    vera_tilebase_address[layer] = tilebase_address;
    vera_tilebase_offset[layer] = word_tilebase;
    vera_tilebase_bank[layer] = bank_tilebase;

    byte* vera_tilebase = vera_layer_tilebase[layer];
    byte tilebase = >(<(tilebase_address>>1));
    tilebase &= VERA_LAYER_TILEBASE_MASK; // Ensure that only tilebase is blanked, but keep the rest!
    //printf("tilebase = %x\n",tilebase);
    //while(!kbhit());
    tilebase = tilebase | ( *vera_tilebase & ~VERA_LAYER_TILEBASE_MASK );

    vera_layer_set_tilebase(layer,tilebase);
}

// Get the tile base address of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Specifies the base address of the tile map, which is calculated as an unsigned long int.
//   Note that the register only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
dword vera_layer_get_tilebase_address(byte layer) {
    byte tilebase = *vera_layer_tilebase[layer];
    dword address = tilebase;
    address &= $FC;
    address <<= 8;
    address <<= 1;
    return address;
}

// --- VERA color management ---

// Set the front color for text output. The old front text color setting is returned.
// - layer: Value of 0 or 1.
// - color: a 4 bit value ( decimal between 0 and 15) when the VERA works in 16x16 color text mode.
//   An 8 bit value (decimal between 0 and 255) when the VERA works in 256 text mode.
//   Note that on the VERA, the transparent color has value 0.
byte vera_layer_set_textcolor(byte layer, byte color) {
    byte old = vera_layer_textcolor[layer];
    vera_layer_textcolor[layer] = color;
    return old;
}

// Get the front color for text output. The old front text color setting is returned.
// - layer: Value of 0 or 1.
// - return: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
byte vera_layer_get_textcolor(byte layer) {
    return vera_layer_textcolor[layer];
}

// Set the back color for text output. The old back text color setting is returned.
// - layer: Value of 0 or 1.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
byte vera_layer_set_backcolor(byte layer, byte color) {
    byte old = vera_layer_backcolor[layer];
    vera_layer_backcolor[layer] = color;
    return old;
}

// Get the back color for text output. The old back text color setting is returned.
// - layer: Value of 0 or 1.
// - return: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
byte vera_layer_get_backcolor(byte layer) {
    return vera_layer_backcolor[layer];
}

// Get the text and back color for text output in 16 color mode.
// - layer: Value of 0 or 1.
// - return: an 8 bit value with bit 7:4 containing the back color and bit 3:0 containing the front color.
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
byte vera_layer_get_color(byte layer) {
    byte* addr = vera_layer_config[layer];
    if( *addr & VERA_LAYER_CONFIG_256C )
        return (vera_layer_textcolor[layer]);
    else
        return ((vera_layer_backcolor[layer] << 4) | vera_layer_textcolor[layer]);
}


// Scroll the horizontal (X) axis of the layer visible area over the layer tile map area.
// - layer: Value of 0 or 1.
// - scroll: A value between 0 and 4096.
inline void vera_layer_set_horizontal_scroll(byte layer, word scroll) {
    *vera_layer_hscroll_l[layer] = <scroll;
    *vera_layer_hscroll_h[layer] = >scroll;
}

// Scroll the vertical (Y) axis of the layer visible area over the layer tile map area.
// - layer: Value of 0 or 1.
// - scroll: A value between 0 and 4096.
inline void vera_layer_set_vertical_scroll(byte layer, word scroll) {
    *vera_layer_vscroll_l[layer] = <scroll;
    *vera_layer_vscroll_h[layer] = >scroll;
}

// Get the bit shift value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Rowshift value to calculate fast from a y value to line offset in tile mode.
byte vera_layer_get_rowshift(byte layer) {
    return vera_layer_rowshift[layer];
}

// Get the value required to skip a whole line fast.
// - layer: Value of 0 or 1.
// - return: Skip value to calculate fast from a y value to line offset in tile mode.
word vera_layer_get_rowskip(byte layer) {
    return vera_layer_rowskip[layer];
}



// Set a vera layer in tile mode and configure the:
// - layer: Value of 0 or 1.
// - mapbase_address: A dword typed address (4 bytes), that specifies the full address of the map base.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective mapbase vera register.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// - tilebase_address: A dword typed address (4 bytes), that specifies the base address of the tile map.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective tilebase vera register.
//   Note that the resulting vera register holds only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
// - mapwidth: The width of the map in number of tiles.
// - mapheight: The height of the map in number of tiles.
// - tilewidth: The width of a tile, which can be 8 or 16 pixels.
// - tileheight: The height of a tile, which can be 8 or 16 pixels.
// - color_depth: The color depth in bits per pixel (BPP), which can be 1, 2, 4 or 8.
void vera_layer_mode_tile(byte layer, dword mapbase_address, dword tilebase_address, word mapwidth, word mapheight, byte tilewidth, byte tileheight, byte color_depth ) {
    // config
    byte config = 0x00;
    switch(color_depth) {
        case 1:
            config |= VERA_LAYER_COLOR_DEPTH_1BPP;
            break;
        case 2:
            config |= VERA_LAYER_COLOR_DEPTH_2BPP;
            break;
        case 4:
            config |= VERA_LAYER_COLOR_DEPTH_4BPP;
            break;
        case 8:
            config |= VERA_LAYER_COLOR_DEPTH_8BPP;
            break;
    }

    switch(mapwidth) {
        case 32:
            config |= VERA_LAYER_WIDTH_32;
            vera_layer_rowshift[layer] = 6;
            vera_layer_rowskip[layer] = 64;
            break;
        case 64:
            config |= VERA_LAYER_WIDTH_64;
            vera_layer_rowshift[layer] = 7;
            vera_layer_rowskip[layer] = 128;
            break;
        case 128:
            config |= VERA_LAYER_WIDTH_128;
            vera_layer_rowshift[layer] = 8;
            vera_layer_rowskip[layer] = 256;
            break;
        case 256:
            config |= VERA_LAYER_WIDTH_256;
            vera_layer_rowshift[layer] = 9;
            vera_layer_rowskip[layer] = 512;
            break;
    }
    switch(mapheight) {
        case 32:
            config |= VERA_LAYER_HEIGHT_32;
            break;
        case 64:
            config |= VERA_LAYER_HEIGHT_64;
            break;
        case 128:
            config |= VERA_LAYER_HEIGHT_128;
            break;
        case 256:
            config |= VERA_LAYER_HEIGHT_256;
            break;
    }
    vera_layer_set_config(layer, config);

    // mapbase
    vera_mapbase_offset[layer] = <mapbase_address;
    vera_mapbase_bank[layer] = (byte)(>mapbase_address);
    vera_mapbase_address[layer] = mapbase_address;

    mapbase_address = mapbase_address >> 1;
    byte mapbase = >(<mapbase_address);
    vera_layer_set_mapbase(layer,mapbase);

    // tilebase
    vera_tilebase_offset[layer] = <tilebase_address;
    vera_tilebase_bank[layer] = (byte)>tilebase_address;
    vera_tilebase_address[layer] = tilebase_address;

    tilebase_address = tilebase_address >> 1;
    byte tilebase = >(<tilebase_address);
    tilebase &= VERA_LAYER_TILEBASE_MASK;
    switch(tilewidth) {
        case 8:
            tilebase |= VERA_TILEBASE_WIDTH_8;
            break;
        case 16:
            tilebase |= VERA_TILEBASE_WIDTH_16;
            break;
    }
    switch(tileheight) {
        case 8:
            tilebase |= VERA_TILEBASE_HEIGHT_8;
            break;
        case 16:
            tilebase |= VERA_TILEBASE_HEIGHT_16;
            break;
    }
    vera_layer_set_tilebase(layer,tilebase);
}


// Set a vera layer in text mode and configure the:
// - layer: Value of 0 or 1.
// - mapbase_address: A dword typed address (4 bytes), that specifies the full address of the map base.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective mapbase vera register.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// - tilebase_address: A dword typed address (4 bytes), that specifies the base address of the tile map.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective tilebase vera register.
//   Note that the resulting vera register holds only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
// - mapwidth: The width of the map in number of tiles.
// - mapheight: The height of the map in number of tiles.
// - tilewidth: The width of a tile, which can be 8 or 16 pixels.
// - tileheight: The height of a tile, which can be 8 or 16 pixels.
// - color_mode: The color mode, which can be 16 or 256.
void vera_layer_mode_text(byte layer, dword mapbase_address, dword tilebase_address, word mapwidth, word mapheight, byte tilewidth, byte tileheight, word color_mode ) {
    vera_layer_mode_tile( layer, mapbase_address, tilebase_address, mapwidth, mapheight, tilewidth, tileheight, 1 );
    switch(color_mode) {
        case 16:
            vera_layer_set_text_color_mode( layer, VERA_LAYER_CONFIG_16C );
            break;
        case 256:
            vera_layer_set_text_color_mode( layer, VERA_LAYER_CONFIG_256C );
            break;
    }
}

// Set a vera layer in bitmap mode and configure the:
// - layer: Value of 0 or 1.
// - mapbase_address: A dword typed address (4 bytes), that specifies the full address of the map base.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective mapbase vera register.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
// - tilebase_address: A dword typed address (4 bytes), that specifies the base address of the tile map.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective tilebase vera register.
//   Note that the resulting vera register holds only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
// - mapwidth: The width of the map in number of tiles.
// - mapheight: The height of the map in number of tiles.
// - tilewidth: The width of a tile, which can be 8 or 16 pixels.
// - tileheight: The height of a tile, which can be 8 or 16 pixels.
// - color_mode: The color mode, which can be 16 or 256.
void vera_layer_mode_bitmap(byte layer, dword bitmap_address, word mapwidth, word color_depth ) {


    // config
    byte config = 0x00;
    switch(color_depth) {
        case 1:
            config |= VERA_LAYER_COLOR_DEPTH_1BPP;
            break;
        case 2:
            config |= VERA_LAYER_COLOR_DEPTH_2BPP;
            break;
        case 4:
            config |= VERA_LAYER_COLOR_DEPTH_4BPP;
            break;
        case 8:
            config |= VERA_LAYER_COLOR_DEPTH_8BPP;
            break;
    }
    config = config | VERA_LAYER_CONFIG_MODE_BITMAP;

    // tilebase
    vera_tilebase_offset[layer] = <bitmap_address;
    vera_tilebase_bank[layer] = (byte)>bitmap_address;
    vera_tilebase_address[layer] = bitmap_address;

    bitmap_address = bitmap_address >> 1;
    byte tilebase = >(<bitmap_address);
    tilebase &= VERA_LAYER_TILEBASE_MASK;

    // mapwidth
    switch(mapwidth) {
        case 320:
            vera_display_set_scale_double();
            tilebase |= VERA_TILEBASE_WIDTH_8;
            break;
        case 640:
            vera_display_set_scale_none();
            tilebase |= VERA_TILEBASE_WIDTH_16;
            break;
    }

    vera_layer_set_tilebase(layer,tilebase);
    vera_layer_set_config(layer, config);
}

// --- TILE FUNCTIONS ---

void vera_tile_area(byte layer, word tileindex, byte x, byte y, byte w, byte h, byte hflip, byte vflip, byte offset) {

    dword mapbase = vera_mapbase_address[layer];
    byte shift = vera_layer_rowshift[layer];
    word rowskip = (word)1 << shift;
    hflip = vera_layer_hflip[hflip];
    vflip = vera_layer_vflip[vflip];
    offset = offset << 4;
    byte index_l = <tileindex;
    byte index_h = >tileindex;
    index_h |= hflip;
    index_h |= vflip;
    index_h |= offset;
    mapbase += ((word)y << shift);
    mapbase += (x << 1);
    for(byte r=0; r<h; r++) {
        vera_vram_address0(mapbase,VERA_INC_1);
        for(byte c=0; c<w; c++) {
            *VERA_DATA0 = index_l;
            *VERA_DATA0 = index_h;
        }
        mapbase += rowskip;
    }

}

