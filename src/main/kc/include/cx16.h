/// Commander X16
/// https://www.commanderx16.com/forum/index.php?/about-faq/
/// https://github.com/commanderx16/x16-docs/blob/master/Commander%20X16%20Programmer's%20Reference%20Guide.md
#ifndef __CX16__
#error "Target platform must be cx16"
#endif
#include <cx16-vera.h>
#include <mos6522.h>

/// The VIA#1: ROM/RAM Bank Control
/// Port A Bits 0-7 RAM bank
/// Port B Bits 0-2 ROM bank
/// Port B Bits 3-7 [TBD]
struct MOS6522_VIA * const VIA1 = (struct MOS6522_VIA *)0x9f60;
/// The VIA#2: Keyboard/Joy/Mouse
/// Port A Bit  0   KBD PS/2 DAT
/// Port A Bit  1   KBD PS/2 CLK
/// Port A Bit  2   [TBD]
/// Port A Bit  3   JOY1/2 LATCH
/// Port A Bit  4   JOY1 DATA
/// Port A Bit  5   JOY1/2 CLK
/// Port A Bit  6   JOY2 DATA
/// Port A Bit  7   [TBD]
/// Port B Bit  0   MOUSE PS/2 DAT
/// Port B Bit  1   MOUSE PS/2 CLK
/// Port B Bits 2-7 [TBD]
/// NOTE: The pin assignment of the NES/SNES controller is likely to change.
struct MOS6522_VIA * const VIA2 = (struct MOS6522_VIA *)0x9f70;

/// Interrupt Vectors
/// https://github.com/commanderx16/x16-emulator/wiki/(ASM-Programming)-Interrupts-and-interrupt-handling

/// Pointer to interrupt function
typedef void (*IRQ_TYPE)(void);

/// $FFFE	(ROM) Universal interrupt vector - The vector used when the HARDWARE serves IRQ interrupts
IRQ_TYPE* const HARDWARE_IRQ = (IRQ_TYPE*)0xfffe;
/// $0314	(RAM) IRQ vector - The vector used when the KERNAL serves IRQ interrupts
IRQ_TYPE* const KERNEL_IRQ = (IRQ_TYPE*)0x0314;
/// $0316	(RAM) BRK vector - The vector used when the KERNAL serves IRQ caused by a BRK
IRQ_TYPE* const KERNEL_BRK = (IRQ_TYPE*)0x0316;


/// VRAM Address of the default screen
char * const DEFAULT_SCREEN = (char*)0x0000;
/// VRAM Bank (0/1) of the default screen
char * const DEFAULT_SCREEN_VBANK = (char*)0;

/// Put a single byte into VRAM.
/// Uses VERA DATA0
/// - vbank: Which 64K VRAM bank to put data into (0/1)
/// - vaddr: The address in VRAM
/// - data: The data to put into VRAM
void vpoke(char vbank, char* vaddr, char data);

/// Read a single byte from VRAM.
/// Uses VERA DATA0
/// - bank: Which 64K VRAM bank to put data into (0/1)
/// - addr: The address in VRAM
/// - returns: The data to put into VRAM
char vpeek(char vbank, char* vaddr);

/// Copy block of memory (from RAM to VRAM)
/// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination in VRAM.
/// - vbank: Which 64K VRAM bank to put data into (0/1)
/// - vdest: The destination address in VRAM
/// - src: The source address in RAM
/// - num: The number of bytes to copy
void memcpy_to_vram(char vbank, void* vdest, void* src, unsigned int num );

/// Copy block of memory (from banked RAM to VRAM)
/// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination in VRAM.
/// - vdest: absolute address in VRAM
/// - src: absolute address in the banked RAM  of the CX16.
/// - num: dword of the number of bytes to copy
/// Note: This function can switch RAM bank during copying to copy data from multiple RAM banks.
void memcpy_bank_to_vram(unsigned long vdest, unsigned long src, unsigned long num );

/// Copy block of memory (from VRAM to VRAM)
/// Copies the values from the location pointed by src to the location pointed by dest.
/// The method uses the VERA access ports 0 and 1 to copy data from and to in VRAM.
/// - src_bank:  64K VRAM bank number to copy from (0/1).
/// - src: pointer to the location to copy from. Note that the address is a 16 bit value!
/// - src_increment: the increment indicator, VERA needs this because addressing increment is automated by VERA at each access.
/// - dest_bank:  64K VRAM bank number to copy to (0/1).
/// - dest: pointer to the location to copy to. Note that the address is a 16 bit value!
/// - dest_increment: the increment indicator, VERA needs this because addressing increment is automated by VERA at each access.
/// - num: The number of bytes to copy
void memcpy_in_vram(char dest_bank, void *dest, char dest_increment, char src_bank, void *src, char src_increment, unsigned int num );

/// Set block of memory in VRAM to a value .
/// Sets num bytes to a value to the memory block pointed to by destination in VRAM.
/// - vbank: Which 64K VRAM bank to put data into (0/1)
/// - vdest: The destination address in VRAM
/// - data: The value to set the vram with.
/// - num: The number of bytes to set
void memset_vram(char vbank, void* vdest, char data, unsigned long num );

/// Set block of memory in VRAM to a word value .
/// Sets num words  to a value to the memory block pointed to by destination in VRAM.
/// - vbank: Which 64K VRAM bank to put data into (0/1)
/// - vdest: The destination address in VRAM
/// - data: The value to set the vram with.
/// - num: The number of bytes to set
void memset_vram_word(char vbank, void* vdest, unsigned int data, unsigned long num );

/// Load a file into one of the 256 8KB RAM banks.
/// - device: The device to load from
/// - filename: The file name
/// - address: The absolute address in banked memory to load the file too
/// - returns: 0xff: Success, other: Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
/// Note: This function only works if the entire file fits within the selected bank. The function cannot load to multiple banks.
char load_to_bank( char device, char* filename, unsigned long address);