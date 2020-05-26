// Ricoh 2C02 - NES Picture Processing Unit (PPU)
// Ricoh RP2C02 (NTSC version) / RP2C07 (PAL version),
// https://en.wikipedia.org/wiki/Picture_Processing_Unit
// https://wiki.nesdev.com/w/index.php/PPU_registers
// http://nesdev.com/2C02%20technical%20reference.TXT
// Based on: https://github.com/gregkrsak/first_nes written by Greg M. Krsak, 2018. 

// PPU Memory Map
// $0000-$0fff	$1000	Pattern table 0
char * const PPU_PATTERN_TABLE_0 = 0x0000;
// $1000-$1fff	$1000	Pattern table 1
char * const PPU_PATTERN_TABLE_1 = 0x1000;
// $2000-$23bf	$03c0	Name table 0
char * const PPU_NAME_TABLE_0 = 0x2000;
// $23c0-$23ff	$0040	Attribute table 0
char * const PPU_ATTRIBUTE_TABLE_0 = 0x23c0;
// $2400-$27bf	$03c0	Name table 1
char * const PPU_NAME_TABLE_1 = 0x2400;
// $27c0-$27ff	$0040	Attribute table 1
char * const PPU_ATTRIBUTE_TABLE_1 = 0x27c0;
// $2800-$2bbf	$03c0	Name table 2
char * const PPU_NAME_TABLE_2 = 0x2800;
// $2bc0-$2bff	$0040	Attribute table 2
char * const PPU_ATTRIBUTE_TABLE_2 = 0x2bc0;
// $2c00-$2fbf	$03c0	Name table 3
char * const PPU_NAME_TABLE_3 = 0x2c00;
// $2fc0-$2fff	$0040	Attribute table 3
char * const PPU_ATTRIBUTE_TABLE_3 = 0x2fc0;
// $3000-$3eff	$0f00	Mirrors of $2000-$2eff
// $3f00-$3f1f	$0020	Palette RAM indexes
char * const PPU_PALETTE = 0x3f00;
// $3f20-$3fff	$00e0	Mirrors of $3f00-$3f1f

struct RICOH_2C02 { 
    // ------+-----+---------------------------------------------------------------
    // $2000 | RW  | PPU Control Register 1
    //       | 0-1 | Name Table Address:
    //       |     |
    //       |     |           +-----------+-----------+
    //       |     |           | 2 ($2800) | 3 ($2C00) |
    //       |     |           +-----------+-----------+
    //       |     |           | 0 ($2000) | 1 ($2400) |
    //       |     |           +-----------+-----------+
    //       |     |
    //       |     | Remember that because of the mirroring there are only 2  
    //       |     | real Name Tables, not 4. Also, PPU will automatically
    //       |     | switch to another Name Table when running off the current
    //       |     | Name Table during scroll (see picture above).
    //       |   2 | Vertical Write, 1 = PPU memory address increments by 32:
    //       |     |
    //       |     |    Name Table, VW=0          Name Table, VW=1
    //       |     |   +----------------+        +----------------+
    //       |     |   |----> write     |        | | write        |
    //       |     |   |                |        | V              |
    //       |     |
    //       |   3 | Sprite Pattern Table Address, 1 = $1000, 0 = $0000.
    //       |   4 | Screen Pattern Table Address, 1 = $1000, 0 = $0000.
    //       |   5 | Sprite Size, 1 = 8x16, 0 = 8x8.
    //       |   6 | PPU Master/Slave Mode, not used in NES.
    //       |   7 | VBlank Enable, 1 = generate interrupts on VBlank.
    // ------+-----+---------------------------------------------------------------
    char PPUCTRL;           // Reference: https://wiki.nesdev.com/w/index.php/PPU_registers#PPUCTRL
    // ------+-----+---------------------------------------------------------------
    // $2001 | RW  | PPU Control Register 2
    //       |   0 | Unknown (???)
    //       |   1 | Image Mask, 0 = don't show left 8 columns of the screen.
    //       |   2 | Sprite Mask, 0 = don't show sprites in left 8 columns. 
    //       |   3 | Screen Enable, 1 = show picture, 0 = blank screen.
    //       |   4 | Sprites Enable, 1 = show sprites, 0 = hide sprites.
    //       | 5-7 | Background Color, 0 = black, 1 = blue, 2 = green, 4 = red.
    //       |     | Do not use any other numbers as you may damage PPU hardware.
    // ------+-----+---------------------------------------------------------------
    char PPUMASK;        // Reference: https://wiki.nesdev.com/w/index.php/PPU_registers#PPUMASK
    // ------+-----+---------------------------------------------------------------
    // $2002 | R   | PPU Status Register
    //       | 0-5 | Unknown (???)
    //       |   6 | Hit Flag, 1 = Sprite refresh has hit sprite #0.
    //       |     | This flag resets to 0 when screen refresh starts.
    //       |   7 | VBlank Flag, 1 = PPU is in VBlank state.
    //       |     | This flag resets to 0 when VBlank ends or CPU reads $2002.
    // ------+-----+---------------------------------------------------------------
    volatile char PPUSTATUS;         // Reference: https://wiki.nesdev.com/w/index.php/PPU_registers#PPUSTATUS
    // The OAM (Object Attribute Memory) is internal memory inside the PPU that contains a lookup table 
    // of up to 64 sprites, where each table entry consists of 4 bytes.
    // ------+-----+---------------------------------------------------------------
    // $2003 | W   | Sprite Memory Address
    //       |     | Used to set the address of the 256-byte Sprite Memory to be 
    //       |     | accessed via $2004. This address will increment by 1 after
    //       |     | each access to $2004. Sprite Memory contains coordinates,
    //       |     | colors, and other sprite attributes.
    // ------+-----+---------------------------------------------------------------
    char OAMADDR;           // Reference: https://wiki.nesdev.com/w/index.php/PPU_registers#OAMADDR
    // ------+-----+---------------------------------------------------------------
    // $2004 | RW  | Sprite Memory Data
    //       |     | Used to read/write the Sprite Memory. The address is set via
    //       |     | $2003 and increments by 1 after each access. Sprite Memory 
    //       |     | contains coordinates, colors, and other sprite attributes
    //       |     | sprites.
    // ------+-----+---------------------------------------------------------------
    char OAMDATA;           // Reference: https://wiki.nesdev.com/w/index.php/PPU_registers#OAMDATA
    // ------+-----+---------------------------------------------------------------
    // $2005 | W   | Screen Scroll Offsets
    //       |     | There are two scroll registers, vertical and horizontal, 
    //       |     | which are both written via this port. The first value written
    //       |     | will go into the Vertical Scroll Register (unless it is >239,
    //       |     | then it will be ignored). The second value will appear in the
    //       |     | Horizontal Scroll Register. Name Tables are assumed to be
    //       |     | arranged in the following way:
    //       |     |
    //       |     |           +-----------+-----------+
    //       |     |           | 2 ($2800) | 3 ($2C00) |
    //       |     |           +-----------+-----------+
    //       |     |           | 0 ($2000) | 1 ($2400) |
    //       |     |           +-----------+-----------+
    //       |     |
    //       |     | When scrolled, the picture may span over several Name Tables.
    //       |     | Remember that because of the mirroring there are only 2 real
    //       |     | Name Tables, not 4.
    // ------+-----+---------------------------------------------------------------
    char PPUSCROLL;         // Reference: https://wiki.nesdev.com/w/index.php/PPU_registers#PPUSCROLL
    // ------+-----+---------------------------------------------------------------
    // $2006 | W   | PPU Memory Address
    //       |     | Used to set the address of PPU Memory to be accessed via
    //       |     | $2007. The first write to this register will set 8 lower
    //       |     | address bits. The second write will set 6 upper bits. The
    //       |     | address will increment either by 1 or by 32 after each
    //       |     | access to $2007.
    // ------+-----+---------------------------------------------------------------
    char PPUADDR;           // Reference: https://wiki.nesdev.com/w/index.php/PPU_registers#PPUADDR
    // ------+-----+---------------------------------------------------------------
    // $2007 | RW  | PPU Memory Data
    //       |     | Used to read/write the PPU Memory. The address is set via
    //       |     | $2006 and increments after each access, either by 1 or by 32.
    // ------+-----+---------------------------------------------------------------
    char PPUDATA;           // Reference: https://wiki.nesdev.com/w/index.php/PPU_registers#PPUDATA
};

// PPU Status Register for reading in ASM
volatile char * PPU_PPUSTATUS = 0x2002;

