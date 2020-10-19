// Atari 8-bit 400/800/XL/XE Registers and Constants
// https://en.wikipedia.org/wiki/Atari_8-bit_family

#include <atari-antic.h>
#include <atari-gtia.h>
#include <atari-pokey.h>

// Atari GTIA write registers
struct ATARI_GTIA_WRITE * const GTIA = 0xd000;

// Atari GTIA read registers
struct ATARI_GTIA_READ * const GTIA_READ = 0xd000;

// Atari POKEY write registers
struct ATARI_POKEY_WRITE * const POKEY = 0xd200;

// Atari POKEY read registers
struct ATARI_POKEY_READ * const POKEY_READ = 0xd200;

// Atari ANTIC registers
struct ATARI_ANTIC * const ANTIC = 0xd400;


// Atari ZP registers
// 1-byte cursor row
char * ROWCRS = 0x54;
// 2-byte cursor column
word * COLCRS = 0x55;
// 2-byte saved memory scan counter
char ** const SAVMSC = 0x58;
// data under cursor
char * const OLDCHR = 0x5D;
// 2-byte saved cursor memory address
char ** const OLDADR = 0x5E;

// Atari OS Shadow registers
// OS Shadow ANTIC Direct Memory Access Control ($D400)
char * const SDMCTL = 0x022f;
// OS Shadow ANTIC Character Control ($D401)
char * const CHART = 0x02f3;
// OS Shadow ANTIC Display List Pointer ($D402)
char ** const SDLST = 0x0230;
// OS Shadow ANTIC Character Set Base Address (D409)
char * CHBAS = 0x02f4;
// OS Shadow ANTIC Light Pen Horizontal Position ($D40C)
char * LPENH = 0x234;
// OS Shadow ANTIC Light Pen Vertical Position ($D40D)
char * LPENV = 0x235;
// Color register zero, color of playfield zero. Shadow for 53270 ($D016)
char * const COLOR0 = 0x2C4;
// Shadow for 53271 ($D017). Text color in Gr.0
char * const COLOR1 = 0x2C5;
// Shadow for 53272 ($D018). Background color in GR.0
char * const COLOR2 = 0x2C6;
// Shadow for 53273 ($D019)
char * const COLOR3 = 0x2C7;
// Shadow for 53274 ($D01A). Border color in GR.0
char * const COLOR4 = 0x2C8;
// Cursor inhibit flag, 0 turns on, any other number turns off. Cursor doesn't change until it moves next.
char * const CRSINH = 0x2F0;
// Internal hardware value for the last key pressed. Set to 0xFF to clear.
char * const CH = 0x2FC;

// Atari colours - names from Mapping the Atari.
// Add luminance values 0-14 (even only) to increase brightness
const char BLACK		= 0x00;
const char RUST			= 0x10;
const char RED_ORANGE	= 0x20;
const char DARK_ORANGE	= 0x30;
const char RED			= 0x40;
const char DARK_LAVENDER = 0x50;
const char COBALT_BLUE	= 0x60;
const char ULTRAMARINE	= 0x70;
const char MEDIUM_BLUE	= 0x80;
const char DARK_BLUE	= 0x90;
const char BLUE_GREY	= 0xA0;
const char OLIVE_GREEN	= 0xB0;
const char MEDIUM_GREEN = 0xC0;
const char DARK_GREEN	= 0xD0;
const char ORANGE_GREEN = 0xE0;
const char ORANGE		= 0xF0;
const char WHITE		= 0xFE;
