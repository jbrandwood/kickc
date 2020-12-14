// Commander X16
// https://www.commanderx16.com/forum/index.php?/about-faq/
// https://github.com/commanderx16/x16-docs/blob/master/Commander%20X16%20Programmer's%20Reference%20Guide.md

#include <cx16-vera.h>
#include <mos6522.h>

// The VIA#1: ROM/RAM Bank Control
// Port A Bits 0-7 RAM bank
// Port B Bits 0-2 ROM bank
// Port B Bits 3-7 [TBD]
struct MOS6522_VIA * const VIA1 = 0x9160;
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
struct MOS6522_VIA * const VIA2 = 0x9070;

// Interrupt Vectors
// https://github.com/commanderx16/x16-emulator/wiki/(ASM-Programming)-Interrupts-and-interrupt-handling

// $FFFE	(ROM) Universal interrupt vector - The vector used when the HARDWARE serves IRQ interrupts
void()** const HARDWARE_IRQ = 0xfffe;
// $0314	(RAM) IRQ vector - The vector used when the KERNAL serves IRQ interrupts
void()** const KERNEL_IRQ = 0x0314;
// $0316	(RAM) BRK vector - The vector used when the KERNAL serves IRQ caused by a BRK
void()** const KERNEL_BRK = 0x0316;