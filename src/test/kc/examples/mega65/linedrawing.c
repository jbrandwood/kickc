// Test hardware line drawing
// Based on https://github.com/MEGA65/mega65-tools/blob/master/src/tests/test_290.c

#pragma target(mega65)
#include <mega65.h>
#include <mega65-dma.h>
#include <6502.h>

#define POKE(addr,val) *((char*)(addr)) = val
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
char line_dma_command[] = {
  DMA_OPTION_LINE_XSTEP_LO, (25*64 - 8) & 0xff, // Line X step bytes 64x25 = 1600
  DMA_OPTION_LINE_XSTEP_HI, (25*64 - 8) >> 8,   // Line X step bytes 64x25 = 1600
  DMA_OPTION_LINE_SLOPE_LO, 0,                  // Line Slope
  DMA_OPTION_LINE_SLOPE_HI, 0,                  // Line Slope
  DMA_OPTION_LINE_MODE, 0,                      // Line Mode
  DMA_OPTION_FORMAT_F018A,                      // F018A list format
  DMA_OPTION_END,                               // end of options
  0,                                            // DMA command
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
const char LINE_DMA_COMMAND_MODE_OFFSET = 9;
// Offset of the DMA command
const char LINE_DMA_COMMAND_COMMAND_OFFSET = 12;
// Offset of the DMA count
const char LINE_DMA_COMMAND_COUNT_OFFSET = 13;
// Offset of the DMA source
const char LINE_DMA_COMMAND_SRC_OFFSET = 15;
// Offset of the DMA destination
const char LINE_DMA_COMMAND_DEST_OFFSET = 18;

void main() {

  // Avoid interrupts
  SEI();

  // Map memory to BANK 0 : 0x00XXXX - giving access to I/O
  memoryRemap(0x00,0,0);
  // Fast CPU, M65 IO
  POKE(0, 65);
  POKE(0xD02F, 0x47);
  POKE(0xD02F, 0x53);    
  // No C65 ROMs are mapped
  POKE(0xD030, 0x00);    

  graphics_mode();



    //draw_line(160, 100, 0, 198, 1);  
    
    draw_line(160, 100, 319, 198, 1);  

    for(;;) ;

/*
  int x1 = 160;
  for(int x2=0;x2<320;x2+=11) {
    draw_line(x1, 100, x2, 198, 1);  
  }
  */

  
}


void graphics_mode(void) {

  // 16-bit text mode, full-colour text for high chars
  POKE(0xD054, 0x05);
  // H320, fast CPU
  POKE(0xD031, 0x40);
  // 320x200 per char, 16 pixels wide per char
  // = 320/8 x 16 bits = 80 bytes per row
  POKE(0xD058, 80);
  POKE(0xD059, 80 / 256);
  // Draw 40 chars per row
  POKE(0xD05E, 40);
  
  // Put 2KB screen at $C000
  POKE(0xD060, 0x00);
  POKE(0xD061, 0xc0);
  POKE(0xD062, 0x00);
 
  // Layout screen so that graphics data comes from $40000 -- $4FFFF
  unsigned int i = 0x40000 / 0x40;
  for (unsigned int a = 0; a < 40; a++)
    for (unsigned int b = 0; b < 25; b++) {
      POKE(0xC000 + b * 80 + a * 2 + 0, (char)(i & 0xff));
      POKE(0xC000 + b * 80 + a * 2 + 1, (char)(i >> 8));
      i++;
    }

  // Clear colour RAM
  for (unsigned int i = 0; i < 2000; i++) {
    lpoke(0xff80000l + 0 + i, 0x00);
    lpoke(0xff80000l + 1 + i, 0x00);
  }

  // Black border and background
  POKE(0xD020, 0);
  POKE(0xD021, 0);

  // Fill the graphics
  memset_dma256(0x0, 0x4, 0x0000, 0x0b, 320*200);
  memset_dma256(0x0, 0x4, 0x0000, 0x0c, 8*200);
  memset_dma256(0x0, 0x4, 0x0000+200*39*8, 0x0c, 8*200);

}


void draw_line(int x1, int y1, int x2, int y2, unsigned char colour)
{
  long addr;
  int temp, slope, dx, dy;

  // Ignore if we choose to draw a point
  if (x2 == x1 && y2 == y1)
    return;

  dx = x2 - x1;
  dy = y2 - y1;
  if (dx < 0)
    dx = -dx;
  if (dy < 0)
    dy = -dy;

  //  snprintf(msg,41,"(%d,%d) - (%d,%d)    ",x1,y1,x2,y2);
  //  print_text(0,1,1,msg);

  // Draw line from x1,y1 to x2,y2
  if (dx < dy) {
    // Y is major axis

    if (y2 < y1) {
      temp = x1;
      x1 = x2;
      x2 = temp;
      temp = y1;
      y1 = y2;
      y2 = temp;
    }

    // Use hardware divider to get the slope
    POKE(0xD770, (char)(dx & 0xff));
    POKE(0xD771, (char)(dx >> 8));
    POKE(0xD772, 0);
    POKE(0xD773, 0);
    POKE(0xD774, (char)(dy & 0xff));
    POKE(0xD775, (char)(dy >> 8));
    POKE(0xD776, 0);
    POKE(0xD777, 0);

    // Wait 16 cycles
    POKE(0xD020, 0);
    POKE(0xD020, 0);
    POKE(0xD020, 0);
    POKE(0xD020, 0);

    // Slope is the most significant bytes of the fractional part
    // of the division result
    slope = (int)PEEK(0xD76A) + ((int)PEEK(0xD76B) << 8);

    // Put slope into DMA options
    line_dma_command[LINE_DMA_COMMAND_SLOPE_OFFSET] = (char)(slope & 0xff);
    line_dma_command[LINE_DMA_COMMAND_SLOPE_OFFSET + 2] = (char)(slope >> 8);

    // Load DMA dest address with the address of the first pixel
    addr = 0x40000 + (y1 << 3) + (x1 & 7) + (x1 >> 3) * 64 * 25l;
    line_dma_command[LINE_DMA_COMMAND_DEST_OFFSET + 0] = <(<(addr));
    line_dma_command[LINE_DMA_COMMAND_DEST_OFFSET + 1] = >(<(addr));
    line_dma_command[LINE_DMA_COMMAND_DEST_OFFSET + 2] = <(>(addr));

    // Source is the colour
    line_dma_command[LINE_DMA_COMMAND_SRC_OFFSET] = colour & 0xf;

    // Count is number of pixels, i.e., dy.
    line_dma_command[LINE_DMA_COMMAND_COUNT_OFFSET] = (char)(dy & 0xff);
    line_dma_command[LINE_DMA_COMMAND_COUNT_OFFSET + 1] = (char)(dy >> 8);

    // Command is FILL
    line_dma_command[LINE_DMA_COMMAND_COMMAND_OFFSET] = 0x03;

    // Line mode active, major axis is Y
    line_dma_command[LINE_DMA_COMMAND_MODE_OFFSET] = 0x80 + 0x40 + (((x2 - x1) < 0) ? 0x20 : 0x00);

    //    snprintf(msg,41,"Y: (%d,%d) - (%d,%d) m=%04x",x1,y1,x2,y2,slope);
    //    print_text(0,2,1,msg);

    POKE(0xD020, 1);

    POKE(0xD701, (char)(((unsigned int)(line_dma_command)) >> 8));
    POKE(0xD705, (char)(((unsigned int)(line_dma_command)) >> 0));

    POKE(0xD020, 0);
  }
  else {
    // X is major axis

    if (x2 < x1) {
      temp = x1;
      x1 = x2;
      x2 = temp;
      temp = y1;
      y1 = y2;
      y2 = temp;
    }

    // Use hardware divider to get the slope
    POKE(0xD770, (char)(dy & 0xff));
    POKE(0xD771, (char)(dy >> 8));
    POKE(0xD772, 0);
    POKE(0xD773, 0);
    POKE(0xD774, (char)(dx & 0xff));
    POKE(0xD775, (char)(dx >> 8));
    POKE(0xD776, 0);
    POKE(0xD777, 0);

    // Wait 16 cycles
    POKE(0xD020, 0);
    POKE(0xD020, 0);
    POKE(0xD020, 0);
    POKE(0xD020, 0);

    // Slope is the most significant bytes of the fractional part
    // of the division result
    slope = (int)PEEK(0xD76A) + ((int)PEEK(0xD76B) << 8);

    // Put slope into DMA options
    line_dma_command[LINE_DMA_COMMAND_SLOPE_OFFSET] = (char)(slope & 0xff);
    line_dma_command[LINE_DMA_COMMAND_SLOPE_OFFSET + 2] = (char)(slope >> 8);

    // Load DMA dest address with the address of the first pixel
    addr = 0x40000 + (y1 << 3) + (x1 & 7) + (x1 >> 3) * 64 * 25;
    line_dma_command[LINE_DMA_COMMAND_DEST_OFFSET + 0] = <(<(addr));
    line_dma_command[LINE_DMA_COMMAND_DEST_OFFSET + 1] = >(<(addr));
    line_dma_command[LINE_DMA_COMMAND_DEST_OFFSET + 2] = <(>(addr));

    // Source is the colour
    line_dma_command[LINE_DMA_COMMAND_SRC_OFFSET] = colour & 0xf;

    // Count is number of pixels, i.e., dy.
    line_dma_command[LINE_DMA_COMMAND_COUNT_OFFSET] = (char)(dx & 0xff);
    line_dma_command[LINE_DMA_COMMAND_COUNT_OFFSET + 1] = (char)(dx >> 8);

    // Command is FILL
    line_dma_command[LINE_DMA_COMMAND_COMMAND_OFFSET] = 0x03;

    // Line mode active, major axis is X
    char line_mode = (((y2 - y1) < 0) ? 0x20 : 0x00);
    line_dma_command[LINE_DMA_COMMAND_MODE_OFFSET] = 0x80 + 0x00 + line_mode;

    //    snprintf(msg,41,"X: (%d,%d) - (%d,%d) m=%04x",x1,y1,x2,y2,slope);
    //    print_text(0,2,1,msg);

    POKE(0xD020, 1);

    POKE(0xD701, (char)(((unsigned int)(line_dma_command)) >> 8));
    POKE(0xD705, (char)(((unsigned int)(line_dma_command)) >> 0));

    POKE(0xD020, 0);
  }
}
