// A pretty simple sine plotter

#pragma target(mega65_remote)
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

void main() {
  // Avoid interrupts
  SEI();
  // Map memory to BANK 0 : 0x00XXXX - giving access to I/O
  memoryRemap(0x00,0,0);
  // Fast CPU, M65 IO
  POKE(0,65);
  // Enable MEGA65 features
  VICIV->KEY = VICIV_KEY_M65_A;
  VICIV->KEY = VICIV_KEY_M65_B;
  // No C65 ROMs are mapped
  VICIV->CONTROLA = 0;
  // Enable 48MHz fast mode
  VICIV->CONTROLB |= VICIV_FAST;
  VICIV->CONTROLC |= VICIV_VFAST;
  graphics_mode();

  // initialize sine index
  char idx = 0;
  for(unsigned int i=0;i<320;i++) {
    sin_idx[i] = idx;
    idx += 11;
  }
  // Initialize plotter
  init_plot();

  for(;;) {
    // Wait for the raster
    while(VICIV->RASTER!=0xe3) ;
    // White border and background
    VICIV->BORDER_COLOR = RED;
    // Clear the graphics
    memset_dma256(0x0, 0x0, 0x6000, 0x00, 40*25*8);
    VICIV->BORDER_COLOR = WHITE;
    // Render some dots
    render_dots();
    // Black  border and background
    VICIV->BORDER_COLOR = BLACK;
  }
}

// Sine idx for each plot
char sin_idx[320];

// Graphics bit
char GFX_BIT[8] = { 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01 };

// Pointer to graphics for (x, 0)
char * GFX_PTR[320];

void init_plot() {
  char * gfx = GRAPHICS;
  for(unsigned int i=0; i<320;i++) {    
    GFX_PTR[i] = gfx;
    if((i&7)==7)
      gfx +=200;
  }
}

// Do a single plot on the canvas
void plot(unsigned int x, char y) {
  char * gfx = GFX_PTR[x] + y;
  *gfx |= GFX_BIT[x&7];
}

void render_dots() {
    // Plot some dots
    for(unsigned int i=0;i<320;i++) {
      char idx = sin_idx[i]++;
      plot(i, SINE[idx]);
    }
}

// Sine table
char SINE[0x200] = kickasm {{
    .fill $200, round(99.5+99.5*sin(toRadians(360*i/256)))
}};

// Address of the screen
char * const SCREEN = 0xc000;
// // Absolute address of the graphics
char * const GRAPHICS = 0x6000;

void graphics_mode(void) {
  // 16-bit text mode
  VICIV->CONTROLC = VICIV_CHR16;
  // H320, fast CPU
  VICIV->CONTROLB = VICIV_FAST;
  // 320x200 per char, 16 pixels wide per char
  // = 320/8 x 16 bits = 80 bytes per row
  VICIV->CHARSTEP_LO = 80;
  VICIV->CHARSTEP_HI = 0;
  // Draw 40 chars per row
  VICIV->CHRCOUNT = 40;
  // Put 2KB screen
  VICIV->SCRNPTR_LOLO = LOBYTE(SCREEN);
  VICIV->SCRNPTR_LOHI = HIBYTE(SCREEN);
  VICIV->SCRNPTR_HILO = 0x00;
  // Put charset 
  VICIV->CHARPTR_LOLO = LOBYTE(GRAPHICS);
  VICIV->CHARPTR_LOHI = HIBYTE(GRAPHICS);
  VICIV->CHARPTR_HILO = 0;
 
  // Layout screen so that graphics data comes from $40000 -- $4FFFF
  // Each column is consequtive values
  unsigned int * screen = (unsigned int *)SCREEN;
  unsigned int ch = 0;
  for(char y=0;y<25;y++) {
    unsigned int ch_x = ch;
    for(char x=0;x<40;x++) {
      screen[x] = ch_x;
      ch_x += 25;      
    }
    screen += 40;
    ch++;
  }  

  // Set color ram to white
  unsigned long cols = 0xff80000;
  for( unsigned int i=0; i<1000;i++) {
    lpoke(cols++, 0); // No extended attributes
    lpoke(cols++, WHITE);
  }

  // Black border and background
  VICIV->BORDER_COLOR = 0;
  VICIV->BG_COLOR = 0;

  // Clear the graphics
  memset_dma256(0x0, 0x0, 0x6000, 0x00, 40*25*8);
  //memset_dma256(0x0, 0x0, 0x6000, 0xff, 25*8);
  //memset_dma256(0x0, 0x0, 0x6000+25*39*8, 0xff, 25*8);

}