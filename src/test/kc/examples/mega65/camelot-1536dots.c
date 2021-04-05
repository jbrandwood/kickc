// A pretty simple double sine plotter

#pragma target(mega65)
#include <mega65.h>
#include <mega65-dma.h>
#include <6502.h>

// Get the low byte from a word/int
#define LOBYTE(w) BYTE0(w)
// Get the high byte from a word/int
#define HIBYTE(w) BYTE1(w)

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

// Address of the screen
char * const SCREEN = 0xc800;
// // Absolute address of graphics buffer 1
char * const GRAPHICS1 = 0xa000;
// // Absolute address of graphics buffer 2
char * const GRAPHICS2 = 0x7000;

// SID tune at an absolute address
__address(0x5000) char MUSIC[] = kickasm(resource "Thaw_5000.sid") {{
    .const music = LoadSid("Thaw_5000.sid")
    .fill music.size, music.getData(i)
}};
// Pointer to the music init routine
void()* musicInit = (void()*) MUSIC;
// Pointer to the music play routine
void()* musicPlay = (void()*) MUSIC+3;


__align(0x40) char SPRITES[0xc0] = kickasm(resource "camelot-sprites.png") {{
    .var pic = LoadPicture("camelot-sprites.png", List().add($000000, $ffffff))
    .for (var s=0; s<3; s++) {
      .for (var y=0; y<21; y++) {
          .for (var x=0;x<3; x++) {
              .byte pic.getSinglecolorByte(s*3+x,y)
          }
      }
      .byte 0
    }       
}};

// The sprite pointers
unsigned int SPRITE_PTRS[8];

void main() {
  // Avoid interrupts
  SEI();
  // Map memory to BANK 0 : 0x00XXXX - giving access to I/O
  memoryRemap(0x00,0,0);
  // Fast CPU, M65 IO
  POKE(0,65);
  // Disable Kernal & Basic
  *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
  *PROCPORT = PROCPORT_RAM_IO;
  // Enable MEGA65 features
  VICIV->KEY = VICIV_KEY_M65_A;
  VICIV->KEY = VICIV_KEY_M65_B;
  // No C65 ROMs are mapped
  VICIV->CONTROLA = 0;
  // Enable 48MHz fast mode
  VICIV->CONTROLB |= VICIV_FAST;
  VICIV->CONTROLC |= VICIV_VFAST;
  // Initialize graphics
  graphics_mode();
  // Show sprites
  VICIV->SPRPTRADR_LOLO = LOBYTE(SPRITE_PTRS);
  VICIV->SPRPTRADR_LOHI = HIBYTE(SPRITE_PTRS);
  VICIV->SPRPTRADR_HILO = VICIV_SPRPTR16;
  SPRITE_PTRS[0] = toSpritePtr(SPRITES+0x40);
  SPRITE_PTRS[1] = toSpritePtr(SPRITES+0x80);
  SPRITE_PTRS[2] = toSpritePtr(SPRITES+0x00);
  VICIV->SPRITES_ENABLE = 7;
  VICIV->SPRITES_PRIORITY = 0xff;
  SPRITES_COLOR[0] = DARK_GREY;
  SPRITES_COLOR[1] = DARK_GREY;
  SPRITES_COLOR[2] = DARK_GREY;
  SPRITES_YPOS[0] = 0xe3;
  SPRITES_YPOS[2] = 0xe3;
  SPRITES_YPOS[4] = 0xe3;
  SPRITES_XPOS[0] = 46;
  SPRITES_XPOS[2] = 46+24;
  SPRITES_XPOS[4] = 25;
  *SPRITES_XMSB = 3;

  // Initialize plotter
  init_plot();
  // Initialize SID 
  asm { lda #0 }
  (*musicInit)();

  // Main loop
  for(;;) {
    // Wait for the raster
    while(VICIV->RASTER!=0xe3) ;
    // Switch buffer
    buffer ^=1;
    // Select charset 
    if(buffer==0) {
      VICIV->CHARPTR_LOLO = LOBYTE(GRAPHICS1);
      VICIV->CHARPTR_LOHI = HIBYTE(GRAPHICS1);
      VICIV->CHARPTR_HILO = 0;
      graphics_render = GRAPHICS2;
    } else {
      VICIV->CHARPTR_LOLO = LOBYTE(GRAPHICS2);
      VICIV->CHARPTR_LOHI = HIBYTE(GRAPHICS2);
      VICIV->CHARPTR_HILO = 0;
      graphics_render = GRAPHICS1;
    }
    // Clear the graphics
    memset_dma(graphics_render, 0x00, 40*25*8);
    // Render some dots
    render_dots();
    //Play  SID
    (*musicPlay)();

  }
}

// 0: show GRAPHICS1, render to GRAPHICS2
// 1: show GRAPHICS2, render to GRAPHICS1
volatile char buffer = 0;

// The graphics being rendered to
char * volatile graphics_render = GRAPHICS1;

// Sine idx for each plot
volatile unsigned int sin_x1_idx;
volatile unsigned int sin_x2_idx;

volatile unsigned int sin_y1_idx;
volatile unsigned int sin_y2_idx;

// Graphics bit
char GFX_BIT[8] = { 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01 };

// Offset to graphics for (x, 0)
unsigned int GFX_OFFSET[320];

void init_plot() {
  unsigned int gfx = 0;
  for(unsigned int i=0; i<320;i++) {    
    GFX_OFFSET[i] = gfx;
    if((i&7)==7)
      gfx +=200;
  }
}

// Do a single plot on the canvas
void plot(unsigned int x, char y) {
  char * gfx = graphics_render + GFX_OFFSET[x] + y;
  *gfx |= GFX_BIT[x&7];
}

void render_dots() {
    // Plot some dots
    unsigned int idx_x1 = sin_x1_idx;
    sin_x1_idx += 1; if(sin_x1_idx>SINX1_SIZE) sin_x1_idx -=SINX1_SIZE;
    unsigned int idx_x2 = sin_x2_idx;
    sin_x2_idx -= 1; if(sin_x2_idx>SINX2_SIZE) sin_x2_idx +=SINX2_SIZE;
    unsigned int idx_y1 = sin_y1_idx;
    sin_y1_idx -= 1; if(sin_y1_idx>SINY1_SIZE) sin_y1_idx +=SINY1_SIZE;
    unsigned int idx_y2 = sin_y2_idx;
    sin_y2_idx += 1; if(sin_y2_idx>SINY2_SIZE) sin_y2_idx -=SINY2_SIZE;

    for(unsigned int i=0;i<1536;i++) {
      plot(SINX1[idx_x1]+SINX2[idx_x2], SINY1[idx_y1]+SINY2[idx_y2]);
      idx_x1 -= 11; if(idx_x1>SINX1_SIZE) idx_x1 += SINX1_SIZE;
      idx_x2 += 3; if(idx_x2>SINX2_SIZE) idx_x2 -= SINX2_SIZE;
      idx_y1 += 9; if(idx_y1>SINY1_SIZE) idx_y1 -= SINY1_SIZE;
      idx_y2 -= 5; if(idx_y2>SINY2_SIZE) idx_y2 += SINY2_SIZE;
    }
}

// Sine table
const unsigned int SINY1_SIZE = 733;
char SINY1[SINY1_SIZE+256] = kickasm {{
    .fill 733+256, round(66.5+66.5*sin(toRadians(360*i/733)))
}};

const unsigned int SINY2_SIZE = 317;
char SINY2[SINY2_SIZE+256] = kickasm {{
    .fill 317+256, round(33+33*sin(toRadians(360*i/317)))
}};

const unsigned int SINX1_SIZE = 1613;
unsigned int SINX1[SINX1_SIZE+256] = kickasm {{
    .fillword 1613+256, round(98+98*sin(toRadians(360*i/1613)))
}};

const unsigned int SINX2_SIZE = 547;
unsigned int SINX2[SINX2_SIZE+256] = kickasm {{
    .fillword 547+256, round(60+60*sin(toRadians(360*i/547)))
}};

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
  // Select 2KB screen
  VICIV->SCRNPTR_LOLO = LOBYTE(SCREEN);
  VICIV->SCRNPTR_LOHI = HIBYTE(SCREEN);
  VICIV->SCRNPTR_HILO = 0x00;
  // Select charset 
  VICIV->CHARPTR_LOLO = LOBYTE(GRAPHICS1);
  VICIV->CHARPTR_LOHI = HIBYTE(GRAPHICS1);
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
  memset_dma(GRAPHICS1, 0x00, 40*25*8);
  memset_dma(GRAPHICS2, 0x00, 40*25*8);

}

