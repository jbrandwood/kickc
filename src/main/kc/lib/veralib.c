// Commander X16 VERA (Versatile Embedded Retro Adapter) Video and Audio Processor
// https://github.com/commanderx16/x16-docs/blob/master/VERA%20Programmer's%20Reference.md

// Author: Sven Van de Velde

#include <cx16.h>
#include <veralib.h>

// --- VERA function encapsulation ---

// --- VERA layer management ---
byte* vera_layer_config[2] = {VERA_L0_CONFIG, VERA_L1_CONFIG};
byte vera_layer_enable[2] = { VERA_LAYER0_ENABLE, VERA_LAYER1_ENABLE };

byte* vera_layer_mapbase[2] = {VERA_L0_MAPBASE, VERA_L1_MAPBASE};
byte* vera_layer_tilebase[2] = {VERA_L0_TILEBASE, VERA_L1_TILEBASE};
byte* vera_layer_vscroll_l[2] = {VERA_L0_VSCROLL_L, VERA_L1_VSCROLL_L};
byte* vera_layer_vscroll_h[2] = {VERA_L0_VSCROLL_H, VERA_L1_VSCROLL_H};
byte* vera_layer_hscroll_l[2] = {VERA_L0_HSCROLL_L, VERA_L1_HSCROLL_L};
byte* vera_layer_hscroll_h[2] = {VERA_L0_HSCROLL_H, VERA_L1_HSCROLL_H};

byte vera_layer_textcolor[2] = {WHITE, WHITE};
byte vera_layer_backcolor[2] = {BLUE, BLUE};

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
void vera_set_layer_config(char layer, char config) {
    layer &= $1;
    char* addr = vera_layer_config[layer];
    *addr = config;
}

// Set the configuration of the layer.
// - layer: Value of 0 or 1.
// - config: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
char vera_get_layer_config(char layer) {
    layer &= $1;
    char* config = vera_layer_config[layer];
    return *config;
}

// Set the map width or height of the layer.
// - layer: Value of 0 or 1.
inline void vera_set_layer_map_width_32(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_CONFIG_WIDTH_MASK;
    *addr |= VERA_LAYER_CONFIG_WIDTH_32;
}
inline void vera_set_layer_map_width_64(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    //*addr &= (~VERA_CONFIG_WIDTH_MASK) | VERA_CONFIG_WIDTH_64;
    *addr &= ~VERA_LAYER_CONFIG_WIDTH_MASK;
    *addr |= VERA_LAYER_CONFIG_WIDTH_64;
}
inline void vera_set_layer_map_width_128(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_CONFIG_WIDTH_MASK;
    *addr |= VERA_LAYER_CONFIG_WIDTH_128;
}
inline void vera_set_layer_map_width_256(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_CONFIG_WIDTH_MASK;
    *addr |= VERA_LAYER_CONFIG_WIDTH_256;
}
inline void vera_set_layer_map_height_32(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_CONFIG_HEIGHT_MASK;
    *addr |= VERA_LAYER_CONFIG_HEIGHT_32;
}
inline void vera_set_layer_map_height_64(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_CONFIG_HEIGHT_MASK;
    *addr |= VERA_LAYER_CONFIG_HEIGHT_64;
}
inline void vera_set_layer_map_height_128(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_CONFIG_HEIGHT_MASK;
    *addr |= VERA_LAYER_CONFIG_HEIGHT_128;
}
inline void vera_set_layer_map_height_256(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_CONFIG_HEIGHT_MASK;
    *addr |= VERA_LAYER_CONFIG_HEIGHT_256;
}

// Get the map width or height of the layer.
// - layer: Value of 0 or 1.
word vera_get_layer_map_width(unsigned byte layer) {
    byte* config = vera_layer_config[layer];
    byte mask = (byte)VERA_LAYER_CONFIG_WIDTH_MASK;
    return VERA_LAYER_CONFIG_WIDTH[ (*config & mask) >> 4];
}

word vera_get_layer_map_height(unsigned byte layer) {
    byte* config = vera_layer_config[layer];
    byte mask = VERA_LAYER_CONFIG_HEIGHT_MASK;
    return VERA_LAYER_CONFIG_HEIGHT[ (*config & mask) >> 6];
}

// Set the color depth of the layer in terms of bit per pixel (BPP) of the tile base.
// - layer: Value of 0 or 1.
inline void vera_set_layer_color_depth_1BPP(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *addr |= VERA_LAYER_COLOR_DEPTH_1BPP;
}
inline void vera_set_layer_color_depth_2BPP(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *addr |= VERA_LAYER_COLOR_DEPTH_2BPP;
}
inline void vera_set_layer_color_depth_4BPP(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *addr |= VERA_LAYER_COLOR_DEPTH_4BPP;
}
inline void vera_set_layer_color_depth_8BPP(unsigned byte layer) {
    byte* addr = vera_layer_config[layer];
    *addr &= ~VERA_LAYER_COLOR_DEPTH_MASK;
    *addr |= VERA_LAYER_COLOR_DEPTH_8BPP;
}

// Get the map width or height of the layer.
// - layer: Value of 0 or 1.
// - return: 1, 2, 4 or 8.
word vera_get_layer_color_depth(unsigned byte layer) {
    byte* config = vera_layer_config[layer];
    byte mask = (byte)VERA_LAYER_COLOR_DEPTH_MASK;
    return VERA_LAYER_COLOR_DEPTH[(*config & mask)];
}

// Enable the layer to be displayed on the screen.
// - layer: 0 or 1.
inline void vera_show_layer(char layer) {
    *VERA_DC_VIDEO |= vera_layer_enable[layer];
}


// Disable the layer to be displayed on the screen.
// - layer: 0 or 1.
inline void vera_hide_layer(char layer) {
    *VERA_DC_VIDEO &= ~vera_layer_enable[layer];
}


// Is the layer shown on the screen?
// - returns: 1 if layer is displayed on the screen, 0 if not.
char vera_is_layer_shown(char layer) {
    layer &= $1;
    return *VERA_DC_VIDEO & vera_layer_enable[layer];
}

// Set the base of the map layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - mapbase: Specifies the base address of the tile map.
//   Note that the register only specifies bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
void vera_set_layer_mapbase(unsigned byte layer, unsigned byte mapbase) {
    layer &= $1;
    unsigned byte* addr = vera_layer_mapbase[layer];
    *addr = mapbase;
}

// Get the base of the map layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - return: Returns the base address of the tile map.
//   Note that the register is a byte, specifying only bits 16:9 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
unsigned byte vera_get_layer_mapbase(unsigned byte layer) {
    layer &= $1;
    unsigned byte* mapbase = vera_layer_mapbase[layer];
    return *mapbase;
}

// Set the base of the tiles for the layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - tilebase: Specifies the base address of the tile map.
//   Note that the register only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
void vera_set_layer_tilebase(unsigned byte layer, unsigned byte tilebase) {
    layer &= $1;
    unsigned byte* addr = vera_layer_tilebase[layer];
    *addr = tilebase;
}

// Get the base of the tiles for the layer with which the conio will interact.
// - layer: Value of 0 or 1.
// - return: Specifies the base address of the tile map.
//   Note that the register only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
unsigned byte vera_get_layer_tilebase(unsigned byte layer) {
    layer &= $1;
    unsigned byte* tilebase = vera_layer_tilebase[layer];
    return *tilebase;
}

// Get the tile base address of the tiles for the layer.
// - layer: Value of 0 or 1.
// - return: Specifies the base address of the tile map, which is calculated as an unsigned long int.
//   Note that the register only specifies bits 16:11 of the address,
//   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
dword vera_get_layer_tilebase_address(byte layer) {
    layer &= $1;
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
unsigned byte vera_set_layer_textcolor(unsigned byte layer, unsigned byte color) {
    layer &= $1;
    unsigned byte old = vera_layer_textcolor[layer];
    vera_layer_textcolor[layer] = color;
    return old;
}

// Get the front color for text output. The old front text color setting is returned.
// - layer: Value of 0 or 1.
// - return: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
unsigned byte vera_get_layer_textcolor(unsigned byte layer) {
    layer &= $1;
    return vera_layer_textcolor[layer];
}

// Set the back color for text output. The old back text color setting is returned.
// - layer: Value of 0 or 1.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
unsigned byte vera_set_layer_backcolor(unsigned byte layer, unsigned byte color) {
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
unsigned byte vera_get_layer_backcolor(unsigned byte layer) {
    layer &= $1;
    return vera_layer_backcolor[layer];
}

// Get the text and back color for text output in 16 color mode.
// - layer: Value of 0 or 1.
// - return: an 8 bit value with bit 7:4 containing the back color and bit 3:0 containing the front color.
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
unsigned byte vera_get_layer_color(unsigned byte layer) {
    layer &= $1;
    return ((vera_layer_backcolor[layer] << 4) | vera_layer_textcolor[layer]);
}


// Scroll the horizontal (X) axis of the layer visible area over the layer tile map area.
// - layer: Value of 0 or 1.
// - scroll: A value between 0 and 4096.
inline void vera_set_layer_horizontal_scroll(byte layer, word scroll) {
    *vera_layer_hscroll_l[layer] = <scroll;
    *vera_layer_hscroll_h[layer] = >scroll;
}

// Scroll the vertical (Y) axis of the layer visible area over the layer tile map area.
// - layer: Value of 0 or 1.
// - scroll: A value between 0 and 4096.
inline void vera_set_layer_vertical_scroll(byte layer, word scroll) {
    *vera_layer_vscroll_l[layer] = <scroll;
    *vera_layer_vscroll_h[layer] = >scroll;
}
