// The MOS 7360/8360 TED chip used for graphics and sound in Plus/4 and Commodore 16
// https://www.karlstechnology.com/commodore/TED7360-datasheet.pdf
// http://mclauchlan.site.net.au/scott/C=Hacking/C-Hacking12/gfx.html

struct MOS7360_TED {
    // Counter #01. It always starts to decrement from the last written value into it.
    unsigned int COUNTER1;
    // Counter #02. It runs freely from $ffff.
    unsigned int COUNTER2;
    // Counter #03. Same as above.
    unsigned int COUNTER3;
    // Mostly the same as VIC's $d011.
    //   Bit 0,1,2 : Vertical smooth-scrolling
    //   Bit 3     : 24/25 rows screen
    //   Bit 4     : Blank screen
    //   Bit 5     : Bitplane mode
    //   Bit 6     : Enhanced color mode
    //   Bit 7     : TED's internal test, it should be 0.
    unsigned char CONTROL1;
    // Most similar VIC-reg is $d016.
    //   Bit 0,1,2 : Horizontal smooth-scrolling
    //   Bit 3     : 40/38 columns screen
    //   Bit 4     : Multicolor mode
    //   Bit 5     : TED stop. If set, the TED stops it's counters and screen-generating, only single clock and refresh
    //               cycles remain.
    //   Bit 6     : PAL/NTSC. 0:PAL, 1:NTSC
    //   Bit 7     : Disable reverse mode. If 0, we got 128 characters and higmost bit tells if the character should
    //               appear in inverse. If set, no inverse mode but 256 characters.
    unsigned char CONTROL2;
    // Keyboard input latch. Giving a strobe - writing to the register, the latch stores the values of the input-lines.
    // Then, we can read them from this register.
    volatile unsigned char KEYBOARD_INPUT;
    // Interrupt request register. When a counter sends want to send an IRQ, it's bit will appear as a 0; then, if the
    // IRQ was caused then highmost bit is set.
    //    Bit 0     : Unused
    //    Bit 1     : Raster-counter
    //    Bit 2     : Lightpen. Not implemented.
    //    Bit 3     : Counter #1
    //    Bit 4     : Counter #2
    //    Bit 5     : Unused
    //    Bit 6     : Counter #3
    //    Bit 7     : Interrupt occured. This bit is set when an IRQ was enabled and therefore, the IRQ was sent to the
    //                processor. Physically, this is the negated level of the TED's IRQ output. The IRQ should be
    //                deleted with writing the register-value back after accepting an interrupt.
    unsigned char IRQ_REQUEST;
    // Interrupt mask register. These bits could be used to disable and enable interrupt-sources. When a place is set to
    // 1, that will be able to cause an interrupt to the processor. If not, the sign of the interrupt request will only
    // be appear in the above register.
    //    Bit 0     : 9th bit of RASTER_IRQ (see there)
    //    Bit 1     : Raster-counter
    //    Bit 2     : Lightpen. Not implemented.
    //    Bit 3     : Counter #1
    //    Bit 4     : Counter #2
    //    Bit 5     : Unused
    //    Bit 6     : Counter #3
    //    Bit 7     : Unused
    unsigned char IRQ_MASK;
    // Raster interrupt register. Same as $d012 when writing; it stores the position of occuring raster interrupt.
    // Higmost bit is in IRQ_REQUEST's 0. bit.
    unsigned char RASTER_IRQ;
    // Hardware-cursor position (10 bits). Lower bits: CURSOR_LO, higher 2 bits in CURSOR_HI's 0. and 1. places.
    // Beyond 1000 the cursor is not seeable.
    unsigned char CURSOR_HI;
    unsigned char CURSOR_LO;
    // First sound-source's frq-value's lowmost 8 bit. More 2 bits are in $ff10's 0. and 1. places.
    unsigned char CH1_FREQ_LO;
    // Second sound-source, lowmost 8 bits. More 2 bits in $ff12, 0. and 1. places.
    // The sound register-value can be calculated as
    //    reg=1024-(111860.781/frq[Hz]) (NTSC)
    //    reg=1024-(111840.45 /frq[Hz]) (PAL)
    unsigned char CH2_FREQ_LO;
    // First sound-source, higmost 2 bits. 2-7 bits are unused.
    unsigned char CH1_FREQ_HI;
    // Sound control register.
    //   Bit 0-3   : Volume. Maximum value is 8.
    //   Bit 4     : Sound #1 on/off. (implicit squarewave)
    //   Bit 5     : Sound #2 squarewave on/off.
    //   Bit 6     : Sound #2 noise on/off. If You set both, the square will sound.
    //   Bit 7     : D/A mode. See above for more.
    unsigned char SOUND_CONTROL;
    // Bitmap Address and Miscellaneous Control
    //   Bit 0,1   : 2nd sound-source, highmost bits.
    //   Bit 2     : Character generator in ROM or RAM. When set, TED will enable ROM when trying to get data from the
    //               charactergenerator to build screen. Else, it will give out control-signals to the DRAM's.
    //   Bit 3,4,5 : These bits tell, where to find bitplane in the memory when using bitplane-mode. TED assumes them
    //               as A15,A14 and A13 bits. So, the bitplanes can be switched as 8K pages, anywhere in the 64K.
    //   Bit 6-7   : Unused.
    unsigned char MEMORY1;
    // Character Description Map Address and Miscellaneous Control
    //   Bit 0     : A sign to having control about memory paging. This bit always sets to 1 when ROM is active over
    //               $8000. Else, it will be 0. READ ONLY.
    //   Bit 1     : Force single clock mode. Then, TED will disable to generate twice clock.
    //   Bit 2-7   : Charactergenerator. Bit 7 corresponds to A15, 6 to A14 and so on. This value shows and sets the
    //               start of the charactergenerator. It can be paged as $400 bytes. Use with addition of CONTROL3-2.bit.
    unsigned char MEMORY2;
    // Screen Matrix address
    //   Bit 0-2   : Unused
    //   Bit 3-7   : Start of the video-ram. Bit 7 also corresponds to the A15 line as above. So, video-ram is mappable
    //               as $800 bytes - 2K. The above $ff12-2.bit doesn't affect this, but the actual RAM/ROM mapping
    //               (see at $ff3e/$ff3f and $ff13/0) does.
    unsigned char MEMORY3;
    // Background Color. Lower bits contain color-code, higher 3 luminance and highmost is ignored.
    unsigned char BG_COLOR;
    // Color register 1. Used in ECM and MCM modes.
    unsigned char BG_COLOR1;
    // Color register 2. Used in ECM and MCM modes.
    unsigned char BG_COLOR2;
    // Color register 3. Used in ECM and MCM modes.
    unsigned char BG_COLOR3;
    // Border Color. Lower bits contain color-code, higher 3 luminance and higmost is ignored.
    unsigned char BORDER_COLOR;
    // Actual character-position. TED counts the characters that it had fetched and put out to the screen.
    // Lower bits: CHARPOS_LO, higher 2 bits in CHARPOS_HI's 0. and 1. places.
    // The number is increasing by 40 after every characterline (8 rasterline).
    unsigned char CHARPOS_HI;
    unsigned char CHARPOS_LO;
    // Actual position of vertical scanning. Higmost bit is in $ff1c. Read/Writeable!
    unsigned char RASTER_HI;
    unsigned char RASTER_LO;
    // Actual position of horizontal scanning. R/W!. Lowmost bit is unused. It contains the TED's internal counter's
    // highmost 8 bits. So, it increases 4 with every character. When writing, it seems to put the value to a
    // functionally different register (writing back a reading value in right time affects the screen).
    unsigned char HSCAN_POS;
    //   Bit 0,1,2 : Actual vertical scanning-line in a character-row. R/W!.
    //   Bit 3-6   : Flashing counter. It's value increases with every frame, and TED fits it's flashing feature to this
    //               register's reaching to 15.
    //   Bit 7     : Unused
    unsigned char VSCAN_POS;
    // Unused address space
    unsigned char UNUSED[0x1d];
    // Switching to ROM. A writing statement to this address will cause to turn on the ROM between $8000-$ffff. It's an
    // other matter, which one; this time, only sure thing that it'll give CS signals instead of RAS', CAS' and MUX.
    // See $ff13/0 and $ff14
    unsigned char ROM_SWITCH;
    // Switching to RAM. The opposite of ROM_SWITCH.
    unsigned char RAM_SWITCH;
};

