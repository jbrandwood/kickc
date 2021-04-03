// Test hardware line drawing
// Based on https://github.com/MEGA65/mega65-tools/blob/master/src/tests/test_290.c

#pragma target(mega65)
#include <mega65.h>
#include <mega65-dma.h>
#include <6502.h>

// Get the 0th byte of a double value
#define BYTE0(d) <(<(d))
// Get the 1th byte of a double value
#define BYTE1(d) >(<(d))
// Get the 2th byte of a double value
#define BYTE2(d) <(>(d))
// Get the 3th byte of a double value
#define BYTE3(d) >(>(d))
// Get the low byte from a word/int
#define LOBYTE(w) <(w)
// Get the high byte from a word/int
#define HIBYTE(w) >(w)

// Poke a byte value into memory
#define POKE(addr,val) *((char*)(addr)) = val
// Peek a byte value from memory
#define PEEK(addr) *((char*)addr)

// Poke a value directly into memory
// - addr: The 32bit address to poke to
// - val: The value to poke
void lpoke(__zp unsigned long addr, char val) {
    // Use the 45GS02 32-bit addressing mode
    asm {
        ldz #0
        lda val
        sta ((addr)),z
    }
}

// DMA command structure for drawing lines
// Graphics mode is 1 byte per pixel. Addressing is based on columns of 8px * 200px arranged to have linear addressing.
// addr = (x/8) * 64 * 25 + (y*8) + (x&7)
char line_dma_command[] = {
  DMA_OPTION_LINE_XSTEP_LO, LOBYTE(25*64 - 8),  // Line X step bytes 64x25 
  DMA_OPTION_LINE_XSTEP_HI, HIBYTE(25*64 - 8),  // Line X step bytes 64x25 
  DMA_OPTION_LINE_SLOPE_LO, 0,                  // Line Slope
  DMA_OPTION_LINE_SLOPE_HI, 0,                  // Line Slope
  DMA_OPTION_LINE_SLOPE_INIT_LO, LOBYTE(32768), // Line slope init
  DMA_OPTION_LINE_SLOPE_INIT_HI, HIBYTE(32768), // Line slope init
  DMA_OPTION_LINE_MODE, 0,                      // Line Mode
  DMA_OPTION_FORMAT_F018A,                      // F018A list format
  DMA_OPTION_END,                               // end of options
  DMA_COMMAND_FILL,                             // DMA command
  0, 0,                                         // Count of bytes to copy/fill
  0, 0,                                         // Source address
  0,                                            // Source bank
  0, 0,                                         // Destination address
  0,                                            // Destination bank
  0, 0                                          // Modulo value (unused)
};

// Offset of the DMA line SLOPE
const char LINE_DMA_COMMAND_SLOPE_OFFSET = 5;
// Offset of the DMA line MODE
const char LINE_DMA_COMMAND_MODE_OFFSET = 13;
// Offset of the DMA count
const char LINE_DMA_COMMAND_COUNT_OFFSET = 17;
// Offset of the DMA source
const char LINE_DMA_COMMAND_SRC_OFFSET = 19;
// Offset of the DMA destination
const char LINE_DMA_COMMAND_DEST_OFFSET = 22;

void line_dma_execute(unsigned long addr, unsigned int slope, unsigned int count, char colour, char is_direction_y, char is_slope_negative) {

    // Put slope into DMA options
    line_dma_command[LINE_DMA_COMMAND_SLOPE_OFFSET] = LOBYTE(slope);
    line_dma_command[LINE_DMA_COMMAND_SLOPE_OFFSET + 2] = HIBYTE(slope);

    // Load DMA dest address with the address of the first pixel
    line_dma_command[LINE_DMA_COMMAND_DEST_OFFSET + 0] = BYTE0(addr);
    line_dma_command[LINE_DMA_COMMAND_DEST_OFFSET + 1] = BYTE1(addr);
    line_dma_command[LINE_DMA_COMMAND_DEST_OFFSET + 2] = BYTE2(addr);

    // Source is the colour
    line_dma_command[LINE_DMA_COMMAND_SRC_OFFSET] = colour;

    // Count is number of pixels, i.e., dy.
    line_dma_command[LINE_DMA_COMMAND_COUNT_OFFSET] = LOBYTE(count);
    line_dma_command[LINE_DMA_COMMAND_COUNT_OFFSET + 1] = HIBYTE(count);

    // Line mode active, major axis is Y
    line_dma_command[LINE_DMA_COMMAND_MODE_OFFSET] = DMA_OPTION_LINE_MODE_ENABLE + (is_direction_y ? DMA_OPTION_LINE_MODE_DIRECTION_Y : 0x00) + (is_slope_negative ? DMA_OPTION_LINE_MODE_SLOPE_NEGATIVE : 0x00);

    // Set address of DMA list
    DMA->ADDRMB = 0;
    DMA->ADDRBANK = 0;
    DMA-> ADDRMSB = HIBYTE(line_dma_command);
    // Trigger the DMA (with option lists)
    DMA-> ETRIG = LOBYTE(line_dma_command);
}

void main() {

  // Avoid interrupts
  SEI();
  // Map memory to BANK 0 : 0x00XXXX - giving access to I/O
  memoryRemap(0x00,0,0);
  // Fast CPU, M65 IO
  POKE(0, 65);
  // Enable MEGA65 features
  VICIV->KEY = VICIV_KEY_M65_A;
  VICIV->KEY = VICIV_KEY_M65_B;
  // No C65 ROMs are mapped
  VICIV->CONTROLA = 0;
  // Enable 48MHz fast mode
  VICIV->CONTROLB |= VICIV_FAST;
  VICIV->CONTROLC |= VICIV_VFAST;

  graphics_mode();

  //draw_line(150, 0, 160, 40, 5);
  //draw_line(160, 0, 160, 40, 6);
  //draw_line(170, 0, 160, 40, 7);

  /*
  draw_line(160, 100,   0, 199, 1);    
  draw_line(160, 100, 319, 199, 2);  
  draw_line(  0,   0, 160, 100, 3);  
  draw_line(160, 100, 319, 0, 4);  
  */

  for(int x1=0;x1<320;x1+=10) {
      draw_line(x1, 0, 160, 199, 5);      
      draw_line(160, 0, x1, 199, 5);      
  }

  for(int y1=0;y1<200;y1+=10) {
      draw_line(0, y1, 319, 100, 6);
      draw_line(0, 100, 319, y1, 6);
  }

  for(;;) ;
  
}

// Address of the screen
unsigned char * const SCREEN = 0xc000;
// // Absolute address of the graphics
const unsigned long GRAPHICS = 0x40000;

void graphics_mode(void) {
  // 16-bit text mode, full-colour text for high chars
  VICIV->CONTROLC = VICIV_FCLRHI | VICIV_CHR16;
  // H320, fast CPU
  VICIV->CONTROLB = VICIV_FAST;
  // 320x200 per char, 16 pixels wide per char
  // = 320/8 x 16 bits = 80 bytes per row
  VICIV->CHARSTEP_LO = 80;
  VICIV->CHARSTEP_HI = 0;
  // Draw 40 chars per row
  VICIV->CHRCOUNT = 40;
  // Put 2KB screen at $C000
  VICIV->SCRNPTR_LOLO = LOBYTE(SCREEN);
  VICIV->SCRNPTR_LOHI = HIBYTE(SCREEN);
  VICIV->SCRNPTR_HILO = 0x00;
 
  // Layout screen so that graphics data comes from $40000 -- $4FFFF
  // Each column is consequtive values
  unsigned int * screen = (unsigned int *)SCREEN;
  unsigned int ch = (unsigned int)(GRAPHICS / 0x40);
  for(char y=0;y<25;y++) {
    unsigned int ch_x = ch;
    for(char x=0;x<40;x++) {
      screen[x] = ch_x;
      ch_x += 25;      
    }
    screen += 40;
    ch++;
  }  

  // Clear colour RAM
  memset_dma256(0xff, 0x08, 0x0000, 0, 2000);

  // Black border and background
  VICIV->BORDER_COLOR = 0;
  VICIV->BG_COLOR = 0;

  // Fill the graphics
  memset_dma256(0x0, 0x4, 0x0000, 0x0b, 320*200);
  memset_dma256(0x0, 0x4, 0x0000, 0x0c, 8*200);
  memset_dma256(0x0, 0x4, 0x0000+200*39*8, 0x0c, 8*200);

}

void draw_line(int x1, int y1, int x2, int y2, unsigned char colour) {
  // Ignore if we choose to draw a point
  if (x2 == x1 && y2 == y1)
    return;

  int dx = x2 - x1;
  int dy = y2 - y1;
  if (dx < 0)
    dx = -dx;
  if (dy < 0)
    dy = -dy;

  // Draw line from x1,y1 to x2,y2
  if (dx < dy) {
    // Y is major axis

    if (y2 < y1) {
      int temp = x1;
      x1 = x2;
      x2 = temp;
      temp = y1;
      y1 = y2;
      y2 = temp;
    }

    // Use hardware divider to get the slope 
    *MATH_MULTINA_INT0 = dx;
    *MATH_MULTINB_INT0 = dy;
    *MATH_MULTINA_INT1 = 0;
    *MATH_MULTINB_INT1 = 0;
    
    // Wait 16 cycles
    asm {
      lda MATH_DIVOUT_FRAC_INT1 @nooptimize
      lda MATH_DIVOUT_FRAC_INT1 @nooptimize
      lda MATH_DIVOUT_FRAC_INT1 @nooptimize
      lda MATH_DIVOUT_FRAC_INT1 @nooptimize
    }
    // Slope is the most significant bytes of the fractional part of the division result
    // Perform rounding by examining the next bit also
    unsigned int slope = (unsigned int)*MATH_DIVOUT_FRAC_INT1 + (((char)*MATH_DIVOUT_FRAC_CHAR1&0x80)?1:0);
    unsigned int slope_init = 32768;
    unsigned long addr = GRAPHICS + (unsigned int)(x1/8) * 64 * 25 + (unsigned int)(y1*8) + (unsigned char)(x1&7);
    unsigned int count = (unsigned int)dy;
    char is_slope_negative = ((x2 - x1) < 0)?1:0;
    line_dma_execute(addr, slope, count, colour, 1, is_slope_negative);
  } else {
    // X is major axis

    if (x2 < x1) {
      int temp = x1;
      x1 = x2;
      x2 = temp;
      temp = y1;
      y1 = y2;
      y2 = temp;
    }

    // Use hardware divider to get the slope 
    *MATH_MULTINA_INT0 = dy;
    *MATH_MULTINB_INT0 = dx;
    *MATH_MULTINA_INT1 = 0;
    *MATH_MULTINB_INT1 = 0;

    // Wait 16 cycles
    asm {
      lda MATH_DIVOUT_FRAC_INT1 @nooptimize
      lda MATH_DIVOUT_FRAC_INT1 @nooptimize
      lda MATH_DIVOUT_FRAC_INT1 @nooptimize
      lda MATH_DIVOUT_FRAC_INT1 @nooptimize
    }

    // Slope is the most significant bytes of the fractional part of the division result
    // Perform rounding by examining the next bit also
    unsigned int slope = (unsigned int)*MATH_DIVOUT_FRAC_INT1 + (((char)*MATH_DIVOUT_FRAC_CHAR1&0x80)?1:0);
    unsigned long addr = GRAPHICS + (unsigned int)(x1/8) * 64 * 25 + (unsigned int)(y1*8) + (unsigned char)(x1&7);
    unsigned int count = (unsigned int)dx;
    char is_slope_negative = ((y2 - y1) < 0) ? 1 : 0;
    line_dma_execute(addr, slope, count, colour, 0, is_slope_negative);    

  }
}