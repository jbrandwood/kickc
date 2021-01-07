// Commander X16
// https://www.commanderx16.com/forum/index.php?/about-faq/
// https://github.com/commanderx16/x16-docs/blob/master/Commander%20X16%20Programmer's%20Reference%20Guide.md

#include <cx16-vera.h>
#include <mos6522.h>

// The VIA#1: ROM/RAM Bank Control
// Port A Bits 0-7 RAM bank
// Port B Bits 0-2 ROM bank
// Port B Bits 3-7 [TBD]
struct MOS6522_VIA * const VIA1 = 0x9f60;
// The VIA#2: Keyboard/Joy/Mouse
// Port A Bit  0   KBD PS/2 DAT
// Port A Bit  1   KBD PS/2 CLK
// Port A Bit  2   [TBD]
// Port A Bit  3   JOY1/2 LATCH
// Port A Bit  4   JOY1 DATA
// Port A Bit  5   JOY1/2 CLK
// Port A Bit  6   JOY2 DATA
// Port A Bit  7   [TBD]
// Port B Bit  0   MOUSE PS/2 DAT
// Port B Bit  1   MOUSE PS/2 CLK
// Port B Bits 2-7 [TBD]
// NOTE: The pin assignment of the NES/SNES controller is likely to change.
struct MOS6522_VIA * const VIA2 = 0x9f70;

// Interrupt Vectors
// https://github.com/commanderx16/x16-emulator/wiki/(ASM-Programming)-Interrupts-and-interrupt-handling

// $FFFE	(ROM) Universal interrupt vector - The vector used when the HARDWARE serves IRQ interrupts
void()** const HARDWARE_IRQ = 0xfffe;
// $0314	(RAM) IRQ vector - The vector used when the KERNAL serves IRQ interrupts
void()** const KERNEL_IRQ = 0x0314;
// $0316	(RAM) BRK vector - The vector used when the KERNAL serves IRQ caused by a BRK
void()** const KERNEL_BRK = 0x0316;

// VRAM Address of the default screen
char * const DEFAULT_SCREEN = 0x0000;
// VRAM Bank (0/1) of the default screen
char * const DEFAULT_SCREEN_VBANK = 0;

// Put a single byte into VRAM.
// Uses VERA DATA0
// - vbank: Which 64K VRAM bank to put data into (0/1)
// - vaddr: The address in VRAM
// - data: The data to put into VRAM
void vpoke(char vbank, char* vaddr, char data);

// Read a single byte from VRAM.
// Uses VERA DATA0
// - bank: Which 64K VRAM bank to put data into (0/1)
// - addr: The address in VRAM
// - returns: The data to put into VRAM
char vpeek(char vbank, char* vaddr);

// Copy block of memory (from RAM to VRAM)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination in VRAM.
// - vbank: Which 64K VRAM bank to put data into (0/1)
// - vdest: The destination address in VRAM
// - src: The source address in RAM
// - num: The number of bytes to copy
void memcpy_to_vram(char vbank, void* vdest, void* src, unsigned int num );

void vram_to_vram(unsigned int num, char bget, void *vget, char iget, char bput, void *vput, char iput );

// Color Ram
char * const COLORRAM = 0xd800;

// The colors of the C64
const char BLACK = 0x0;
const char WHITE = 0x1;
const char RED = 0x2;
const char CYAN = 0x3;
const char PURPLE = 0x4;
const char GREEN = 0x5;
const char BLUE = 0x6;
const char YELLOW = 0x7;
const char ORANGE = 0x8;
const char BROWN = 0x9;
const char PINK = 0xa;
const char DARK_GREY= 0xb;
const char GREY = 0xc;
const char LIGHT_GREEN = 0xd;
const char LIGHT_BLUE = 0xe;
const char LIGHT_GREY = 0xf;