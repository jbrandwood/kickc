/**
 * @file cx16.h
 * @author Jesper Gravgaard / Sven Van de Velde
 * @brief Contains functions to control the features of the Commander X16.
 * Commander X16 Functions.
 * https://www.commanderx16.com/forum/index.php?/about-faq/
 * https://github.com/commanderx16/x16-docs/blob/master/Commander%20X16%20Programmer's%20Reference%20Guide.md
 * @version 0.2
 * @date 2022-01-29
 *
 * @copyright Copyright (c) 2022
 *
 */



#ifndef __CX16__
#error "Target platform must be cx16"
#endif

#include <cx16-typedefs.h>
#include <mos6522.h>

/**
 * @brief The VIA#1: ROM/RAM Bank Control
 * Port A Bits 0-7 RAM bank
 * Port B Bits 0-2 ROM bank
 * Port B Bits 3-7 [TBD] *  *  *  *  *
 */
struct MOS6522_VIA * const VIA1 = (struct MOS6522_VIA*)0x9f60;

/**
 * @brief The VIA#2: Peripherals control
 * Port A Bit  0   KBD PS/2 DAT
 * Port A Bit  1   KBD PS/2 CLK
 * Port A Bit  2   [TBD]
 * Port A Bit  3   JOY1/2 LATCH
 * Port A Bit  4   JOY1 DATA
 * Port A Bit  5   JOY1/2 CLK
 * Port A Bit  6   JOY2 DATA
 * Port A Bit  7   [TBD]
 * Port B Bit  0   MOUSE PS/2 DAT
 * Port B Bit  1   MOUSE PS/2 CLK
 * Port B Bits 2-7 [TBD]
 * kNOTE: The pin assignment of the NES/SNES controller is likely to change.
 */
struct MOS6522_VIA * const VIA2 = (struct MOS6522_VIA*)0x9f70;

__export volatile __address(0x00) unsigned char BRAM = 0;
__export volatile __address(0x01) unsigned char BROM = 4;

/// Interrupt Vectors
/// https://github.com/commanderx16/x16-emulator/wiki/(ASM-Programming)-Interrupts-and-interrupt-handling

// The vector used when the KERNAL serves IRQ interrupts

/// $FFFE	(ROM) Universal interrupt vector - The vector used when the HARDWARE serves IRQ interrupts
IRQ_TYPE* const HARDWARE_IRQ = (IRQ_TYPE*)0xfffe;
/// $0314	(RAM) IRQ vector - The vector used when the KERNAL serves IRQ interrupts
IRQ_TYPE* const KERNEL_IRQ = (IRQ_TYPE*)0x0314;
/// $0316	(RAM) BRK vector - The vector used when the KERNAL serves IRQ caused by a BRK
IRQ_TYPE* const KERNEL_BRK = (IRQ_TYPE*)0x0316;

void cx16_kernal_irq(IRQ_TYPE irq);

byte const CX16_ROM_KERNAL = 0;
byte const CX16_ROM_BASIC = 4;

/// VRAM Address of the default screen
vram_offset_t DEFAULT_SCREEN = (vram_offset_t)0xB000;
/// VRAM Bank (0/1) of the default screen
char * const DEFAULT_SCREEN_VBANK = (char*)0;


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


inline void                 bank_push_set_bram(bram_bank_t bank);
inline void                 bank_push_bram();
inline void                 bank_set_bram(bram_bank_t bank);
inline void                 bank_pull_bram();
inline bram_bank_t          bank_get_bram();
inline bram_ptr_t           bank_bram_ptr_inc(char bank, char* sptr, unsigned int inc);
void                        bank_set_brom(brom_bank_t bank);
inline brom_bank_t          bank_get_brom();

void vpoke(vram_bank_t vbank, vram_offset_t vaddr, char data);
char vpeek(vram_bank_t vbank, vram_offset_t vaddr);

void memcpy_vram_ram(vram_bank_t dbank_vram, vram_offset_t doffset_vram, ram_ptr_t sptr_ram, unsigned int num);
void memcpy_ram_vram(ram_ptr_t dptr, vram_bank_t sbank_vram, vram_offset_t soffset_vram, unsigned int num);
void memcpy_vram_bram(vram_bank_t dbank_vram, vram_offset_t doffset_vram, bram_bank_t sbank_bram, bram_ptr_t sptr_bram, unsigned int num);
void memcpy8_vram_vram(vram_bank_t dbank_vram, vram_offset_t doffset_vram, vram_bank_t sbank_vram, vram_offset_t soffset_vram, unsigned char num8);
inline void memcpy_vram_bram_fast(vram_bank_t dbank_vram, vram_offset_t doffset_vram, bram_bank_t sbank_bram, bram_ptr_t sptr_bram, unsigned char num);
void memcpy_vram_vram(vram_bank_t dbank_vram, vram_offset_t doffset_vram, vram_bank_t sbank_vram, vram_offset_t soffset_vram, unsigned int num16);
void memcpy_vram_vram_inc(vram_bank_t dbank_vram, vram_offset_t doffset_vram, unsigned char dinc, vram_bank_t sbank_vram, vram_offset_t soffset_vram, unsigned char sinc, unsigned int num );
void memset_vram(vram_bank_t dbank_vram, vram_offset_t doffset_vram, unsigned char data, unsigned int num);
