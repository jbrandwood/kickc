// MOS 6567 / 6569 Video Interface Chip (VIC II)
//  http://archive.6502.org/datasheets/mos_6567_vic_ii_preliminary.pdf
struct MOS6569_VICII {
  char SPRITE0_X;
  char SPRITE0_Y;
  char SPRITE1_X;
  char SPRITE1_Y;
  char SPRITE2_X;
  char SPRITE2_Y;
  char SPRITE3_X;
  char SPRITE3_Y;
  char SPRITE4_X;
  char SPRITE4_Y;
  char SPRITE5_X;
  char SPRITE5_Y;
  char SPRITE6_X;
  char SPRITE6_Y;
  char SPRITE7_X;
  char SPRITE7_Y;
  char SPRITES_XMSB;
  char CONTROL1;
  char RASTER;
  char LIGHTPEN_X;
  char LIGHTPEN_Y;
  char SPRITES_ENABLE;
  char CONTROL2;
  char SPRITES_EXPAND_Y;
  char MEMORY;
  char IRQ_STATUS;
  char IRQ_ENABLE;
  char SPRITES_PRIORITY;
  char SPRITES_MC;
  char SPRITES_EXPAND_X;
  char SPRITES_COLLISION;
  char SPRITES_BG_COLLISION;
  char BORDER_COLOR;
  char BG_COLOR;
  char BG_COLOR1;
  char BG_COLOR2;
  char BG_COLOR3;
  char SPRITES_MCOLOR1;
  char SPRITES_MCOLOR2;
  char SPRITE0_COLOR;
  char SPRITE1_COLOR;
  char SPRITE2_COLOR;
  char SPRITE3_COLOR;
  char SPRITE4_COLOR;
  char SPRITE5_COLOR;
  char SPRITE6_COLOR;
  char SPRITE7_COLOR;
};

// Positions of the border (in sprite positions)
const char BORDER_XPOS_LEFT=24;
const unsigned int BORDER_XPOS_RIGHT=344;
const char BORDER_YPOS_TOP=50;
const char BORDER_YPOS_BOTTOM=250;

// The offset of the sprite pointers from the screen start address
const unsigned int SPRITE_PTRS = $3f8;

char*  const SPRITES_XPOS = $d000;
char*  const SPRITES_YPOS = $d001;
char*  const SPRITES_XMSB = $d010;
char*  const RASTER = $d012;
char*  const SPRITES_ENABLE = $d015;
char*  const SPRITES_EXPAND_Y = $d017;
char*  const SPRITES_PRIORITY = $d01b;
char*  const SPRITES_MC = $d01c;
char*  const SPRITES_EXPAND_X = $d01d;
char*  const BORDERCOL = $d020;
char*  const BGCOL = $d021;
char*  const BGCOL1 = $d021;
char*  const BGCOL2 = $d022;
char*  const BGCOL3 = $d023;
char*  const BGCOL4 = $d024;
char*  const SPRITES_MC1 = $d025;
char*  const SPRITES_MC2 = $d026;
char*  const SPRITES_COLS = $d027;

char*  const VIC_CONTROL = $d011;
char*  const D011 = $d011;

const char VIC_RST8 = %10000000;
const char VIC_ECM =  %01000000;
const char VIC_BMM =  %00100000;
const char VIC_DEN =  %00010000;
const char VIC_RSEL = %00001000;

char*  const VIC_CONTROL2 = $d016;
char*  const D016 = $d016;

const char VIC_MCM =  %00010000;
const char VIC_CSEL = %00001000;

char*  const D018 = $d018;
char*  const VIC_MEMORY = $d018;

// VIC II IRQ Status Register
char*  const IRQ_STATUS = $d019;
// VIC II IRQ Enable Register
char*  const IRQ_ENABLE = $d01a;

// Bits for the VICII IRQ Status/Enable Registers
const char IRQ_RASTER = %00000001;
const char IRQ_COLLISION_BG = %00000010;
const char IRQ_COLLISION_SPRITE = %00000100;
const char IRQ_LIGHTPEN = %00001000;
