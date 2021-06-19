/// @file
/// @brief ATARI Alphanumeric Television Interface Controller (ANTIC)
///
/// Used in Atari 5200 and the 8-bit series (400, 800, XL, XE)
/// https://en.wikipedia.org/wiki/ANTIC
/// https://playermissile.com/dli_tutorial/

struct ATARI_ANTIC {

    ///  Direct Memory Access Control
    ///  7 6 5 4 3 2 1 0
    ///  - - - - - - 0 0 No playfield
    ///  - - - - - - 0 1 Narrow playfield (128 color clocks	32 characters)
    ///  - - - - - - 1 0 Standard playfield (160 color clocks	40 characters) (default)
    ///  - - - - - - 1 1 Wide playfield (192 color clocks	48 characters)
    ///  - - - - - 1 - - Enable missle DMA
    ///  - - - - 1 - - - Enable player DMA
    ///  - - - 1 - - - - One line player resolution
    ///  - - - 0 - - - - Two-line player resolution (default)
    ///  - - 1 - - - - - Enable DMA for fetching the display list instructions (default)
    ///  SHADOW: SDMCTL $022F
    char DMACTL;

    ///  Character Control
    ///  7 6 5 4 3 2 1 0
    ///  - - - - - - - 1 Video Blank. Inverse video characters display as blanks spaces.
    ///  - - - - - - 1 - Video Inverse. Inverse video characters appear as inverse video. (default)
    ///  - - - - - 1 - - Video Reflect. All characters are displayed vertically mirrored.
    ///  SHADOW: CHART $02F3
    char CHACTL;

    ///  Display List Pointer
    ///  ANTIC begins executing the Display List pointed to by the 16-bit address in registers DLISTL/DLISTH
    ///  SHADOW: SDLSTL/SDLSTH $0230/$0231
    char *DLIST;

    ///  Horizontal Fine Scroll
    ///  Only the lowest 4 bits are significant.
    ///  The value range of 16 color clocks allows ANTIC to shift Mode 2 Text four characters, and Mode 6 text two characters before a coarse scroll is needed.
    char HSCROL;

    ///  Vertical Fine Scroll
    ///  The lowest 4 bits are significant, however the Vertical scroll value should range from 0 to the ANTIC Mode line's scan line height - 1.
    ///  Scrolling farther than the ANTIC Mode's number of scan lines results in lines of repeated data upsetting the fine scrolling continuity (though, this can also be used as an exploitable behavior).
    char VSCROL;

    ///  Unused
    char UNUSED1;

    ///  Player Missile Base Address
    ///  This specifies the page of the base address for Player/Missile graphics.
    ///  When double line resolution P/M graphics are operating the PMBASE value must begin on a 1K boundary.
    ///  When single line resolution P/M graphics are operating the PMBASE value must begin on a 2K boundary.
    char PMBASE;

    ///  Unused
    char UNUSED2;

    ///  Character Base Address
    ///  This specifies the page of the base address for the character set.
    ///  ANTIC Modes 2, 3, 4, and 5 use 128 characters in the character set and require the CHBASE value begin on a 1K boundary.
    ///  ANTIC Modes 6 and 7 use 64 characters, so the CHBASE value must begin on a 512 byte boundary.
    ///  The usual default value is $E0hex/224dec for the character set in ROM at $E000hex/57344dec.
    ///  SHADOW: CHBAS $02F4
    char CHBASE;

    ///  Wait For Horizontal Sync
    ///  This register allows programs to synchronize to the display. A write to this register halts the 6502 program through the end of the current scanline.
    ///  The value written is unimportant.
    char WSYNC;

    ///  Vertical Line Counter
    ///  This register tracks the scan line currently being generated. The value returned is the actual scan line divided by 2.
    ///  Blank lines generated at the start of the display are included.
    ///  The value for NTSC will range from 0 to 130 for NTSC, and 0 to 155 for PAL.
    char VCOUNT;

    ///  Light Pen Horizontal Position
    ///  This contains the horizontal color clock position when the light pen/light gun trigger is pressed.
    ///  The shadow register is the recommended source for reading this information, since it will be updated during the vertical blank guaranteeing consistent and reliable results.
    ///  Programs should avoid reading the hardware register directly unless the program is certain the register is read at a time insuring the value is valid.
    ///  SHADOW: LPENH $0234
    char PENH;

    ///   Light Pen Vertical Position
    ///  This contains the VCOUNT value captured when the light pen/light gun trigger is pressed.
    ///  The shadow register is the recommended source for reading this information, since it will be updated during the vertical blank guaranteeing consistent and reliable results.
    ///  Programs should avoid reading the hardware register directly unless the program is certain the register is read at a time insuring the value is valid.
    ///  SHADOW: LPENV $0235
    char PENV;

    ///  Non-Maskable Interrupt (NMI) Enable
    ///  Enables Non-Maskable Interrupts.
    ///  7 6 5 4 3 2 1 0
    ///  1 - - - - - - - RESET: Enable Reset key interrupt
    ///  - 1 - - - - - - VBI: Enable Vertical Blank Interrupt
    ///  - - 1 - - - - - DLI: Enable Display List Interrupt
    ///  The Operation System sets NMIEN to the default $40hex/64dec during the power up routines.
    ///  The NMI service routines first vector through $FFFAhex/65530dec which determines the cause and then transfers control to the interrupt service routine.
    ///  If NMIEN's DLI bit is set when ANTIC encounters a Display List instruction with the DLI modifier bit set, then ANTIC triggers the DLI on the last scan line of that Display List instruction mode line.
    ///  When NMIEN's VBI bit is set, ANTIC will signals a Vertical Blank Interrupt at the end of processing the JVB (Jump vertical blank) at the end of the Display List.
    ///  The OS jumps through VVBLKI ($0222hex/546dec) to begin the OS VBI Service Routine, and the OS VBI Routine exits with a jump through VVBLKD ($0224hex/548dec).
    ///  By default VVBLKI points to the OS jump vector SYSVBV ($E45Fhex/58463dec) to begin the Vertical Blank Interrupt, and VVBLKD points to the OS jump vector XITVBV ($E462hex/58466dec).
    char NMIEN;

    ///  Non-Maskable Interrupt (NMI) Status / Reset
    ///  Contains information about which NMI occured.
    ///  Any value written to NMIRES resets the bits in NMIST which indicate the reason for the most recent Non-Maskable Interrupt.
    ///  7 6 5 4 3 2 1 0
    ///  1 - - - - - - - RESET: Reset key interrupt
    ///  - 1 - - - - - - VBI: Vertical Blank Interrupt
    ///  - - 1 - - - - - DLI: Display List Interrupt
    char NMIST;
    
};

/// ANTIC Display List Instruction Set

/// 2: High Resolution Text Mode. 8 scanlines per char, 32/40/48 chars wide.  bit 7 controls inversion or blinking, based on modes in CHACTL.
const char MODE2 = 0x02;
/// 3: High Resolution Text Mode. 10 scanlines per char, 32/40/48 chars wide
const char MODE3 = 0x03;
/// 4:  Multicolor text. 8 scanlines per char, 32/40/48 chars wide.
const char MODE4 = 0x04;
/// 5:  Multicolor text. 16 scanlines per char, 32/40/48 chars wide. each character is instead 4x8 with pixels twice as wide. Normally each pair of bits produces either the background color (00) or PF0-PF2 (01-11). If bit 7 is set, however, the 11 pair produces PF3 instead of PF2.
const char MODE5 = 0x05;
/// 6:  Single color text in five colors. 8 scanlines per char, 16/20/24 chars wide.  the upper two bits are used to select the foreground color used by 1 bits, with 00-11 producing PF0-PF3.
const char MODE6 = 0x06;
/// 7:  Single color text in five colors. 16 scanlines per char, 16/20/24 chars wide.  the upper two bits are used to select the foreground color used by 1 bits, with 00-11 producing PF0-PF3.
const char MODE7 = 0x07;
/// 8: Bitmap mode with 8x8 pixels. 40 pixel screen. four-color mode.
const char MODE8 = 0x08;
/// 9: Bitmap mode with 4x4 pixels. 80 pixel screen. two-color mode.
const char MODE9 = 0x09;
/// A: Bitmap mode with 4x4 pixels. 80 pixel screen. four-color mode.
const char MODEA = 0x0a;
/// B: Bitmap mode with 2x2 pixels. 160 pixel screen. two-color mode.
const char MODEB = 0x0b;
/// C: Bitmap mode with 2x1 pixels. 160 pixel screen. two-color mode.
const char MODEC = 0x0c;
/// D: Bitmap mode with 2x2 pixels. 160 pixel screen. four-color mode.
const char MODED = 0x0d;
/// E: Bitmap mode with 2x1 pixels. 160 pixel screen. four-color mode.
const char MODEE = 0x0e;
/// F: Bitmap mode with 1x1 pixels. 320 pixel screen. two-color mode.
const char MODEF = 0x0f;

/// Display list interrupt - Interrupt CPU at beginning of last scan line. Can be combined with mode or blank instructions by OR.
const char DLI = 0x80;
/// Load memory scan counter (LMS operation) - Load memory scan counter with new 16-bit address. Can be combined with mode instructions by OR.
const char LMS = 0x40;
/// Vertical scroll - Enable vertical scrolling. Can be combined with mode or blank instructions by OR.
const char VS = 0x20;
/// Horizontal scroll - Enable horizontal scrolling. Can be combined with mode or blank instructions by OR.
const char HS = 0x10;
/// Jump command - followed by two bytes indicating the new instruction pointer for the display list.
const char JMP = 0x01;
/// Jump and wait for Vertical Blank - suspends the display list until vertical blank and then jumps. This is usually used to terminate the display list and restart it for the next frame.
const char JVB = 0x41;
/// Blank 1 line
const char BLANK1 = 0x00;
/// Blank 2 lines
const char BLANK2 = 0x10;
/// Blank 3 lines
const char BLANK3 = 0x20;
/// Blank 4 lines
const char BLANK4 = 0x30;
/// Blank 5 lines
const char BLANK5 = 0x40;
/// Blank 6 lines
const char BLANK6 = 0x50;
/// Blank 7 lines
const char BLANK7 = 0x60;
/// Blank 8 lines
const char BLANK8 = 0x70;
