// Commander X16
// https://www.commanderx16.com/forum/index.php?/about-faq/
// https://github.com/commanderx16/x16-docs/blob/master/Commander%20X16%20Programmer's%20Reference%20Guide.md

#include <cx16-vera.h>

// Interrupt Vectors
// https://github.com/commanderx16/x16-emulator/wiki/(ASM-Programming)-Interrupts-and-interrupt-handling

// $FFFE	(ROM) Universal interrupt vector - The vector used when the HARDWARE serves IRQ interrupts
void()** const HARDWARE_IRQ = 0xfffe;
// $0314	(RAM) IRQ vector - The vector used when the KERNAL serves IRQ interrupts
void()** const KERNEL_IRQ = 0x0314;
// $0316	(RAM) BRK vector - The vector used when the KERNAL serves IRQ caused by a BRK
void()** const KERNEL_BRK = 0x0316;