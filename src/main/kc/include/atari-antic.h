// ATARI Alphanumeric Television Interface Controller (ANTIC)
// Used in Atari 5200 and the 8-bit series (400, 800, XL, XE)
// https://en.wikipedia.org/wiki/ANTIC
// https://playermissile.com/dli_tutorial/

struct ATARI_ANTIC {

    // Direct Memory Access Control
    // 7 6 5 4 3 2 1 0
    // - - - - - - 0 0 No playfield
    // - - - - - - 0 1 Narrow playfield (128 color clocks	32 characters)
    // - - - - - - 1 0 Standard playfield (160 color clocks	40 characters) (default)
    // - - - - - - 1 1 Wide playfield (192 color clocks	48 characters)
    // - - - - - 1 - - Enable missle DMA
    // - - - - 1 - - - Enable player DMA
    // - - - 1 - - - - One line player resolution
    // - - - 0 - - - - Two-line player resolution (default)
    // - - 1 - - - - - Enable DMA for fetching the display list instructions (default)
    // SHADOW: SDMCTL $022F
    char DMACTL;

    // Character Control
    // 7 6 5 4 3 2 1 0
    // - - - - - - - 1 Video Blank. Inverse video characters display as blanks spaces.
    // - - - - - - 1 - Video Inverse. Inverse video characters appear as inverse video. (default)
    // - - - - - 1 - - Video Reflect. All characters are displayed vertically mirrored.
    // SHADOW: CHART $02F3
    char CHACTL;

    // Display List Pointer
    // ANTIC begins executing the Display List pointed to by the 16-bit address in registers DLISTL/DLISTH
    // SHADOW: SDLSTL/SDLSTH $0230/$0231
    char *DLIST;

    // Horizontal Fine Scroll
    // Only the lowest 4 bits are significant.
    // The value range of 16 color clocks allows ANTIC to shift Mode 2 Text four characters, and Mode 6 text two characters before a coarse scroll is needed.
    char HSCROL;

    // Vertical Fine Scroll
    // The lowest 4 bits are significant, however the Vertical scroll value should range from 0 to the ANTIC Mode line's scan line height - 1.
    // Scrolling farther than the ANTIC Mode's number of scan lines results in lines of repeated data upsetting the fine scrolling continuity (though, this can also be used as an exploitable behavior).
    char VSCROL;

    // Unused
    char UNUSED1;

    // Player Missile Base Address
    // This specifies the page of the base address for Player/Missile graphics.
    // When double line resolution P/M graphics are operating the PMBASE value must begin on a 1K boundary.
    // When single line resolution P/M graphics are operating the PMBASE value must begin on a 2K boundary.
    char PMBASE;

    // Unused
    char UNUSED2;

    // Character Base Address
    // This specifies the page of the base address for the character set.
    // ANTIC Modes 2, 3, 4, and 5 use 128 characters in the character set and require the CHBASE value begin on a 1K boundary.
    // ANTIC Modes 6 and 7 use 64 characters, so the CHBASE value must begin on a 512 byte boundary.
    // The usual default value is $E0hex/224dec for the character set in ROM at $E000hex/57344dec.
    // SHADOW: CHBAS $02F4
    char CHBASE;

    // Wait For Horizontal Sync
    // This register allows programs to synchronize to the display. A write to this register halts the 6502 program through the end of the current scanline.
    // The value written is unimportant.
    char WSYNC;

    // Vertical Line Counter
    // This register tracks the scan line currently being generated. The value returned is the actual scan line divided by 2.
    // Blank lines generated at the start of the display are included.
    // The value for NTSC will range from 0 to 130 for NTSC, and 0 to 155 for PAL.
    char VCOUNT;

    // Light Pen Horizontal Position
    // This contains the horizontal color clock position when the light pen/light gun trigger is pressed.
    // The shadow register is the recommended source for reading this information, since it will be updated during the vertical blank guaranteeing consistent and reliable results.
    // Programs should avoid reading the hardware register directly unless the program is certain the register is read at a time insuring the value is valid.
    // SHADOW: LPENH $0234
    char PENH;

    // Light Pen Vertical Position
    // This contains the VCOUNT value captured when the light pen/light gun trigger is pressed.
    // The shadow register is the recommended source for reading this information, since it will be updated during the vertical blank guaranteeing consistent and reliable results.
    // Programs should avoid reading the hardware register directly unless the program is certain the register is read at a time insuring the value is valid.
    // SHADOW: LPENV $0235
    char PENV;

    // Non-Maskable Interrupt (NMI) Enable
    // Enables Non-Maskable Interrupts.
    // 7 6 5 4 3 2 1 0
    // 1 - - - - - - - RESET: Enable Reset key interrupt
    // - 1 - - - - - - VBI: Enable Vertical Blank Interrupt
    // - - 1 - - - - - DLI: Enable Display List Interrupt
    // The Operation System sets NMIEN to the default $40hex/64dec during the power up routines.
    // The NMI service routines first vector through $FFFAhex/65530dec which determines the cause and then transfers control to the interrupt service routine.
    // If NMIEN's DLI bit is set when ANTIC encounters a Display List instruction with the DLI modifier bit set, then ANTIC triggers the DLI on the last scan line of that Display List instruction mode line.
    // When NMIEN's VBI bit is set, ANTIC will signals a Vertical Blank Interrupt at the end of processing the JVB (Jump vertical blank) at the end of the Display List.
    // The OS jumps through VVBLKI ($0222hex/546dec) to begin the OS VBI Service Routine, and the OS VBI Routine exits with a jump through VVBLKD ($0224hex/548dec).
    // By default VVBLKI points to the OS jump vector SYSVBV ($E45Fhex/58463dec) to begin the Vertical Blank Interrupt, and VVBLKD points to the OS jump vector XITVBV ($E462hex/58466dec).
    char NMIEN;

    // Non-Maskable Interrupt (NMI) Status / Reset
    // Contains information about which NMI occured.
    // Any value written to NMIRES resets the bits in NMIST which indicate the reason for the most recent Non-Maskable Interrupt.
    // 7 6 5 4 3 2 1 0
    // 1 - - - - - - - RESET: Reset key interrupt
    // - 1 - - - - - - VBI: Vertical Blank Interrupt
    // - - 1 - - - - - DLI: Display List Interrupt
    char NMIST;
    
};