/// @file
/// Commodore 64 Registers and Constants
#ifndef __C64__
#error "Target platform must be C64"
#endif
#include <mos6526.h>
#include <mos6569.h>
#include <mos6581.h>


/// Processor port data direction register
char*  const PROCPORT_DDR = (char*)0x00;
/// Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
const char PROCPORT_DDR_MEMORY_MASK = 0b00000111;
/// Processor Port Register controlling RAM/ROM configuration and the datasette
char*  const PROCPORT = (char*)0x01;
/// RAM in all three areas 0xA000, 0xD000, 0xE000
const char PROCPORT_RAM_ALL         = 0b00000000;
/// RAM in 0xA000, 0xE000 I/O in 0xD000
const char PROCPORT_RAM_IO          = 0b00000101;
/// RAM in 0xA000, 0xE000 CHAR ROM in 0xD000
const char PROCPORT_RAM_CHARROM     = 0b00000001;
/// RAM in 0xA000, I/O in 0xD000, KERNEL in 0xE000
const char PROCPORT_KERNEL_IO       = 0b00000110;
/// BASIC in 0xA000, I/O in 0xD000, KERNEL in 0xE000
const char PROCPORT_BASIC_KERNEL_IO = 0b00000111;

/// The address of the CHARGEN character set
char*  const CHARGEN = (char*)0xd000;
/// The SID MOS 6581/8580
struct MOS6581_SID * const SID = (struct MOS6581_SID *)0xd400;
/// The VIC-II MOS 6567/6569
struct MOS6569_VICII* const VICII = (struct MOS6569_VICII*)0xd000;
/// Color Ram
char * const COLORRAM = (char*)0xd800;
/// Color Ram
char * const COLS = (char*)0xd800;

/// Default address of screen character matrix
char * const DEFAULT_SCREEN = (char*)0x0400;
/// Default address of the chargen font (upper case)
char * const DEFAULT_FONT_UPPER = (char*)0x1000;
/// Default address of the chargen font (mixed case)
char * const DEFAULT_FONT_MIXED = (char*)0x1800;

/// The CIA#1: keyboard matrix, joystick #1/#2
struct MOS6526_CIA * const CIA1 = (struct MOS6526_CIA *)0xdc00;
/// The CIA#2: Serial bus, RS-232, VIC memory bank
struct MOS6526_CIA * const CIA2 = (struct MOS6526_CIA *)0xdd00;
/// CIA#1 timer A
unsigned int* const CIA1_TIMER_A = (unsigned int*)0xdc04;
/// CIA#1 timer B
unsigned int* const CIA1_TIMER_B = (unsigned int*)0xdc06;
/// CIA#1 timer A&B as one single 32-bit value
unsigned long* const CIA1_TIMER_AB = (unsigned long*)0xdc04;
/// CIA#1 Interrupt for reading in ASM
char * const CIA1_INTERRUPT = (char*)0xdc0d;
/// CIA#2 timer A
unsigned int* const CIA2_TIMER_A = (unsigned int*)0xdd04;
/// CIA#2 timer B
unsigned int* const CIA2_TIMER_B = (unsigned int*)0xdd06;
/// CIA#2 timer A&B as one single 32-bit value
unsigned long* const CIA2_TIMER_AB = (unsigned long*)0xdd04;
/// CIA#2 Interrupt for reading in ASM
char * const CIA2_INTERRUPT = (char*)0xdd0d;

/// Pointer to interrupt function
typedef void (*IRQ_TYPE)(void);

/// The vector used when the KERNAL serves IRQ interrupts
IRQ_TYPE * const KERNEL_IRQ = (IRQ_TYPE*)0x0314;
/// The vector used when the KERNAL serves NMI interrupts
IRQ_TYPE * const  KERNEL_NMI = (IRQ_TYPE*)0x0318;
/// The vector used when the HARDWARE serves NMI interrupts
IRQ_TYPE * const  HARDWARE_NMI = (IRQ_TYPE*)0xfffa;
/// The vector used when the HARDWARE is RESET
IRQ_TYPE * const  HARDWARE_RESET = (IRQ_TYPE*)0xfffc;
/// The vector used when the HARDWARE serves IRQ interrupts
IRQ_TYPE * const  HARDWARE_IRQ = (IRQ_TYPE*)0xfffe;

/// The colors of the C64
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

/// Get the value to store into D018 to display a specific screen and charset/bitmap
/// Optimized for ASM from (char)((((unsigned int)screen&0x3fff)/0x40)|(((unsigned int)charset&0x3fff)/0x400));
char toD018(char*  screen, char*  gfx);

/// Get the value to store into DD00 (CIA 2 port A) to choose a specific VIC bank
/// Optimized for ASM from %00000011 ^ (char)((unsigned int)gfx/0x4000)
char toDd00(char*  gfx);

/// Get the sprite pointer for a sprite.
/// The sprite pointer is the index of the sprite within the graphics bank and equal to the sprite (char)(sprite_addr/64)
/// The sprite pointers are stored SCREEN+0x3f8+sprite_id to set the pointer of each sprite
char toSpritePtr(char*  sprite);

/// Select a specific VIC graphics bank by setting the CIA 2 port A (0xdd00) as needed
void vicSelectGfxBank(char*  gfx);

/// Initialize SID voice 3 for random number generation
void sid_rnd_init();

/// Get a random number from the SID voice 3,
/// Must be initialized with sid_rnd_init()
char sid_rnd();
