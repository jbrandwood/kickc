/// @file
/// Commander X16 VERA (Versatile Embedded Retro Adapter) Video and Audio Processor
///
/// https://github.com/commanderx16/x16-docs/blob/master/VERA%20Programmer's%20Reference.md

// Location of default PETSCII character tiles in the VERA
unsigned int const VERA_PETSCII_TILE = 0xF800;
unsigned int const VERA_PETSCII_TILE_SIZE = 0x0800;

/// To access the VRAM (which is 128kB in size) an indirection mechanism is used.
/// First the address to be accessed needs to be set (ADDRx_L/ADDRx_M/ADDRx_H) and
/// then the data on that VRAM address can be read from or written to via the DATA0/1 register.
/// To make accessing the VRAM more efficient an auto-increment mechanism is present.
/// These 3 registers are multiplexed using the ADDR_SEL in the CTRL register.
/// When ADDR_SEL = 0, ADDRx_L/ADDRx_M/ADDRx_H become ADDR0_L/ADDR0_M/ADDR0_H.
/// When ADDR_SEL = 1, ADDRx_L/ADDRx_M/ADDRx_H become ADDR1_L/ADDR1_M/ADDR1_H.
/// See https://github.com/commanderx16/x16-emulator/wiki/(VERA-0.8)-Registers-$9F23-and-$9F24-(and-$9F25)

/// $9F20 VRAM Address (7:0)
char* const VERA_ADDRX_L = (char*)0x9f20;
/// $9F21 VRAM Address (15:8)
char* const VERA_ADDRX_M = (char*)0x9f21;
/// $9F22 VRAM Address (7:0)
/// Bit 4-7: Address Increment  The following is the amount incremented per value value:increment
///                             0:0, 1:1, 2:2, 3:4, 4:8, 5:16, 6:32, 7:64, 8:128, 9:256, 10:512, 11:40, 12:80, 13:160, 14:320, 15:640
/// Bit 3: DECR Setting the DECR bit, will decrement instead of increment by the value set by the 'Address Increment' field.
/// Bit 0: VRAM Address (16)
char* const VERA_ADDRX_H = (char*)0x9f22;
char const VERA_INC_0 = 0x00;
char const VERA_INC_1 = 0x10;
char const VERA_INC_2 = 0x20;
char const VERA_INC_4 = 0x30;
char const VERA_INC_8 = 0x40;
char const VERA_INC_16 = 0x50;
char const VERA_INC_32 = 0x60;
char const VERA_INC_64 = 0x70;
char const VERA_INC_128 = 0x80;
char const VERA_INC_256 = 0x90;
char const VERA_INC_512 = 0xa0;
char const VERA_INC_40 = 0xb0;
char const VERA_INC_80 = 0xc0;
char const VERA_INC_160 = 0xd0;
char const VERA_INC_320 = 0xe0;
char const VERA_INC_640 = 0xf0;
char const VERA_DECR_0 = 0x08;
char const VERA_DECR_1 = 0x18;
char const VERA_DECR_2 = 0x28;
char const VERA_DECR_4 = 0x38;
char const VERA_DECR_8 = 0x48;
char const VERA_DECR_16 = 0x58;
char const VERA_DECR_32 = 0x68;
char const VERA_DECR_64 = 0x78;
char const VERA_DECR_128 = 0x88;
char const VERA_DECR_256 = 0x98;
char const VERA_DECR_512 = 0xa8;
char const VERA_DECR_40 = 0xb8;
char const VERA_DECR_80 = 0xc8;
char const VERA_DECR_160 = 0xd8;
char const VERA_DECR_320 = 0xe8;
char const VERA_DECR_640 = 0xf8;
/// $9F23	DATA0	VRAM Data port 0
char* const VERA_DATA0 = (char*)0x9f23;
/// $9F24	DATA1	VRAM Data port 1
char* const VERA_DATA1 = (char*)0x9f24;
/// $9F25	CTRL Control
/// Bit 7: Reset
/// Bit 1: DCSEL
/// Bit 2: ADDRSEL
char* const VERA_CTRL = (char*)0x9f25;
char const VERA_DCSEL	= 2;
char const VERA_ADDRSEL	= 1;
/// $9F26	IEN		Interrupt Enable
/// Bit 7: IRQ line (8)
/// Bit 3: AFLOW
/// Bit 2: SPRCOL
/// Bit 1: LINE
/// Bit 0: VSYNC
char* const VERA_IEN = (char*)0x9f26;
char const VERA_AFLOW	= 8;
char const VERA_SPRCOL	= 4;
char const VERA_LINE	= 2;
char const VERA_VSYNC	= 1;
/// $9F27	ISR     Interrupt Status
/// Interrupts will be generated for the interrupt sources set in the lower 4 bits of IEN. ISR will indicate the interrupts that have occurred.
/// Writing a 1 to one of the lower 3 bits in ISR will clear that interrupt status. AFLOW can only be cleared by filling the audio FIFO for at least 1/4.
/// Bit 4-7: Sprite Collisions. This field indicates which groups of sprites have collided.
/// Bit 3: AFLOW
/// Bit 2: SPRCOL
/// Bit 1: LINE
/// Bit 0: VSYNC
char* const VERA_ISR = (char*)0x9f27;
/// $9F28	IRQLINE_L	IRQ line (7:0)
/// IRQ_LINE specifies at which line the LINE interrupt will be generated.
/// Note that bit 8 of this value is present in the IEN register.
/// For interlaced modes the interrupt will be generated each field and the bit 0 of IRQ_LINE is ignored.
char* const VERA_IRQLINE_L = (char*)0x9f28;

/// $9F29	DC_VIDEO (DCSEL=0)
/// Bit 7: Current Field     Read-only bit which reflects the active interlaced field in composite and RGB modes. (0: even, 1: odd)
/// Bit 6: Sprites Enable	Enable output from the Sprites renderer
/// Bit 5: Layer1 Enable	    Enable output from the Layer1 renderer
/// Bit 4: Layer0 Enable	    Enable output from the Layer0 renderer
/// Bit 2: Chroma Disable    Setting 'Chroma Disable' disables output of chroma in NTSC composite mode and will give a better picture on a monochrome display. (Setting this bit will also disable the chroma output on the S-video output.)
/// Bit 0-1: Output Mode     0: Video disabled, 1: VGA output, 2: NTSC composite, 3: RGB interlaced, composite sync (via VGA connector)
char* const VERA_DC_VIDEO = (char*)0x9f29;
char const VERA_SPRITES_ENABLE = 0x40;
char const VERA_SPRITES_COLLISIONS = 0x04;
char const VERA_LAYER1_ENABLE = 0x20;
char const VERA_LAYER0_ENABLE = 0x10;
char const VERA_CROMA_DISABLE = 0x04;
char const VERA_OUTPUT_DISABLE = 0x00;
char const VERA_OUTPUT_VGA = 0x01;
char const VERA_OUTPUT_NTSC = 0x02;
char const VERA_OUTPUT_RGB = 0x03;
/// $9F2A	DC_HSCALE (DCSEL=0)	Active Display H-Scale
char* const VERA_DC_HSCALE = (char*)0x9f2a;
/// $9F2B	DC_VSCALE (DCSEL=0)	Active Display V-Scale
char* const VERA_DC_VSCALE = (char*)0x9f2b;
/// $9F2C	DC_BORDER (DCSEL=0)	Border Color
char* const VERA_DC_BORDER = (char*)0x9f2c;
/// $9F29	DC_HSTART (DCSEL=1)	Active Display H-Start (9:2)
char* const VERA_DC_HSTART = (char*)0x9f29;
/// $9F2A	DC_HSTOP (DCSEL=1)	Active Display H-Stop (9:2)
char* const VERA_DC_HSTOP = (char*)0x9f2a;
/// $9F2B	DC_VSTART (DCSEL=1)	Active Display V-Start (8:1)
char* const VERA_DC_VSTART = (char*)0x9f2b;
/// $9F2C	DC_VSTOP (DCSEL=1)	Active Display V-Stop (8:1)
char* const VERA_DC_VSTOP = (char*)0x9f2c;

/// Configuration work tables

/// Bit 4-5. Map Width	(0:32 tiles, 1:64 tiles, 2:128 tiles, 3:256 tiles)
char const VERA_LAYER_WIDTH_32 = 0x00;
char const VERA_LAYER_WIDTH_64 = 0x10;
char const VERA_LAYER_WIDTH_128 = 0x20;
char const VERA_LAYER_WIDTH_256 = 0x30;
char const VERA_LAYER_WIDTH_MASK = 0x30;
unsigned int const VERA_LAYER_WIDTH[4] = {32, 64, 128, 256};

/// Bit 6-7: Map Height	(0:32 tiles, 1:64 tiles, 2:128 tiles, 3:256 tiles)
char const VERA_LAYER_HEIGHT_32 = 0x00;
char const VERA_LAYER_HEIGHT_64 = 0x40;
char const VERA_LAYER_HEIGHT_128 = 0x80;
char const VERA_LAYER_HEIGHT_256 = 0xC0;
char const VERA_LAYER_HEIGHT_MASK = 0xC0;
unsigned int const VERA_LAYER_HEIGHT[4] = {32, 64, 128, 256};

const unsigned int VERA_LAYER_SKIP[4] = {64, 128, 256, 512};

/// Bit 0-1: Color Depth (0: 1 bpp, 1: 2 bpp, 2: 4 bpp, 3: 8 bpp)
char const VERA_LAYER_COLOR_DEPTH_1BPP = 0x00;
char const VERA_LAYER_COLOR_DEPTH_2BPP = 0x01;
char const VERA_LAYER_COLOR_DEPTH_4BPP = 0x02;
char const VERA_LAYER_COLOR_DEPTH_8BPP = 0x03;
char const VERA_LAYER_COLOR_DEPTH_MASK = 0x03;
char const VERA_LAYER_COLOR_DEPTH[4] = {1, 2, 4, 8};

/// $9F2D	L0_CONFIG   Layer 0 Configuration
char* const VERA_L0_CONFIG = (char*)0x9f2d;
/// Bit 2: Bitmap Mode	(0:tile mode, 1: bitmap mode)
char const VERA_LAYER_CONFIG_MODE_TILE = 0x00;
char const VERA_LAYER_CONFIG_MODE_BITMAP = 0x04;
/// Bit 3: T256C	        (0: tiles use a 16-color foreground and background color, 1: tiles use a 256-color foreground color) (only relevant in 1bpp modes)
char const VERA_LAYER_CONFIG_16C = 0x00;
char const VERA_LAYER_CONFIG_256C = 0x08;
/// $9F2E	L0_MAPBASE	    Layer 0 Map Base Address (16:9)
char* const VERA_L0_MAPBASE = (char*)0x9f2e;
/// $9F2F	L0_TILEBASE	    Layer 0 Tile Base
/// Bit 2-7: Tile Base Address (16:11)
/// Bit 1:   Tile Height (0:8 pixels, 1:16 pixels)
char const VERA_TILEBASE_WIDTH_8 = 0x00;
char const VERA_TILEBASE_WIDTH_16 = 0x01;
char const VERA_TILEBASE_WIDTH_MASK = 0x01;
char const VERA_TILEBASE_HEIGHT_8 = 0x00;
char const VERA_TILEBASE_HEIGHT_16 = 0x02;
char const VERA_TILEBASE_HEIGHT_MASK = 0x02;
char const VERA_LAYER_TILEBASE_MASK = 0xfC;
/// Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
char* const VERA_L0_TILEBASE = (char*)0x9f2f;
/// $9F30	L0_HSCROLL_L	Layer 0 H-Scroll (7:0)
char* const VERA_L0_HSCROLL_L = (char*)0x9f30;
/// $9F31	L0_HSCROLL_H	Layer 0 H-Scroll (11:8)
char* const VERA_L0_HSCROLL_H = (char*)0x9f31;
/// $9F32	L0_VSCROLL_L	Layer 0 V-Scroll (7:0)
char* const VERA_L0_VSCROLL_L = (char*)0x9f32;
/// $9F33	L0_VSCROLL_H    Layer 0 V-Scroll (11:8)
char* const VERA_L0_VSCROLL_H = (char*)0x9f33;
/// $9F34	L1_CONFIG   Layer 1 Configuration
char* const VERA_L1_CONFIG = (char*)0x9f34;
/// $9F35	L1_MAPBASE	    Layer 1 Map Base Address (16:9)
char* const VERA_L1_MAPBASE = (char*)0x9f35;
/// $9F36	L1_TILEBASE	    Layer 1 Tile Base
/// Bit 2-7: Tile Base Address (16:11)
/// Bit 1:   Tile Height (0:8 pixels, 1:16 pixels)
/// Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
char* const VERA_L1_TILEBASE = (char*)0x9f36;
/// $9F37	L1_HSCROLL_L	Layer 1 H-Scroll (7:0)
char* const VERA_L1_HSCROLL_L = (char*)0x9f37;
/// $9F38	L1_HSCROLL_H	Layer 1 H-Scroll (11:8)
char* const VERA_L1_HSCROLL_H = (char*)0x9f38;
/// $9F39	L1_VSCROLL_L	Layer 1 V-Scroll (7:0)
char* const VERA_L1_VSCROLL_L = (char*)0x9f39;
/// $9F3A	L1_VSCROLL_H	Layer 1 V-Scroll (11:8)
char* const VERA_L1_VSCROLL_H = (char*)0x9f3a;
/// $9F3B	AUDIO_CTRL
/// Bit 7:   FIFO Full / FIFO Reset
/// Bit 5:   16-Bit
/// Bit 4:   Stereo
/// Bit 0-3: PCM Volume
char* const VERA_AUDIO_CTRL = (char*)0x9f3b;
/// $9F3C	AUDIO_RATE	PCM Sample Rate
char* const VERA_AUDIO_RATE = (char*)0x9f3c;
/// $9F3D	AUDIO_DATA	Audio FIFO data (write-only)
char* const VERA_AUDIO_DATA = (char*)0x9f3d;
/// $9F3E	SPI_DATA	SPI Data
char* const VERA_SPI_DATA = (char*)0x9f3e;
/// $9F3F	SPI_CTRL	SPI Control
/// Bit 7:   Busy
/// Bit 1:   Slow clock
/// Bit 0:   Select
char* const VERA_SPI_CTRL = (char*)0x9f3f;

// VERA Palette address in VRAM  $1FA00 - $1FBFF
// 256 entries of 2 bytes
// byte 0 bits 4-7: Green
// byte 0 bits 0-3: Blue
// byte 1 bits 0-3: Red
char const VERA_PALETTE_BANK = 0x1;
char* const VERA_PALETTE_PTR = (char*)0xFA00;
const unsigned long VERA_PALETTE = 0x1FA00;

/// Sprite Attributes address in VERA VRAM $1FC00 - $1FFFF
const unsigned long VERA_SPRITE_ATTR = 0x1FC00;

/// The VERA structure of a sprite (8 bytes)
/// 128*8 bytes located at $1FC00-$1FFFF
struct VERA_SPRITE {
    /// 0-1 ADDRESS Address and mode
    /// - bits 0-11: Address (16:5)
    /// - bits 15: Mode (0:4 bpp 1:8 bpp)
    unsigned int ADDR;
    /// 2-3	X (9:0)
    unsigned int X;
    /// 4-5	Y (9:0)
    unsigned int Y;
    /// 6 CTRL1 Control 1
    /// - bits 4-7 Collision mask
    /// - bits 2-3 Z-depth ( 0:Sprite disabled, 1:Sprite between background and layer 0, 2:Sprite between layer 0 and layer 1, 3:Sprite in front of layer 1 )
    /// - bits   1 V-flip
    /// - bits   0 H-flip
    char CTRL1;
    /// 7 CTRL2 Control 2
    /// - bits 6-7 Sprite height ( 0:8 pixels, 1:16 pixels, 2:32 pixels, 3:64 pixels )
    /// - bits 4-5 Sprite width ( 0:8 pixels, 1:16 pixels, 2:32 pixels, 3:64 pixels )
    /// - bits 0-3 Palette offset (if 4bpp Color index 1-15 is modified by adding 16 x palette offset)
    char CTRL2;
};

// xBPP sprite modes
#define VERA_SPRITE_4BPP                                    0x00
#define VERA_SPRITE_8BPP                                    0x80
#define VERA_SPRITE_MASKBPP                                 0x80

// Sprite flip
#define VERA_SPRITE_HFLIP                                   0x01 // Horizontal flip of sprite
#define VERA_SPRITE_VFLIP                                   0x02 // Vertical flip of sprite
#define VERA_SPRITE_NFLIP                                   0x00 // No flip of sprite

// Sprite ZDepth
#define VERA_SPRITE_ZDEPTH_DISABLED                         0x00
#define VERA_SPRITE_ZDEPTH_BETWEEN_BACKGROUND_AND_LAYER0    0x04
#define VERA_SPRITE_ZDEPTH_BETWEEN_LAYER0_AND_LAYER1        0x08
#define VERA_SPRITE_ZDEPTH_IN_FRONT                         0x0C
#define VERA_SPRITE_ZDEPTH_MASK                             0x0C

// Sprite width
#define VERA_SPRITE_WIDTH_8                                 0x00
#define VERA_SPRITE_WIDTH_16                                0x10
#define VERA_SPRITE_WIDTH_32                                0x20
#define VERA_SPRITE_WIDTH_64                                0x30
#define VERA_SPRITE_WIDTH_MASK                              0x30

// Sprite height
#define VERA_SPRITE_HEIGHT_8                                0x00
#define VERA_SPRITE_HEIGHT_16                               0x40
#define VERA_SPRITE_HEIGHT_32                               0x80
#define VERA_SPRITE_HEIGHT_64                               0xC0
#define VERA_SPRITE_HEIGHT_MASK                             0xC0

char const VERA_SPRITE_PALETTE_OFFSET_MASK = 0x0F;

char const VERA_SPRITE_COLLISION_MASK = 0xF0;
