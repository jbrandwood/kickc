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

