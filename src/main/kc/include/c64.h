// Commodore 64 Registers and Constants
#include <mos6526.h>
#include <mos6581.h>

// Processor port data direction register
char*  const PROCPORT_DDR = $00;
// Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
const char PROCPORT_DDR_MEMORY_MASK = %00000111;

// Processor Port Register controlling RAM/ROM configuration and the datasette
char*  const PROCPORT = $01;
// RAM in all three areas $A000, $D000, $E000
const char PROCPORT_RAM_ALL         = %00000000;
// RAM in $A000, $E000 I/O in $D000
const char PROCPORT_RAM_IO          = %00000101;
// RAM in $A000, $E000 CHAR ROM in $D000
const char PROCPORT_RAM_CHARROM     = %00000001;
// RAM in $A000, I/O in $D000, KERNEL in $E000
const char PROCPORT_KERNEL_IO       = %00000110;
// BASIC in $A000, I/O in $D000, KERNEL in $E000
const char PROCPORT_BASIC_KERNEL_IO = %00000111;

// The address of the CHARGEN character set
char*  const CHARGEN = $d000;

// Positions of the border (in sprite positions)
const char BORDER_XPOS_LEFT=24;
const unsigned int BORDER_XPOS_RIGHT=344;
const char BORDER_YPOS_TOP=50;
const char BORDER_YPOS_BOTTOM=250;

// The offset of the sprite pointers from the screen start address
const unsigned int SPRITE_PTRS = $3f8;

char*  const SPRITES_XPOS = $d000;
char*  const SPRITES_YPOS = $d001;
char*  const SPRITES_XMSB = $d010;
char*  const RASTER = $d012;
char*  const SPRITES_ENABLE = $d015;
char*  const SPRITES_EXPAND_Y = $d017;
char*  const SPRITES_PRIORITY = $d01b;
char*  const SPRITES_MC = $d01c;
char*  const SPRITES_EXPAND_X = $d01d;
char*  const BORDERCOL = $d020;
char*  const BGCOL = $d021;
char*  const BGCOL1 = $d021;
char*  const BGCOL2 = $d022;
char*  const BGCOL3 = $d023;
char*  const BGCOL4 = $d024;
char*  const SPRITES_MC1 = $d025;
char*  const SPRITES_MC2 = $d026;
char*  const SPRITES_COLS = $d027;

char*  const VIC_CONTROL = $d011;
char*  const D011 = $d011;
const char VIC_RST8 = %10000000;
const char VIC_ECM =  %01000000;
const char VIC_BMM =  %00100000;
const char VIC_DEN =  %00010000;
const char VIC_RSEL = %00001000;

char*  const VIC_CONTROL2 = $d016;
char*  const D016 = $d016;
const char VIC_MCM =  %00010000;
const char VIC_CSEL = %00001000;

char*  const D018 = $d018;
char*  const VIC_MEMORY = $d018;

char*  const LIGHTPEN_X = $d013;
char*  const LIGHTPEN_Y = $d014;

// VIC II IRQ Status Register
char*  const IRQ_STATUS = $d019;
// VIC II IRQ Enable Register
char*  const IRQ_ENABLE = $d01a;
// Bits for the IRQ Status/Enable Registers
const char IRQ_RASTER = %00000001;
const char IRQ_COLLISION_BG = %00000010;
const char IRQ_COLLISION_SPRITE = %00000100;
const char IRQ_LIGHTPEN = %00001000;

// Color Ram
char*  const COLS = $d800;

// The CIA#1: keyboard matrix, joystick #1/#2
struct MOS6526_CIA * const CIA1 = 0xdc00;
// The CIA#2: Serial bus, RS-232, VIC memory bank
struct MOS6526_CIA * const CIA2 = 0xdd00;
// CIA#1 Interrupt for reading in ASM
char * const CIA1_INTERRUPT = 0xdc0d;
// CIA#2 timer A&B as one single 32-bit value
unsigned long* const CIA2_TIMER_AB = 0xdd04;
// CIA#2 Interrupt for reading in ASM
char * const CIA2_INTERRUPT = 0xdd0d;

// The SID MOD 6581/8580
struct MOS6581_SID * const SID = 0xd400;

// The vector used when the KERNAL serves IRQ interrupts
void()** const KERNEL_IRQ = $0314;
// The vector used when the KERNAL serves NMI interrupts
void()** const KERNEL_NMI = $0318;

// The vector used when the HARDWARE serves IRQ interrupts
void()** const HARDWARE_IRQ = $fffe;

// The colors of the C64
const char BLACK = $0;
const char WHITE = $1;
const char RED = $2;
const char CYAN = $3;
const char PURPLE = $4;
const char GREEN = $5;
const char BLUE = $6;
const char YELLOW = $7;
const char ORANGE = $8;
const char BROWN = $9;
const char PINK = $a;
const char DARK_GREY= $b;
const char GREY = $c;
const char LIGHT_GREEN = $d;
const char LIGHT_BLUE = $e;
const char LIGHT_GREY = $f;

// Get the value to store into D018 to display a specific screen and charset/bitmap
// Optimized for ASM from (char)((((unsigned int)screen&0x3fff)/$40)|(((unsigned int)charset&$3fff)/$400));
char toD018(char*  screen, char*  gfx);

// Get the value to store into DD00 (CIA 2 port A) to choose a specific VIC bank
// Optimized for ASM from %00000011 ^ (char)((unsigned int)gfx/$4000)
char toDd00(char*  gfx);

// Get the sprite pointer for a sprite.
// The sprite pointer is the index of the sprite within the graphics bank and equal to the sprite (char)(sprite_addr/64)
// The sprite pointers are stored SCREEN+$3f8+sprite_id to set the pointer of each sprite
char toSpritePtr(char*  sprite);

// Select a specific VIC graphics bank by setting the CIA 2 port A ($dd00) as needed
void vicSelectGfxBank(char*  gfx);

// Initialize SID voice 3 for random number generation
void sid_rnd_init();

// Get a random number from the SID voice 3,
// Must be initialized with sid_rnd_init()
char sid_rnd();



