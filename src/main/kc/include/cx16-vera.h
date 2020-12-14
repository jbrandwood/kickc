// Commander X16 VERA (Versatile Embedded Retro Adapter) Video and Audio Processor
// https://github.com/commanderx16/x16-docs/blob/master/VERA%20Programmer's%20Reference.md

// To access the VRAM (which is 128kB in size) an indirection mechanism is used.
// First the address to be accessed needs to be set (ADDRx_L/ADDRx_M/ADDRx_H) and
// then the data on that VRAM address can be read from or written to via the DATA0/1 register.
// To make accessing the VRAM more efficient an auto-increment mechanism is present.
// These 3 registers are multiplexed using the ADDR_SEL in the CTRL register.
// When ADDR_SEL = 0, ADDRx_L/ADDRx_M/ADDRx_H become ADDR0_L/ADDR0_M/ADDR0_H.
// When ADDR_SEL = 1, ADDRx_L/ADDRx_M/ADDRx_H become ADDR1_L/ADDR1_M/ADDR1_H.

// $9F20 VRAM Address (7:0)
char * const VERA_ADDRC_L = 0x9f20;
// $9F21 VRAM Address (15:8)
char * const VERA_ADDRX_M = 0x9f21;
// $9F22 VRAM Address (7:0)
// Bit 4-7: Address Increment  The following is the amount incremented per value value:increment
//                             0:0, 1:1, 2:2, 3:4, 4:8, 5:16, 6:32, 7:64, 8:128, 9:256, 10:512, 11:40, 12:80, 13:160, 14:320, 15:640
// Bit 3: DECR Setting the DECR bit, will decrement instead of increment by the value set by the 'Address Increment' field.
// Bit 0: VRAM Address (16)
char * const VERA_ADDRX_H = 0x9f22;
// $9F23	DATA0	VRAM Data port 0
char * const VERA_DATA0 = 0x9f23;
// $9F24	DATA1	VRAM Data port 1
char * const VERA_DATA1 = 0x9f24;
// $9F25	CTRL Control
// Bit 7: Reset
// Bit 1: DCSEL
// Bit 2: ADDRSEL
char * const VERA_CTRL = 0x9f25;
const char VERA_DCSEL	= 2;
const char VERA_ADDRSEL	= 1;
// $9F26	IEN		Interrupt Enable
// Bit 7: IRQ line (8)
// Bit 3: AFLOW
// Bit 2: SPRCOL
// Bit 1: LINE
// Bit 0: VSYNC
char * const VERA_IEN = 0x9f26;
const char VERA_AFLOW	= 8;
const char VERA_SPRCOL	= 4;
const char VERA_LINE	= 2;
const char VERA_VSYNC	= 1;
// $9F27	ISR     Interrupt Status
// Interrupts will be generated for the interrupt sources set in the lower 4 bits of IEN. ISR will indicate the interrupts that have occurred.
// Writing a 1 to one of the lower 3 bits in ISR will clear that interrupt status. AFLOW can only be cleared by filling the audio FIFO for at least 1/4.
// Bit 4-7: Sprite Collisions. This field indicates which groups of sprites have collided.
// Bit 3: AFLOW
// Bit 2: SPRCOL
// Bit 1: LINE
// Bit 0: VSYNC
char * const VERA_ISR = 0x9f27;
// $9F28	IRQLINE_L	IRQ line (7:0)
// IRQ_LINE specifies at which line the LINE interrupt will be generated.
// Note that bit 8 of this value is present in the IEN register.
// For interlaced modes the interrupt will be generated each field and the bit 0 of IRQ_LINE is ignored.
char * const VERA_IRQLINE_L = 0x9f28;
// $9F29	DC_VIDEO (DCSEL=0)
// Bit 7: Current Field     Read-only bit which reflects the active interlaced field in composite and RGB modes. (0: even, 1: odd)
// Bit 6: Sprites Enable	Enable output from the Sprites renderer
// Bit 5: Layer1 Enable	    Enable output from the Layer1 renderer
// Bit 4: Layer0 Enable	    Enable output from the Layer0 renderer
// Bit 2: Chroma Disable    Setting 'Chroma Disable' disables output of chroma in NTSC composite mode and will give a better picture on a monochrome display. (Setting this bit will also disable the chroma output on the S-video output.)
// Bit 0-1: Output Mode     0: Video disabled, 1: VGA output, 2: NTSC composite, 3: RGB interlaced, composite sync (via VGA connector)
char * const VERA_DC_VIDEO = 0x9f29;
// $9F2A	DC_HSCALE (DCSEL=0)	Active Display H-Scale
char * const VERA_DC_HSCALE = 0x9f2a;
// $9F2B	DC_VSCALE (DCSEL=0)	Active Display V-Scale
char * const VERA_DC_VSCALE = 0x9f2b;
// $9F2C	DC_BORDER (DCSEL=0)	Border Color
char * const VERA_DC_BORDER = 0x9f2c;
// $9F29	DC_HSTART (DCSEL=1)	Active Display H-Start (9:2)
char * const VERA_DC_HSTART = 0x9f29;
// $9F2A	DC_HSTOP (DCSEL=1)	Active Display H-Stop (9:2)
char * const VERA_DC_HSTOP = 0x9f2a;
// $9F2B	DC_VSTART (DCSEL=1)	Active Display V-Start (8:1)
char * const VERA_DC_VSTART = 0x9f2b;
// $9F2C	DC_VSTOP (DCSEL=1)	Active Display V-Stop (8:1)
char * const VERA_DC_VSTOP = 0x9f2c;
// $9F2D	L0_CONFIG   Layer 0 Configuration
// Bit 6-7: Map Height	(0:32 tiles, 1:64 tiles, 2:128 tiles, 3:256 tiles)
// Bit 4-5. Map Width	(0:32 tiles, 1:64 tiles, 2:128 tiles, 3:256 tiles)
// Bit 3: T256C	        (0: tiles use a 16-color foreground and background color, 1: tiles use a 256-color foreground color) (only relevant in 1bpp modes)
// Bit 2: Bitmap Mode	(0:tile mode, 1: bitmap mode)
// Bit 0-1: Color Depth (0: 1 bpp, 1: 2 bpp, 2: 4 bpp, 3: 8 bpp)
char * const VERA_L0_CONFIG = 0x9f2d;
// $9F2E	L0_MAPBASE	    Layer 0 Map Base Address (16:9)
char * const VERA_L0_MAPBASE = 0x9f2e;
// $9F2F	L0_TILEBASE	    Layer 0 Tile Base
// Bit 2-7: Tile Base Address (16:11)
// Bit 1:   Tile Height (0:8 pixels, 1:16 pixels)
// Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
char * const VERA_L0_TILEBASE = 0x9f2f;
// $9F30	L0_HSCROLL_L	Layer 0 H-Scroll (7:0)
char * const VERA_L0_HSCROLL_L = 0x9f30;
// $9F31	L0_HSCROLL_H	Layer 0 H-Scroll (11:8)
char * const VERA_L0_HSCROLL_H = 0x9f31;
// $9F32	L0_VSCROLL_L	Layer 0 V-Scroll (7:0)
char * const VERA_L0_VSCROLL_L = 0x9f32;
// $9F33	L0_VSCROLL_H    Layer 0 V-Scroll (11:8)
char * const VERA_L0_VSCROLL_H = 0x9f33;
// $9F34	L1_CONFIG   Layer 1 Configuration
// Bit 6-7: Map Height	(0:32 tiles, 1:64 tiles, 2:128 tiles, 3:256 tiles)
// Bit 4-5. Map Width	(0:32 tiles, 1:64 tiles, 2:128 tiles, 3:256 tiles)
// Bit 3: T256C	        (0: tiles use a 16-color foreground and background color, 1: tiles use a 256-color foreground color) (only relevant in 1bpp modes)
// Bit 2: Bitmap Mode	(0:tile mode, 1: bitmap mode)
// Bit 0-1: Color Depth (0: 1 bpp, 1: 2 bpp, 2: 4 bpp, 3: 8 bpp)
char * const VERA_L1_CONFIG = 0x9f34;
// $9F35	L1_MAPBASE	    Layer 1 Map Base Address (16:9)
char * const VERA_L1_MAPBASE = 0x9f35;
// $9F36	L1_TILEBASE	    Layer 1 Tile Base
// Bit 2-7: Tile Base Address (16:11)
// Bit 1:   Tile Height (0:8 pixels, 1:16 pixels)
// Bit 0:	Tile Width (0:8 pixels, 1:16 pixels)
char * const VERA_L1_TILEBASE = 0x9f36;
// $9F37	L1_HSCROLL_L	Layer 1 H-Scroll (7:0)
char * const VERA_L1_HSCROLL_L = 0x9f37;
// $9F38	L1_HSCROLL_H	Layer 1 H-Scroll (11:8)
char * const VERA_L1_HSCROLL_H = 0x9f38;
// $9F39	L1_VSCROLL_L	Layer 1 V-Scroll (7:0)
char * const VERA_L1_VSCROLL_L = 0x9f39;
// $9F3A	L1_VSCROLL_H	Layer 1 V-Scroll (11:8)
char * const VERA_L1_VSCROLL_H = 0x9f3a;
// $9F3B	AUDIO_CTRL
// Bit 7:   FIFO Full / FIFO Reset
// Bit 5:   16-Bit
// Bit 4:   Stereo
// Bit 0-3: PCM Volume
char * const VERA_AUDIO_CTRL = 0x9f3b;
// $9F3C	AUDIO_RATE	PCM Sample Rate
char * const VERA_AUDIO_RATE = 0x9f3c;
// $9F3D	AUDIO_DATA	Audio FIFO data (write-only)
char * const VERA_AUDIO_DATA = 0x9f3d;
// $9F3E	SPI_DATA	SPI Data
char * const VERA_SPI_DATA = 0x9f3e;
// $9F3F	SPI_CTRL	SPI Control
// Bit 7:   Busy
// Bit 1:   Slow clock
// Bit 0:   Select
char * const VERA_SPI_CTRL = 0x9f3f;