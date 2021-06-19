/// @file
/// Plus/4 / Commodore 16 registers and memory layout
/// http://zimmers.net/anonftp/pub/cbm/schematics/computers/plus4/264_Hardware_Spec.pdf
/// http://www.zimmers.net/anonftp/pub/cbm/schematics/computers/plus4/Plus_4_Technical_Docs.pdf
/// http://personalpages.tds.net/~rcarlsen/cbm/c16/C16_Service_Manual_314001-03_(1984_Oct).pdf
/// https://www.floodgap.com/retrobits/ckb/secret/264memory.txt
#include <mos7360.h>
#include <mos6551.h>
#include <mos6529.h>
#include <mos7501.h>

#ifndef __PLUS4__
    #error "Target platform must be PLU4"
#endif
/// The processor port
/// Used for serial I/O and controlling the cassette
struct MOS7501_PORT * const PROCESSOR_PORT = (struct MOS7501_PORT *)0x00;

/// Default address of screen luminance/color matrix
char * const DEFAULT_COLORRAM = (char*)0x0800;

/// Default address of screen character matrix
char * const DEFAULT_SCREEN = (char*)0x0c00;

/// The ACIA used for RS232 (only on the Plus/4)
struct MOS6551_ACIA * const ACIA = (struct MOS6551_ACIA *)0xfd00;

/// User Port PIO (P0-P7)
/// Bit 2 (P2) is used to detect if play on cassette is pressed (CST sense)
struct MOS6529_PIO * const USER_PORT = (struct MOS6529_PIO *)0xfd10;

/// Keyboard Port PIO (P0-P7)
/// The input latch is part of the TED.
struct MOS6529_PIO * const KEYBOARD_PORT = (struct MOS6529_PIO *)0xfd30;

/// ROM configuration for the machine, which normally has the BASIC and kernal ROMs enabled.
/// The ROM configuration is adjusted by writing to the registers (the value is irrelevant).
/// The upper portion of the kernal ROM at $FC00-$FCFF is always enabled no matter what the memory configuration, as are the I/O registers.
struct PLUS4_ROM_BANKING {
    /// $FDD0 enables or disables BASIC,
    char BASIC;
    /// $FDD1 the low function ROM,
    char FUNCTION_LOW;
    /// $FDD2 the low cartridge ROM,
    char CARTRIDGE_LOW;
    /// $FDD3 is unused,
    char UNUSED;
    /// $FDD4 the kernal,
    char KERNAL;
    /// $FDD5 the high function ROM
    char FUNCTION_HIGH;
    /// $FDD6 the high cartridge ROM.
    char CARTRIDGE_HIGH;
};

struct PLUS4_ROM_BANKING * const ROM_BANKING = (struct PLUS4_ROM_BANKING *)0xfdd0;

/// The TED chip controlling video and sound on the Plus/4 and Commodore 16
struct MOS7360_TED * const TED = (struct MOS7360_TED *)0xff00;



