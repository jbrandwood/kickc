#include <c64.h>
#include <basic-floats.h>
#include <print.h>

const char sinlen_x = 221;
const char sintab_x[221];
const char sinlen_y = 197;
const char sintab_y[197];
char* const sprites = $2000;
char* const SCREEN = $400;

void main() {
    init();
    do {
        do { } while (*RASTER!=$ff);
        anim();
    } while(true);
}

void init() {
    clear_screen();
    for( char i : 0..39) {
        COLS[i] = $0;
        COLS[40+i] = $b;
    }
    place_sprites();
    gen_sprites();
    progress_init(SCREEN);
    gen_sintab(sintab_x, sinlen_x, $00, $ff);
    progress_init(SCREEN+40);
    gen_sintab(sintab_y, sinlen_y, $32, $d0);
    clear_screen();
}

void clear_screen() {
    for(char* sc = SCREEN; sc<SCREEN+1000; sc++) {
        *sc = ' ';
    }
}

// Current position of the progress cursor
char* progress_cursor = SCREEN;
// Current index within the progress cursor (0-7)
char progress_idx = 0;

// Initialize the PETSCII progress bar
void progress_init(char* line) {
    progress_cursor = line;
    progress_idx = 0;
}

// Increase PETSCII progress one bit
// Done by increasing the character until the idx is 8 and then moving to the next char
void progress_inc() {
    // Progress characters
    const char progress_chars[] = { $20, $65, $74, $75, $61, $f6, $e7, $ea, $e0};
    if(++progress_idx==8) {
        *progress_cursor = progress_chars[8];
        progress_cursor++;
        progress_idx = 0;
    }
    *progress_cursor = progress_chars[progress_idx];
}


char sin_idx_x = 0;
char sin_idx_y = 0;

void anim() {
    (*BORDERCOL)++;
    char xidx = sin_idx_x;
    char yidx = sin_idx_y;
    char j2 = 12;
    char x_msb = 0;
    for( char j : 0..6) {
        unsigned int x = (unsigned int)$1e + sintab_x[xidx];
        x_msb = x_msb*2 | >x;
        SPRITES_XPOS[j2] = <x;
        SPRITES_YPOS[j2] = sintab_y[yidx];
        xidx = xidx+10;
        if(xidx>=sinlen_x) {
            xidx = xidx-sinlen_x;
        }
        yidx = yidx+8;
        if(yidx>=sinlen_y) {
            yidx = yidx-sinlen_y;
        }
        j2 = j2-2;
    }
    *SPRITES_XMSB = x_msb;

    // Increment sin indices
    if(++sin_idx_x>=sinlen_x) {
        sin_idx_x = 0;
    }
    if(++sin_idx_y>=sinlen_y) {
        sin_idx_y = 0;
    }
    (*BORDERCOL)--;
}

void place_sprites() {
    *SPRITES_ENABLE = %01111111;
    *SPRITES_EXPAND_X = %01111111;
    *SPRITES_EXPAND_Y = %01111111;
    char* sprites_ptr = SCREEN+$3f8;
    char spr_id = (char)((unsigned int)sprites/$40);
    char spr_x = 60;
    char j2 = 0;
    char col = $5;
    for( char j : 0..6) {
        sprites_ptr[j] = spr_id++;
        SPRITES_XPOS[j2] = spr_x;
        SPRITES_YPOS[j2] = 80;
        SPRITES_COLS[j] = col;
        spr_x = spr_x + 32;
        col = col^($7^$5);
        j2++;
        j2++;
    }
}

void gen_sprites() {
    char cml[] = "camelot"z;
    char* spr = sprites;
    for( char i : 0..6 ) {
        gen_chargen_sprite(cml[i], spr);
        spr = spr + $40;
    }
}

// Generate a sprite from a C64 CHARGEN character (by making each pixel 3x3 pixels large)
// - c is the character to generate
// - sprite is a pointer to the position of the sprite to generate
void gen_chargen_sprite(char ch, char* sprite) {
    char* chargen = CHARGEN+((unsigned int)ch)*8;
    asm { sei }
    *PROCPORT = $32;
    for(char y:0..7) {
      // current chargen line
      char bits = chargen[y];
      // current sprite char
      char s_gen = 0;
      // #bits filled into current sprite char
      char s_gen_cnt = 0;
      for(char x:0..7) {
        // Find the current chargen pixel (c)
        char c = 0;
        if((bits & $80) != 0) {
           c = 1;
        }
        // generate 3 pixels in the sprite char (s_gen)
        for(char b : 0..2){
            s_gen = s_gen*2 | c;
            if(++s_gen_cnt==8) {
                // sprite char filled - store and move to next char
                sprite[0] = s_gen;
                sprite[3] = s_gen;
                sprite[6] = s_gen;
                sprite++;
                s_gen = 0;
                s_gen_cnt = 0;
            }
        }
        // move to next char pixel
        bits = bits*2;
      }
      // move 3 lines down in the sprite (already moved 1 through ++)
      sprite = sprite + 6;
    }
    *PROCPORT = $37;
    asm { cli }
}

// Reserve zeropage addresses used by the BASIC FP operations
#pragma reserve(0x07, 0x0d, 0x0e, 0x12)

// Generate a sinus table using BASIC floats
// - sintab is a pointer to the table to fill
// - length is the length of the sine table
// - min is the minimum value of the generated sinus
// - max is the maximum value of the generated sinus
void gen_sintab(char* sintab, char length, char min, char max) {
    char f_i[] = {0, 0, 0, 0, 0};   // i * 2 * PI
    char f_min[] = {0, 0, 0, 0, 0}; // amplitude/2 + min
    char f_amp[] = {0, 0, 0, 0, 0}; // amplitude/2
    char* f_2pi = $e2e5;            // 2 * PI
    setFAC((unsigned int)max);       // fac = max
    setARGtoFAC();           // arg = max
    setFAC((unsigned int)min);       // fac = min
    setMEMtoFAC(f_min);      // f_min = min
    subFACfromARG();         // fac = max - min
    setMEMtoFAC(f_amp);      // f_amp = max - min
    setFAC(2);               // fac = 2
    divMEMbyFAC(f_amp);      // fac = (max - min) / 2
    setMEMtoFAC(f_amp);      // f_amp = (max - min) / 2
    addMEMtoFAC(f_min);      // fac = min + (max - min) / 2
    setMEMtoFAC(f_min);      // f_min = min + (max - min) / 2
    for(char i =0; i<length; i++) {
        setFAC((unsigned int)i);       // fac = i
        mulFACbyMEM(f_2pi);    // fac = i * 2 * PI
        setMEMtoFAC(f_i);      // f_i = i * 2 * PI
        setFAC((unsigned int)length);  // fac = length
        divMEMbyFAC(f_i);      // fac = i * 2 * PI / length
        sinFAC();              // fac = sin( i * 2 * PI / length )
        mulFACbyMEM(f_amp);    // fac =  sin( i * 2 * PI / length ) * (max - min) / 2
        addMEMtoFAC(f_min);    // fac =  sin( i * 2 * PI / length ) * (max - min) / 2 + min + (max - min) / 2
        sintab[i] = (char)getFAC();
        progress_inc();
    }
}
