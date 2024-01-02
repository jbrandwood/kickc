/// @file
/// C64 DTV version 2 Registers and Constants
///
/// Sources
/// (J) https://www.c64-wiki.com/wiki/C64DTV_Programming_Guide
/// (H) http://dtvhacking.cbm8bit.com/dtv_wiki/images/d/d9/Dtv_registers_full.txt

#include <c64dtv.h>
#include <c64.h>

/// Feature enables or disables the extra C64 DTV features
char* const DTV_FEATURE = (char*)0xd03f;
const char DTV_FEATURE_ENABLE = 1;
const char DTV_FEATURE_DISABLE_TIL_RESET = 2;

/// Controls the graphics modes of the C64 DTV
char* const DTV_CONTROL = (char*)0xd03c;
const char DTV_LINEAR = 0x01;
const char DTV_BORDER_OFF = 0x02;
const char DTV_HIGHCOLOR = 0x04;
const char DTV_OVERSCAN = 0x08;
const char DTV_COLORRAM_OFF = 0x10;
const char DTV_BADLINE_OFF = 0x20;
const char DTV_CHUNKY = 0x40;

/// Defines colors for the 16 first colors ($00-$0f)
char* const DTV_PALETTE = (char*)0xd200;

/// Default vallues for the palette
char DTV_PALETTE_DEFAULT[16] = { 0x00, 0x0f, 0x36, 0xbe, 0x58, 0xdb, 0x86, 0xff, 0x29, 0x26, 0x3b, 0x05, 0x07, 0xdf, 0x9a, 0x0a };

/// Linear Graphics Plane A Counter Control
char* const DTV_PLANEA_START_LO = (char*)0xd03a;
char* const DTV_PLANEA_START_MI = (char*)0xd03b;
char* const DTV_PLANEA_START_HI = (char*)0xd045;
char* const DTV_PLANEA_STEP = (char*)0xd046;
char* const DTV_PLANEA_MODULO_LO = (char*)0xd038;
char* const DTV_PLANEA_MODULO_HI = (char*)0xd039;

/// Linear Graphics Plane B Counter Control
char* const DTV_PLANEB_START_LO = (char*)0xd049;
char* const DTV_PLANEB_START_MI = (char*)0xd04a;
char* const DTV_PLANEB_START_HI = (char*)0xd04b;
char* const DTV_PLANEB_STEP = (char*)0xd04c;
char* const DTV_PLANEB_MODULO_LO = (char*)0xd047;
char* const DTV_PLANEB_MODULO_HI = (char*)0xd048;

/// Select memory bank where sprite data is fetched from (bits 5:0) - source only (J)
/// Memory address of Sprite RAM is SpriteBank*$10000
char* const DTV_SPRITE_BANK = (char*)0xd04d;

/// Select memory bank where color data is fetched from (bits 11:0)
/// Memory address of Color RAM is ColorBank*$400
char* const DTV_COLOR_BANK_LO = (char*)0xd036;
char* const DTV_COLOR_BANK_HI = (char*)0xd037;

const unsigned long DTV_COLOR_BANK_DEFAULT = 0x1d800;

/// Selects memory bank for normal VIC color mode and lower data for high color modes. (bits 5:0)
/// Memory address of VIC Graphics is GraphicsBank*$10000
char* const DTV_GRAPHICS_VIC_BANK = (char*)0xd03d;
/// Selects memory bank for upper data for high color modes. (bits 5:0) - source only (H)
char* const DTV_GRAPHICS_HICOL_BANK = (char*)0xd03e;

/// Set the memory pointed to by CPU BANK 1 SEGMENT ($4000-$7fff)
/// This sets which actual memory is addressed when the CPU reads/writes to $4000-$7fff
/// The actual memory addressed will be $4000*cpuSegmentIdx
void dtvSetCpuBankSegment1(char cpuBankIdx);

/// Blitter Source A Start
char* const DTV_BLITTER_SRCA_LO = (char*)0xd320;
char* const DTV_BLITTER_SRCA_MI = (char*)0xd321;
char* const DTV_BLITTER_SRCA_HI = (char*)0xd322;
/// Blitter Source A Modulo
char* const DTV_BLITTER_SRCA_MOD_LO = (char*)0xd323;
char* const DTV_BLITTER_SRCA_MOD_HI = (char*)0xd324;
/// Blitter Source A Line Length
char* const DTV_BLITTER_SRCA_LIN_LO = (char*)0xd325;
char* const DTV_BLITTER_SRCA_LIN_HI = (char*)0xd326;
/// Blitter Source A Step ([7:4] integral part, [3:0] fractional part)
char* const DTV_BLITTER_SRCA_STEP = (char*)0xd327;
/// Blitter Source B Start
char* const DTV_BLITTER_SRCB_LO = (char*)0xd328;
char* const DTV_BLITTER_SRCB_MI = (char*)0xd329;
char* const DTV_BLITTER_SRCB_HI = (char*)0xd32a;
/// Blitter Source B Modulo
char* const DTV_BLITTER_SRCB_MOD_LO = (char*)0xd32b;
char* const DTV_BLITTER_SRCB_MOD_HI = (char*)0xd32c;
/// Blitter Source B Line Length
char* const DTV_BLITTER_SRCB_LIN_LO = (char*)0xd32d;
char* const DTV_BLITTER_SRCB_LIN_HI = (char*)0xd32e;
/// Blitter Source B Step ([7:4] integral part, [3:0] fractional part)
char* const DTV_BLITTER_SRCB_STEP = (char*)0xd32f;
/// Blitter Destination Start
char* const DTV_BLITTER_DEST_LO = (char*)0xd330;
char* const DTV_BLITTER_DEST_MI = (char*)0xd331;
char* const DTV_BLITTER_DEST_HI = (char*)0xd332;
/// Blitter Source B Modulo
char* const DTV_BLITTER_DEST_MOD_LO = (char*)0xd333;
char* const DTV_BLITTER_DEST_MOD_HI = (char*)0xd334;
/// Blitter Source B Line Length
char* const DTV_BLITTER_DEST_LIN_LO = (char*)0xd335;
char* const DTV_BLITTER_DEST_LIN_HI = (char*)0xd336;
/// Blitter Source B Step ([7:4] integral part, [3:0] fractional part)
char* const DTV_BLITTER_DEST_STEP = (char*)0xd337;
/// Blitter Blit Length
char* const DTV_BLITTER_LEN_LO = (char*)0xd338;
char* const DTV_BLITTER_LEN_HI = (char*)0xd339;
/// Blitter Control
char* const DTV_BLITTER_CONTROL = (char*)0xd33a;
/// Bit[0] Force Start Strobe when set
const char  DTV_BLIT_FORCE_START    = 0b00000001;
/// Bit[1] Source A Direction Positive when set
const char  DTV_BLIT_SRCA_FWD       = 0b00000010;
/// Bit[2] Source B Direction Positive when set
const char  DTV_BLIT_SRCB_FWD       = 0b00000100;
/// Bit[3] Destination Direction Positive when set
const char  DTV_BLIT_DEST_FWD       = 0b00001000;
/// Bit[4] VIC IRQ Start when set
const char  DTV_BLIT_VIC_IRQ        = 0b00010000;
/// Bit[5] CIA IRQ Start when set($DCXX CIA)
const char  DTV_BLIT_CIA_IRQ        = 0b00100000;
/// Bit[6] V Blank Start when set
const char  DTV_BLIT_VBLANK         = 0b01000000;
/// Bit[7] Blitter IRQ Enable when set
const char  DTV_BLIT_IRQ_EN         = 0b10000000;
/// Blitter Transparency
char* const DTV_BLITTER_TRANSPARANCY = (char*)0xd33b;
/// Bit[0]   Disable Channel B.
/// (data into b port of ALU is forced to %00000000. ALU functions as normal)
const char  DTV_BLIT_DISABLE_B          = 0b00000001;
/// Bit[1]   Write Transparent Data when set
//(Data will be written if source a data *IS* %00000000.  This can be used with channel b and ALU set to OR to write Data masked by source A.) Cycles will be saved if No writes.
const char  DTV_BLIT_WRITE_TRANSPARENT     = 0b00000010;
/// Bit[2]   Write Non Transparent
/// when set (Data will be written if SourceA fetched data is *NOT* %00000000.  This may be used combined with channel b data and/or ALU) Cycles will be Saved if no write. Bit[2]==Bit[1]==0: write in any case
const char  DTV_BLIT_WRITE_NONTRANSPARENT  = 0b00000100;
/// No transparancy
/// Bit[2]==Bit[1]==0: write in any case
const char  DTV_BLIT_TRANSPARANCY_NONE     = 0b00000000;
/// Controls the ALU operation
char* DTV_BLITTER_ALU = (char*)0xd33e;
/// Bit[2:0] Source A right Shift: 000 SourceA Data,  001 LastA[0],SourceA[7:1], ...,  111 LastA[6:0],SourceA[7]
const char DTV_BLIT_SHIFT0  = 0b00000000;
const char DTV_BLIT_SHIFT1  = 0b00000001;
const char DTV_BLIT_SHIFT2  = 0b00000010;
const char DTV_BLIT_SHIFT3  = 0b00000011;
const char DTV_BLIT_SHIFT4  = 0b00000100;
const char DTV_BLIT_SHIFT5  = 0b00000101;
const char DTV_BLIT_SHIFT6  = 0b00000110;
const char DTV_BLIT_SHIFT7  = 0b00000111;
/// Bit[5:3] Minterms/ALU
const char DTV_BLIT_AND     = 0b00000000;
const char DTV_BLIT_NAND    = 0b00001000;
const char DTV_BLIT_NOR     = 0b00010000;
const char DTV_BLIT_OR      = 0b00011000;
const char DTV_BLIT_XOR     = 0b00100000;
const char DTV_BLIT_XNOR    = 0b00101000;
const char DTV_BLIT_ADD     = 0b00110000;
const char DTV_BLIT_SUB     = 0b00111000;
/// Blitter Control 2
char* const DTV_BLITTER_CONTROL2 = (char*)0xd33f;
/// Bit[0] Clear Blitter IRQ
const char  DTV_BLIT_CLEAR_IRQ      = 0b00000001;
/// Bit[1] Source A Continue
const char  DTV_BLIT_SRCA_CONT      = 0b00000010;
/// Bit[2] Source B Continue
const char  DTV_BLIT_SRCB_CONT      = 0b00000100;
/// Bit[3] Destination Continue
const char  DTV_BLIT_DEST_CONT      = 0b00001000;
/// Bit[0] Busy when set (When reading)
const char  DTV_BLIT_STATUS_BUSY    = 0b00000001;
/// Bit[1] IRQ when set (When reading)
const char  DTV_BLIT_STATUS_IRQ     = 0b00000010;
