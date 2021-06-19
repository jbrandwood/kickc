/// @file
/// Commodore VIC 20 registers and memory layout
/// http://sleepingelephant.com/denial/wiki/index.php?title=Memory_Map
/// http://www.zimmers.net/anonftp/pub/cbm/vic20/manuals/VIC-20_Programmers_Reference_Guide_1st_Edition_6th_Printing.pdf
#include <mos6561.h>
#include <mos6522.h>

#ifndef __VIC20__
    #error "Target platform must be VIC20"
#endif

/// Default address of screen color matrix
char * const DEFAULT_COLORRAM = (char*)0x9600;
/// Address of screen color matrix if bit 7 of $9002 is 1
char * const ALTERNATIVE_COLORRAM = (char*)0x9400;
/// Default address of screen character matrix
char * const DEFAULT_SCREEN = (char*)0x1e00;

/// The address of the CHARGEN character set
char * const CHARGEN = (char*)0x8000;

/// The MOS 6560/6561 VIC Video Interface Chip
struct MOS6561_VIC * const VIC = (struct MOS6561_VIC *)0x9000;

/// The VIA#1: User port, RS-232, Joystick, Lightpen, Cassette
struct MOS6522_VIA * const VIA1 = (struct MOS6522_VIA *)0x9110;
/// The VIA#2: Keyboard, Joystick, Cassette
struct MOS6522_VIA * const VIA2 = (struct MOS6522_VIA *)0x9120;

/// The colors of the VIC 20
const char BLACK = 0x0;
const char WHITE = 0x1;
const char RED = 0x2;
const char CYAN = 0x3;
const char PURPLE = 0x4;
const char GREEN = 0x5;
const char BLUE = 0x6;
const char YELLOW = 0x7;
const char ORANGE = 0x8;
const char LIGHT_ORANGE = 0x9;
const char PINK = 0xa;
const char LIGHT_CYAN= 0xb;
const char LIGHT_PURPLE = 0xc;
const char LIGHT_GREEN = 0xd;
const char LIGHT_BLUE = 0xe;
const char LIGHT_YELLOW = 0xf;
