// Commander X16 VERA (Versatile Embedded Retro Adapter) Video and Audio Processor
// https://github.com/commanderx16/x16-docs/blob/master/VERA%20Programmer's%20Reference.md

// Author: Sven Van de Velde

#include <cx16.h>
#include <veralib.h>

// --- VERA function encapsulation ---

// --- VERA layer management ---


// --- VERA addressing ---

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

// --- VERA layer management ---

// Set the configuration of the layer.
// - layer: Value of 0 or 1.
// - config: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
void vera_layer_set_config(char layer, char config) {
    layer &= $1;
    char* addr = vera_layer_config[layer];
    *addr = config;
}

// Set the configuration of the layer.
// - layer: Value of 0 or 1.
// - config: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
char vera_layer_get_config(char layer) {
    char* config = vera_layer_config[layer];
    return *config;
}

// Set the map width or height of the layer.
// - layer: Value of 0 or 1.
inline void vera_layer_set_width_32(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_WIDTH_MASK;
    *addr |= VERA_LAYER_WIDTH_32;
}
inline void vera_layer_set_width_64(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    //*addr &= (~VERA_CONFIG_WIDTH_MASK) | VERA_CONFIG_WIDTH_64;
    *addr &= ~VERA_LAYER_WIDTH_MASK;
    *addr |= VERA_LAYER_WIDTH_64;
}
inline void vera_layer_set_width_128(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_WIDTH_MASK;
    *addr |= VERA_LAYER_WIDTH_128;
}
inline void vera_layer_set_width_256(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_WIDTH_MASK;
    *addr |= VERA_LAYER_WIDTH_256;
}
inline void vera_layer_set_height_32(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_HEIGHT_MASK;
    *addr |= VERA_LAYER_HEIGHT_32;
}
inline void vera_layer_set_height_64(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_HEIGHT_MASK;
    *addr |= VERA_LAYER_HEIGHT_64;
}
inline void vera_layer_set_height_128(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_HEIGHT_MASK;
    *addr |= VERA_LAYER_HEIGHT_128;
}
inline void vera_layer_set_height_256(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_HEIGHT_MASK;
    *addr |= VERA_LAYER_HEIGHT_256;
}

// Get the map width or height of the layer.
// - layer: Value of 0 or 1.
word vera_layer_get_width(unsigned byte layer) {
    byte* config = vera_layer_config[layer];
    byte mask = (byte)VERA_LAYER_WIDTH_MASK;
    return VERA_LAYER_WIDTH[ (*config & mask) >> 4];
}

word vera_layer_get_height(unsigned byte layer) {
    byte* config = vera_layer_config[layer];
    byte mask = VERA_LAYER_HEIGHT_MASK;
    return VERA_LAYER_HEIGHT[ (*config & mask) >> 6];
}

// Set the color depth of the layer in terms of bit per pixel (BPP) of the tile base.
// - layer: Value of 0 or 1.
inline void vera_layer_set_color_depth_1BPP(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *addr |= VERA_LAYER_COLOR_DEPTH_1BPP;
}
inline void vera_layer_set_color_depth_2BPP(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *addr |= VERA_LAYER_COLOR_DEPTH_2BPP;
}
inline void vera_layer_set_color_depth_4BPP(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *addr |= VERA_LAYER_COLOR_DEPTH_4BPP;
}
inline void vera_layer_set_color_depth_8BPP(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *addr |= VERA_LAYER_COLOR_DEPTH_8BPP;
}

// Get the map width or height of the layer.
// - layer: Value of 0 or 1.
// - return: 1, 2, 4 or 8.
word vera_layer_get_color_depth(unsigned byte layer) {
    byte* config = vera_layer_config[layer];
    byte mask = (byte)VERA_LAYER_COLOR_DEPTH_MASK;
    return VERA_LAYER_COLOR_DEPTH[(*config & mask)];
}

// Enable the layer to be displayed on the screen.
// - layer: 0 or 1.
inline void vera_layer_show(char layer) {
    *VERA_DC_VIDEO |= vera_layer_enable[layer];
}


// Disable the layer to be displayed on the screen.
// - layer: 0 or 1.
inline void vera_layer_hide(char layer) {
    *VERA_DC_VIDEO &= ~vera_layer_enable[layer];
}


// Is the layer shown on the screen?
// - returns: 1 if layer is displayed on the screen, 0 if not.
char vera_layer_is_visible(char layer) {
    return *VERA_DC_VIDEO & vera_layer_enable[layer];
}

// Set the base of the map layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - mapbase: Specifies the base address of the tile map.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
void vera_layer_set_mapbase(unsigned byte layer, unsigned byte mapbase) {
    unsigned byte* addr = vera_layer_mapbase[layer];
    *addr = mapbase;
}

// Set the base of the map layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - dw_mapbase: a dword typed address (4 bytes), that specifies the full address of the map base.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective mapbase vera register.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
void vera_layer_set_mapbase_address(byte layer, dword dw_mapbase) {

    dw_mapbase = dw_mapbase & 0x1FF00; // Aligned to 2048 bit zones.
    byte bank_mapbase = (byte)>dw_mapbase;
    word offset_mapbase = <dw_mapbase;

    vera_mapbase_address[layer] = dw_mapbase;
    vera_mapbase_offset[layer] = offset_mapbase;
    vera_mapbase_bank[layer] = bank_mapbase;

    byte mapbase = >(<(dw_mapbase>>1));
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
unsigned byte vera_layer_get_mapbase(unsigned byte layer) {
    unsigned byte* mapbase = vera_layer_mapbase[layer];
    return *mapbase;
}

// Set the base of the tiles for the layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - tilebase: Specifies the base address of the tile map.
//   Note that the register only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
void vera_layer_set_tilebase(unsigned byte layer, unsigned byte tilebase) {
    unsigned byte* addr = vera_layer_tilebase[layer];
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
// - dw_tilebase: a dword typed address (4 bytes), that specifies the base address of the tile map.
//   The function does the translation from the dword that contains the 17 bit address,
//   to the respective tilebase vera register.
//   Note that the resulting vera register holds only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
void vera_layer_set_tilebase_address(byte layer, dword dw_tilebase) {

    dw_tilebase = dw_tilebase & 0x1FC00; // Aligned to 2048 bit zones.
    byte bank_tilebase = (byte)>dw_tilebase;
    word word_tilebase = <dw_tilebase;

    vera_tilebase_address[layer] = dw_tilebase;
    vera_tilebase_offset[layer] = word_tilebase;
    vera_tilebase_bank[layer] = bank_tilebase;

    byte* vera_tilebase = vera_layer_tilebase[layer];
    byte tilebase = >(<(dw_tilebase>>1));
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
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
unsigned byte vera_layer_set_textcolor(unsigned byte layer, unsigned byte color) {
    unsigned byte old = vera_layer_textcolor[layer];
    vera_layer_textcolor[layer] = color;
    return old;
}

// Get the front color for text output. The old front text color setting is returned.
// - layer: Value of 0 or 1.
// - return: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
unsigned byte vera_layer_get_textcolor(unsigned byte layer) {
    layer &= $1;
    return vera_layer_textcolor[layer];
}

// Set the back color for text output. The old back text color setting is returned.
// - layer: Value of 0 or 1.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
unsigned byte vera_layer_set_backcolor(unsigned byte layer, unsigned byte color) {
    layer &= $1;
    unsigned byte old = vera_layer_backcolor[layer];
    vera_layer_backcolor[layer] = color;
    return old;
}

// Get the back color for text output. The old back text color setting is returned.
// - layer: Value of 0 or 1.
// - return: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
unsigned byte vera_layer_get_backcolor(unsigned byte layer) {
    layer &= $1;
    return vera_layer_backcolor[layer];
}

// Get the text and back color for text output in 16 color mode.
// - layer: Value of 0 or 1.
// - return: an 8 bit value with bit 7:4 containing the back color and bit 3:0 containing the front color.
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
unsigned byte vera_layer_get_color(unsigned byte layer) {
    layer &= $1;
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


void vera_layer_mode_tile(byte layer, dword mapbase_address, dword dw_tilebase, word mapwidth, word mapheight, byte tilewidth, byte tileheight, byte color_depth ) {
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


    //printf("%lx\n",dw_mapbase);

     // tilebase
    vera_tilebase_offset[layer] = <dw_tilebase;
    vera_tilebase_bank[layer] = (byte)>dw_tilebase;
    vera_tilebase_address[layer] = dw_tilebase;

    //printf("tilebase word = %x\n",vera_tilebase_offset[layer]);
    //printf("tilebase bank = %x\n",vera_tilebase_bank[layer]);
    //printf("tilebase dword = %lx\n",vera_tilebase_address[layer]);

    dw_tilebase = dw_tilebase >> 1;
    byte tilebase = >(<dw_tilebase);
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
    //printf("tilebase = %x\n",tilebase);
    vera_layer_set_tilebase(layer,tilebase);
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

