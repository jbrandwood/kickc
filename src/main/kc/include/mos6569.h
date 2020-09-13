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
  // $D020 Border Color
  char BORDER_COLOR;
  // $D021 Background Color 0
  char BG_COLOR;
  // $D022 Background Color 1
  char BG_COLOR1;
  // $D023 Background Color 2
  char BG_COLOR2;
  // $D024 Background Color 3
  char BG_COLOR3;
  // $D025 Sprite multicolor 0
  char SPRITES_MCOLOR1;
  // $D026 Sprite multicolor 1
  char SPRITES_MCOLOR2;
  // $D027 Color Sprite 0
  char SPRITE0_COLOR;
  // $D028 Color Sprite 1
  char SPRITE1_COLOR;
  // $D029 Color Sprite 2
  char SPRITE2_COLOR;
  // $D02a Color Sprite 3
  char SPRITE3_COLOR;
  // $D02b Color Sprite 4
  char SPRITE4_COLOR;
  // $D02c Color Sprite 5
  char SPRITE5_COLOR;
  // $D02d Color Sprite 6
  char SPRITE6_COLOR;
  // $D02e Color Sprite 7
  char SPRITE7_COLOR;
};

// Positions of the border (in sprite positions)
const char BORDER_XPOS_LEFT=24;
const unsigned int BORDER_XPOS_RIGHT=344;
const char BORDER_YPOS_TOP=50;
const char BORDER_YPOS_BOTTOM=250;

// The offset of the sprite pointers from the screen start address
const unsigned int SPRITE_PTRS = $3f8;

char * const SPRITES_XPOS = $d000;
char * const SPRITES_YPOS = $d001;
char * const SPRITES_XMSB = $d010;
char * const SPRITES_COLOR = $d027;
char*  const SPRITES_ENABLE = $d015;
char*  const SPRITES_EXPAND_Y = $d017;
char*  const SPRITES_PRIORITY = $d01b;
char*  const SPRITES_MC = $d01c;
char*  const SPRITES_EXPAND_X = $d01d;

char*  const RASTER = $d012;
char*  const BORDER_COLOR = $d020;
char*  const BG_COLOR = $d021;
char*  const BG_COLOR0 = $d021;
char*  const BG_COLOR1 = $d022;
char*  const BG_COLOR2 = $d023;
char*  const BG_COLOR3 = $d024;
char*  const SPRITES_MC1 = $d025;
char*  const SPRITES_MC2 = $d026;

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

char*  const VIC_MEMORY = $d018;
char*  const D018 = $d018;

// VIC II IRQ Status Register
char*  const IRQ_STATUS = $d019;
// VIC II IRQ Enable Register
char*  const IRQ_ENABLE = $d01a;

// Bits for the VICII IRQ Status/Enable Registers
const char IRQ_RASTER = %00000001;
const char IRQ_COLLISION_BG = %00000010;
const char IRQ_COLLISION_SPRITE = %00000100;
const char IRQ_LIGHTPEN = %00001000;
