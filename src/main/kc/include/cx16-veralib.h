/// @file
/// Commander X16 VERA (Versatile Embedded Retro Adapter) Video and Audio Processor
///
/// https://github.com/commanderx16/x16-docs/blob/master/VERA%20Programmer's%20Reference.md
/// Author: Sven Van de Velde

#include <cx16-vera.h>

/// --- VERA function encapsulation ---

__ma word  vera_mapbase_offset[2] = {0,0};
__ma byte  vera_mapbase_bank[2] = {0,0};
__ma dword vera_mapbase_address[2] = {0,0};

word  vera_tilebase_offset[2] = {0,0};
byte  vera_tilebase_bank[2] = {0,0};
dword vera_tilebase_address[2] = {0,0};

byte vera_layer_rowshift[2] = {0,0};
word vera_layer_rowskip[2] = {0,0};

const byte vera_layer_hflip[2] = {0,0x04};
const byte vera_layer_vflip[2] = {0,0x08};


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

byte hscale[4] = {0,128,64,32};

/// --- VERA addressing ---

inline void vera_vram_bank_offset(byte bank, word offset, byte incr);
inline void vera_vram_address0(dword bankaddr, byte incr);
inline void vera_vram_address1(dword bankaddr, byte incr);

/// --- VERA active display management ---

inline void vera_display_set_scale_none();
inline void vera_display_set_scale_double();
inline void vera_display_set_scale_triple();
byte vera_display_get_hscale();
byte vera_display_get_vscale();
word vera_display_get_height();
word vera_display_get_width();

/// --- VERA LAYERS ---

/// Set the configuration of the layer.
/// - layer: Value of 0 or 1.
/// - config: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
void vera_layer_set_config(byte layer, byte config);


/// Get the configuration of the layer.
/// - layer: Value of 0 or 1.
/// - return: Specifies the modes which are specified using T256C / 'Bitmap Mode' / 'Color Depth'.
byte vera_layer_get_config(byte layer);


/// Set the configuration of the layer text color mode.
/// - layer: Value of 0 or 1.
/// - color_mode: Specifies the color mode to be VERA_LAYER_CONFIG_16 or VERA_LAYER_CONFIG_256 for text mode.
void vera_layer_set_text_color_mode( byte layer, byte color_mode );

/// Set the configuration of the layer to bitmap mode.
/// - layer: Value of 0 or 1.
void vera_layer_set_bitmap_mode( byte layer );

/// Set the configuration of the layer to tilemap mode.
/// - layer: Value of 0 or 1.
void vera_layer_set_tilemap_mode( byte layer );

/// Set the map width or height of the layer.
/// - layer: Value of 0 or 1.
inline void vera_layer_set_width_32(byte layer);
inline void vera_layer_set_width_64(byte layer);
inline void vera_layer_set_width_128(byte layer);
inline void vera_layer_set_width_256(byte layer);
inline void vera_layer_set_height_32(byte layer);
inline void vera_layer_set_height_64(byte layer);
inline void vera_layer_set_height_128(byte layer);
inline void vera_layer_set_height_256(byte layer);

/// Get the map width of the layer.
/// - layer: Value of 0 or 1.
inline word vera_layer_get_width(byte layer);

/// Get the map height of the layer.
/// - layer: Value of 0 or 1.
inline word vera_layer_get_height(byte layer);


/// Set the color depth of the layer in bit per pixel (BPP) to 1.
/// - layer: Value of 0 or 1.
inline void vera_layer_set_color_depth_1BPP(byte layer);

/// Set the color depth of the layer in bit per pixel (BPP) to 1.
/// - layer: Value of 0 or 1.
inline void vera_layer_set_color_depth_2BPP(byte layer);

/// Set the color depth of the layer in bit per pixel (BPP) to 1.
/// - layer: Value of 0 or 1.
inline void vera_layer_set_color_depth_4BPP(byte layer);

/// Set the color depth of the layer in bit per pixel (BPP) to 1.
/// - layer: Value of 0 or 1.
inline void vera_layer_set_color_depth_8BPP(byte layer);

/// Get the color depth of the layer.
/// - layer: Value of 0 or 1.
/// - return: 0 = 1 color, 1 = 2 colors, 2 = 4 colors or 3 = 8 colors.
inline byte vera_layer_get_color_depth(byte layer);

/// Enable the layer to be displayed on the screen.
/// - layer: 0 or 1.
inline void vera_layer_show(byte layer);

/// Disable the layer to be displayed on the screen.
/// - layer: 0 or 1.
inline void vera_layer_hide(byte layer);

/// Is the layer shown on the screen?
/// - returns: 1 if layer is displayed on the screen, 0 if not.
inline byte vera_layer_is_visible(byte layer);


/// Set the base of the map layer with which the conio will interact.
/// - layer: Value of 0 or 1.
/// - mapbase: Specifies the base address of the tile map.
///   Note that the register only specifies bits 16:9 of the address,
///   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
void vera_layer_set_mapbase(byte layer, byte mapbase);

/// Set the base of the map layer with which the conio will interact.
/// - layer: Value of 0 or 1.
/// - mapbase_address: a dword typed address (4 bytes), that specifies the full address of the map base.
///   The function does the translation from the dword that contains the 17 bit address,
///   to the respective mapbase vera register.
///   Note that the register only specifies bits 16:9 of the address,
///   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
void vera_layer_set_mapbase_address(byte layer, dword mapbase_address);

/// Get the base of the map layer with which the conio will interact.
/// - layer: Value of 0 or 1.
/// - return: Returns the base address of the tile map.
///   Note that the register is a byte, specifying only bits 16:9 of the address,
///   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
byte vera_layer_get_mapbase(byte layer);

/// Get the map base address of the tiles for the layer.
/// - layer: Value of 0 or 1.
/// - return: Specifies the map base address of the layer, which is returned as a dword.
///   Note that the register only specifies bits 16:9 of the 17 bit address,
///   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes!
dword vera_layer_get_mapbase_address(byte layer);

/// Get the map base bank of the tiles for the layer.
/// - layer: Value of 0 or 1.
/// - return: Bank in vera vram.
byte vera_layer_get_mapbase_bank(byte layer);

/// Get the map base lower 16-bit address (offset) of the tiles for the layer.
/// - layer: Value of 0 or 1.
/// - return: Offset in vera vram of the specified bank.
word vera_layer_get_mapbase_offset(byte layer);





/// Set the base of the tiles for the layer with which the conio will interact.
/// - layer: Value of 0 or 1.
/// - tilebase: Specifies the base address of the tile map.
///   Note that the register only specifies bits 16:11 of the address,
///   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
void vera_layer_set_tilebase(byte layer, byte tilebase);

/// Set the base address of the tiles for the layer with which the conio will interact.
/// - layer: Value of 0 or 1.
/// - tilebase_address: a dword typed address (4 bytes), that specifies the base address of the tile map.
///   The function does the translation from the dword that contains the 17 bit address,
///   to the respective tilebase vera register.
///   Note that the resulting vera register holds only specifies bits 16:11 of the address,
///   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
void vera_layer_set_tilebase_address(byte layer, dword tilebase_address);

/// Get the base of the tiles for the layer with which the conio will interact.
/// - layer: Value of 0 or 1.
/// - return: Specifies the base address of the tile map.
///   Note that the register only specifies bits 16:11 of the address,
///   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
byte vera_layer_get_tilebase(byte layer);

/// Get the tile base address of the tiles for the layer.
/// - layer: Value of 0 or 1.
/// - return: Specifies the base address of the tile map, which is calculated as an unsigned long int.
///   Note that the register only specifies bits 16:11 of the address,
///   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
dword vera_layer_get_tilebase_address(byte layer);

/// --- VERA layer color management ---

/// Set the front color for text output. The old front text color setting is returned.
/// - layer: Value of 0 or 1.
/// - color: a 4 bit value ( decimal between 0 and 15) when the VERA works in 16x16 color text mode.
///   An 8 bit value (decimal between 0 and 255) when the VERA works in 256 text mode.
///   Note that on the VERA, the transparent color has value 0.
byte vera_layer_set_textcolor(byte layer, byte color);

/// Get the front color for text output. The old front text color setting is returned.
/// - layer: Value of 0 or 1.
/// - return: a 4 bit value ( decimal between 0 and 15).
///   This will only work when the VERA is in 16 color mode!
///   Note that on the VERA, the transparent color has value 0.
byte vera_layer_get_textcolor(byte layer);

/// Set the back color for text output. The old back text color setting is returned.
/// - layer: Value of 0 or 1.
/// - color: a 4 bit value ( decimal between 0 and 15).
///   This will only work when the VERA is in 16 color mode!
///   Note that on the VERA, the transparent color has value 0.
byte vera_layer_set_backcolor(byte layer, byte color);

/// Get the back color for text output. The old back text color setting is returned.
/// - layer: Value of 0 or 1.
/// - return: a 4 bit value ( decimal between 0 and 15).
///   This will only work when the VERA is in 16 color mode!
///   Note that on the VERA, the transparent color has value 0.
byte vera_layer_get_backcolor(byte layer);

/// Get the text and back color for text output in 16 color mode.
/// - layer: Value of 0 or 1.
/// - return: an 8 bit value with bit 7:4 containing the back color and bit 3:0 containing the front color.
///   This will only work when the VERA is in 16 color mode!
///   Note that on the VERA, the transparent color has value 0.
byte vera_layer_get_color(byte layer);

/// Scroll the horizontal (X) axis of the layer visible area over the layer tile map area.
/// - layer: Value of 0 or 1.
/// - scroll: A value between 0 and 4096.
inline void vera_layer_set_horizontal_scroll(byte layer, word scroll);

/// Scroll the vertical (Y) axis of the layer visible area over the layer tile map area.
/// - layer: Value of 0 or 1.
/// - scroll: A value between 0 and 4096.
inline void vera_layer_set_vertical_scroll(byte layer, word scroll);

/// --- VERA layer technical functions to quickly shift rows.

/// Get the bit shift value required to skip a whole line fast.
/// - layer: Value of 0 or 1.
/// - return: Rowshift value to calculate fast from a y value to line offset in tile mode.
byte vera_layer_get_rowshift(byte layer);

/// Get the value required to skip a whole line fast.
/// - layer: Value of 0 or 1.
/// - return: Skip value to calculate fast from a y value to line offset in tile mode.
word vera_layer_get_rowskip(byte layer);


/// Set a vera layer in tile mode and configure the:
/// - layer: Value of 0 or 1.
/// - mapbase_address: A dword typed address (4 bytes), that specifies the full address of the map base.
///   The function does the translation from the dword that contains the 17 bit address,
///   to the respective mapbase vera register.
///   Note that the register only specifies bits 16:9 of the address,
///   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
/// - tilebase_address: A dword typed address (4 bytes), that specifies the base address of the tile map.
///   The function does the translation from the dword that contains the 17 bit address,
///   to the respective tilebase vera register.
///   Note that the resulting vera register holds only specifies bits 16:11 of the address,
///   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
/// - mapwidth: The width of the map in number of tiles.
/// - mapheight: The height of the map in number of tiles.
/// - tilewidth: The width of a tile, which can be 8 or 16 pixels.
/// - tileheight: The height of a tile, which can be 8 or 16 pixels.
/// - color_depth: The color depth in bits per pixel (BPP), which can be 1, 2, 4 or 8.
void vera_layer_mode_tile(byte layer, dword mapbase_address, dword tilebase_address, word mapwidth, word mapheight, byte tilewidth, byte tileheight, byte color_depth );


/// Set a vera layer in text mode and configure the:
/// - layer: Value of 0 or 1.
/// - mapbase_address: A dword typed address (4 bytes), that specifies the full address of the map base.
///   The function does the translation from the dword that contains the 17 bit address,
///   to the respective mapbase vera register.
///   Note that the register only specifies bits 16:9 of the address,
///   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
/// - tilebase_address: A dword typed address (4 bytes), that specifies the base address of the tile map.
///   The function does the translation from the dword that contains the 17 bit address,
///   to the respective tilebase vera register.
///   Note that the resulting vera register holds only specifies bits 16:11 of the address,
///   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
/// - mapwidth: The width of the map in number of tiles.
/// - mapheight: The height of the map in number of tiles.
/// - tilewidth: The width of a tile, which can be 8 or 16 pixels.
/// - tileheight: The height of a tile, which can be 8 or 16 pixels.
/// - color_mode: The color mode, which can be 16 or 256.
void vera_layer_mode_text(byte layer, dword mapbase_address, dword tilebase_address, word mapwidth, word mapheight, byte tilewidth, byte tileheight, word color_mode );

/// Set a vera layer in bitmap mode and configure the:
/// - layer: Value of 0 or 1.
/// - mapbase_address: A dword typed address (4 bytes), that specifies the full address of the map base.
///   The function does the translation from the dword that contains the 17 bit address,
///   to the respective mapbase vera register.
///   Note that the register only specifies bits 16:9 of the address,
///   so the resulting address in the VERA VRAM is always aligned to a multiple of 512 bytes.
/// - tilebase_address: A dword typed address (4 bytes), that specifies the base address of the tile map.
///   The function does the translation from the dword that contains the 17 bit address,
///   to the respective tilebase vera register.
///   Note that the resulting vera register holds only specifies bits 16:11 of the address,
///   so the resulting address in the VERA VRAM is always aligned to a multiple of 2048 bytes!
/// - mapwidth: The width of the map in number of tiles.
/// - mapheight: The height of the map in number of tiles.
/// - tilewidth: The width of a tile, which can be 8 or 16 pixels.
/// - tileheight: The height of a tile, which can be 8 or 16 pixels.
/// - color_mode: The color mode, which can be 16 or 256.
void vera_layer_mode_bitmap(byte layer, dword bitmap_address, word mapwidth, word color_depth );

