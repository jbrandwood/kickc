// C64 DTV version 2 Registers and Constants
//
// Sources
// (J) https://www.c64-wiki.com/wiki/C64DTV_Programming_Guide
// (H) http://dtvhacking.cbm8bit.com/dtv_wiki/images/d/d9/Dtv_registers_full.txt

#include <c64dtv.h>
#include <c64.h>

// Feature enables or disables the extra C64 DTV features
char* const DTV_FEATURE = $d03f;
const char DTV_FEATURE_ENABLE = 1;
const char DTV_FEATURE_DISABLE_TIL_RESET = 2;

// Controls the graphics modes of the C64 DTV
char* const DTV_CONTROL = $d03c;
const char DTV_LINEAR = $01;
const char DTV_BORDER_OFF = $02;
const char DTV_HIGHCOLOR = $04;
const char DTV_OVERSCAN = $08;
const char DTV_COLORRAM_OFF = $10;
const char DTV_BADLINE_OFF = $20;
const char DTV_CHUNKY = $40;

// Defines colors for the 16 first colors ($00-$0f)
char* const DTV_PALETTE = $d200;

// Default vallues for the palette
char DTV_PALETTE_DEFAULT[16] = { $00, $0f, $36, $be, $58, $db, $86, $ff, $29, $26, $3b, $05, $07, $df, $9a, $0a };

// Linear Graphics Plane A Counter Control
char* const DTV_PLANEA_START_LO = $d03a;
char* const DTV_PLANEA_START_MI = $d03b;
char* const DTV_PLANEA_START_HI = $d045;
char* const DTV_PLANEA_STEP = $d046;
char* const DTV_PLANEA_MODULO_LO = $d038;
char* const DTV_PLANEA_MODULO_HI = $d039;

// Linear Graphics Plane B Counter Control
char* const DTV_PLANEB_START_LO = $d049;
char* const DTV_PLANEB_START_MI = $d04a;
char* const DTV_PLANEB_START_HI = $d04b;
char* const DTV_PLANEB_STEP = $d04c;
char* const DTV_PLANEB_MODULO_LO = $d047;
char* const DTV_PLANEB_MODULO_HI = $d048;

// Select memory bank where sprite data is fetched from (bits 5:0) - source only (J)
// Memory address of Sprite RAM is SpriteBank*$10000
char* const DTV_SPRITE_BANK = $d04d;

// Select memory bank where color data is fetched from (bits 11:0)
// Memory address of Color RAM is ColorBank*$400
char* const DTV_COLOR_BANK_LO = $d036;
char* const DTV_COLOR_BANK_HI = $d037;

const unsigned long DTV_COLOR_BANK_DEFAULT = $1d800;

// Selects memory bank for normal VIC color mode and lower data for high color modes. (bits 5:0)
// Memory address of VIC Graphics is GraphicsBank*$10000
char* const DTV_GRAPHICS_VIC_BANK = $d03d;
// Selects memory bank for upper data for high color modes. (bits 5:0) - source only (H)
char* const DTV_GRAPHICS_HICOL_BANK = $d03e;

// Set the memory pointed to by CPU BANK 1 SEGMENT ($4000-$7fff)
// This sets which actual memory is addressed when the CPU reads/writes to $4000-$7fff
// The actual memory addressed will be $4000*cpuSegmentIdx
void dtvSetCpuBankSegment1(char cpuBankIdx);

// Blitter Source A Start
char* const DTV_BLITTER_SRCA_LO = $d320;
char* const DTV_BLITTER_SRCA_MI = $d321;
char* const DTV_BLITTER_SRCA_HI = $d322;
// Blitter Source A Modulo
char* const DTV_BLITTER_SRCA_MOD_LO = $d323;
char* const DTV_BLITTER_SRCA_MOD_HI = $d324;
// Blitter Source A Line Length
char* const DTV_BLITTER_SRCA_LIN_LO = $d325;
char* const DTV_BLITTER_SRCA_LIN_HI = $d326;
// Blitter Source A Step ([7:4] integral part, [3:0] fractional part)
char* const DTV_BLITTER_SRCA_STEP = $d327;
// Blitter Source B Start
char* const DTV_BLITTER_SRCB_LO = $d328;
char* const DTV_BLITTER_SRCB_MI = $d329;
char* const DTV_BLITTER_SRCB_HI = $d32a;
// Blitter Source B Modulo
char* const DTV_BLITTER_SRCB_MOD_LO = $d32b;
char* const DTV_BLITTER_SRCB_MOD_HI = $d32c;
// Blitter Source B Line Length
char* const DTV_BLITTER_SRCB_LIN_LO = $d32d;
char* const DTV_BLITTER_SRCB_LIN_HI = $d32e;
// Blitter Source B Step ([7:4] integral part, [3:0] fractional part)
char* const DTV_BLITTER_SRCB_STEP = $d32f;
// Blitter Destination Start
char* const DTV_BLITTER_DEST_LO = $d330;
char* const DTV_BLITTER_DEST_MI = $d331;
char* const DTV_BLITTER_DEST_HI = $d332;
// Blitter Source B Modulo
char* const DTV_BLITTER_DEST_MOD_LO = $d333;
char* const DTV_BLITTER_DEST_MOD_HI = $d334;
// Blitter Source B Line Length
char* const DTV_BLITTER_DEST_LIN_LO = $d335;
char* const DTV_BLITTER_DEST_LIN_HI = $d336;
// Blitter Source B Step ([7:4] integral part, [3:0] fractional part)
char* const DTV_BLITTER_DEST_STEP = $d337;
// Blitter Blit Length
char* const DTV_BLITTER_LEN_LO = $d338;
char* const DTV_BLITTER_LEN_HI = $d339;
// Blitter Control
char* const DTV_BLITTER_CONTROL = $d33a;
// Bit[0] Force Start Strobe when set
const char  DTV_BLIT_FORCE_START    = %00000001;
// Bit[1] Source A Direction Positive when set
const char  DTV_BLIT_SRCA_FWD       = %00000010;
// Bit[2] Source B Direction Positive when set
const char  DTV_BLIT_SRCB_FWD       = %00000100;
// Bit[3] Destination Direction Positive when set
const char  DTV_BLIT_DEST_FWD       = %00001000;
// Bit[4] VIC IRQ Start when set
const char  DTV_BLIT_VIC_IRQ        = %00010000;
// Bit[5] CIA IRQ Start when set($DCXX CIA)
const char  DTV_BLIT_CIA_IRQ        = %00100000;
// Bit[6] V Blank Start when set
const char  DTV_BLIT_VBLANK         = %01000000;
// Bit[7] Blitter IRQ Enable when set
const char  DTV_BLIT_IRQ_EN         = %10000000;
// Blitter Transparency
char* const DTV_BLITTER_TRANSPARANCY = $d33b;
// Bit[0]   Disable Channel B.
// (data into b port of ALU is forced to %00000000. ALU functions as normal)
const char  DTV_BLIT_DISABLE_B          = %00000001;
// Bit[1]   Write Transparent Data when set
//(Data will be written if source a data *IS* %00000000.  This can be used with channel b and ALU set to OR to write Data masked by source A.) Cycles will be saved if No writes.
const char  DTV_BLIT_WRITE_TRANSPARENT     = %00000010;
// Bit[2]   Write Non Transparent
// when set (Data will be written if SourceA fetched data is *NOT* %00000000.  This may be used combined with channel b data and/or ALU) Cycles will be Saved if no write. Bit[2]==Bit[1]==0: write in any case
const char  DTV_BLIT_WRITE_NONTRANSPARENT  = %00000100;
// No transparancy
// Bit[2]==Bit[1]==0: write in any case
const char  DTV_BLIT_TRANSPARANCY_NONE     = %00000000;
// Controls the ALU operation
char* DTV_BLITTER_ALU = $d33e;
// Bit[2:0] Source A right Shift: 000 SourceA Data,  001 LastA[0],SourceA[7:1], ...,  111 LastA[6:0],SourceA[7]
const char DTV_BLIT_SHIFT0  = %00000000;
const char DTV_BLIT_SHIFT1  = %00000001;
const char DTV_BLIT_SHIFT2  = %00000010;
const char DTV_BLIT_SHIFT3  = %00000011;
const char DTV_BLIT_SHIFT4  = %00000100;
const char DTV_BLIT_SHIFT5  = %00000101;
const char DTV_BLIT_SHIFT6  = %00000110;
const char DTV_BLIT_SHIFT7  = %00000111;
// Bit[5:3] Minterms/ALU
const char DTV_BLIT_AND     = %00000000;
const char DTV_BLIT_NAND    = %00001000;
const char DTV_BLIT_NOR     = %00010000;
const char DTV_BLIT_OR      = %00011000;
const char DTV_BLIT_XOR     = %00100000;
const char DTV_BLIT_XNOR    = %00101000;
const char DTV_BLIT_ADD     = %00110000;
const char DTV_BLIT_SUB     = %00111000;
// Blitter Control 2
char* const DTV_BLITTER_CONTROL2 = $d33f;
// Bit[0] Clear Blitter IRQ
const char  DTV_BLIT_CLEAR_IRQ      = %00000001;
// Bit[1] Source A Continue
const char  DTV_BLIT_SRCA_CONT      = %00000010;
// Bit[2] Source B Continue
const char  DTV_BLIT_SRCB_CONT      = %00000100;
// Bit[3] Destination Continue
const char  DTV_BLIT_DEST_CONT      = %00001000;
// Bit[0] Busy when set (When reading)
const char  DTV_BLIT_STATUS_BUSY    = %00000001;
// Bit[1] IRQ when set (When reading)
const char  DTV_BLIT_STATUS_IRQ     = %00000010;
