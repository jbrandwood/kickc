// Test hardware line drawing
// Based on https://github.com/MEGA65/mega65-tools/blob/master/src/tests/test_290.c

#pragma target(mega65)
#include <mega65.h>
#include <6502.h>

#define POKE(addr,val) *((char*)(addr)) = val

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

void main() {

    // Avoid interrupts
    SEI();
    // Map memory to BANK 0 : 0x00XXXX - giving access to I/O
    memoryRemap(0,0,0);

    // Fast CPU, M65 IO
    POKE(0, 65);
    POKE(0xD02F, 0x47);
    POKE(0xD02F, 0x53);    
  
    graphics_mode();

    for(;;) ;


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

}

