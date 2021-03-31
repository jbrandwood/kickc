// Test hardware line drawing
// Based on https://github.com/MEGA65/mega65-tools/blob/master/src/tests/test_290.c

#pragma target(mega65_remote)
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

char line_dmalist[256];
char slope_ofs, line_mode_ofs, cmd_ofs, count_ofs;
char src_ofs, dst_ofs;

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



   // Set up common structure of the DMA list
   char ofs = 0;
  // Screen layout is in vertical stripes, so we need only to setup the
  // X offset step.  64x25 =
  line_dmalist[ofs++] = 0x87;
  line_dmalist[ofs++] = (1600 - 8) & 0xff;
  line_dmalist[ofs++] = 0x88;
  line_dmalist[ofs++] = (1600 - 8) >> 8;
  line_dmalist[ofs++] = 0x8b;
  slope_ofs = ofs++; // remember where we have to put the slope in
  line_dmalist[ofs++] = 0x8c;
  ofs++;
  line_dmalist[ofs++] = 0x8f;
  line_mode_ofs = ofs++;
  line_dmalist[ofs++] = 0x0a; // F018A list format
  line_dmalist[ofs++] = 0x00; // end of options
  cmd_ofs = ofs++;            // command byte
  count_ofs = ofs;
  ofs += 2;
  src_ofs = ofs;
  ofs += 3;
  dst_ofs = ofs;
  ofs += 3;
  line_dmalist[ofs++] = 0x00; // modulo
  line_dmalist[ofs++] = 0x00;


  int x1 = 160;
  for(int x2=0;x2<320;x2+=11) {
    draw_line(x1, 100, x2, 198, 1);  
  }

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
  memset_dma256(0x0, 0x4, 0x0000, 0x00, 320*200);
  memset_dma256(0x0, 0x4, 0x0000, 0x055, 8*200);
  memset_dma256(0x0, 0x4, 0x0000+200*39*8, 0x055, 8*200);


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
    line_dmalist[slope_ofs] = (char)(slope & 0xff);
    line_dmalist[slope_ofs + 2] = (char)(slope >> 8);

    // Load DMA dest address with the address of the first pixel
    addr = 0x40000 + (y1 << 3) + (x1 & 7) + (x1 >> 3) * 64 * 25l;
    line_dmalist[dst_ofs + 0] = <(<(addr));
    line_dmalist[dst_ofs + 1] = >(<(addr));
    line_dmalist[dst_ofs + 2] = <(>(addr));

    // Source is the colour
    line_dmalist[src_ofs] = colour & 0xf;

    // Count is number of pixels, i.e., dy.
    line_dmalist[count_ofs] = (char)(dy & 0xff);
    line_dmalist[count_ofs + 1] = (char)(dy >> 8);

    // Command is FILL
    line_dmalist[cmd_ofs] = 0x03;

    // Line mode active, major axis is Y
    line_dmalist[line_mode_ofs] = 0x80 + 0x40 + (((x2 - x1) < 0) ? 0x20 : 0x00);

    //    snprintf(msg,41,"Y: (%d,%d) - (%d,%d) m=%04x",x1,y1,x2,y2,slope);
    //    print_text(0,2,1,msg);

    POKE(0xD020, 1);

    POKE(0xD701, (char)(((unsigned int)(line_dmalist)) >> 8));
    POKE(0xD705, (char)(((unsigned int)(line_dmalist)) >> 0));

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
    line_dmalist[slope_ofs] = (char)(slope & 0xff);
    line_dmalist[slope_ofs + 2] = (char)(slope >> 8);

    // Load DMA dest address with the address of the first pixel
    addr = 0x40000 + (y1 << 3) + (x1 & 7) + (x1 >> 3) * 64 * 25;
    line_dmalist[dst_ofs + 0] = <(<(addr));
    line_dmalist[dst_ofs + 1] = >(<(addr));
    line_dmalist[dst_ofs + 2] = <(>(addr));

    // Source is the colour
    line_dmalist[src_ofs] = colour & 0xf;

    // Count is number of pixels, i.e., dy.
    line_dmalist[count_ofs] = (char)(dx & 0xff);
    line_dmalist[count_ofs + 1] = (char)(dx >> 8);

    // Command is FILL
    line_dmalist[cmd_ofs] = 0x03;

    // Line mode active, major axis is X
    char line_mode = (((y2 - y1) < 0) ? 0x20 : 0x00);
    line_dmalist[line_mode_ofs] = 0x80 + 0x00 + line_mode;

    //    snprintf(msg,41,"X: (%d,%d) - (%d,%d) m=%04x",x1,y1,x2,y2,slope);
    //    print_text(0,2,1,msg);

    POKE(0xD020, 1);

    POKE(0xD701, (char)(((unsigned int)(line_dmalist)) >> 8));
    POKE(0xD705, (char)(((unsigned int)(line_dmalist)) >> 0));

    POKE(0xD020, 0);
  }
}
