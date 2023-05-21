/// @file
/// Commodore 64 Registers and Constants
#ifndef __PET8032__
#error "Target platform must be PET"
#endif
#include <mos6526.h>
#include <mos6569.h>
#include <mos6581.h>


/// Default address of screen character matrix
char * const DEFAULT_SCREEN = (char*)0x8000;
/// Default address of the chargen font (upper case)
char * const DEFAULT_FONT_UPPER = (char*)0x1000;
/// Default address of the chargen font (mixed case)
char * const DEFAULT_FONT_MIXED = (char*)0x1800;

/// Pointer to interrupt function
typedef void (*IRQ_TYPE)(void);

/// The vector used when the KERNAL serves IRQ interrupts
IRQ_TYPE * const KERNEL_IRQ = (IRQ_TYPE*)0x0314;
/// The vector used when the KERNAL serves NMI interrupts
IRQ_TYPE * const  KERNEL_NMI = (IRQ_TYPE*)0x0318;
/// The vector used when the HARDWARE serves IRQ interrupts
IRQ_TYPE * const  HARDWARE_IRQ = (IRQ_TYPE*)0xfffe;

/// The colors of the C64
const char BLACK = 0x0;
const char WHITE = 0x1;


