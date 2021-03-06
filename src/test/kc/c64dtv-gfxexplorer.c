// Interactive Explorer for C64DTV Screen Modes
#include <c64dtv.h>
#include <c64-print.h>
#include <c64-keyboard.h>
#include <c64-bitmap.h>

void main() {
    asm { sei }  // Disable normal interrupt (prevent keyboard reading glitches and allows to hide basic/kernal)
    // Disable kernal & basic
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;
    // Enable DTV extended modes
    *DTV_FEATURE = DTV_FEATURE_ENABLE;
    keyboard_init();
    gfx_init();
    while(true) {
        // Let the user change the GFX configuration
        form_mode();
        // Show the GFX configuration
        gfx_mode();
    }
}

// VIC Screens
byte* const VICII_SCREEN0 = (byte*)$4000;
byte* const VICII_SCREEN1 = (byte*)$4400;
byte* const VICII_SCREEN2 = (byte*)$4800;
byte* const VICII_SCREEN3 = (byte*)$4c00;
byte* const VICII_SCREEN4 = (byte*)$5000;
// VIC Charset from ROM
byte* const VICII_CHARSET_ROM = (byte*)$5800;
// VIC Bitmap
byte* const VICII_BITMAP = (byte*)$6000;

// 8BPP Chunky Bitmap (contains 8bpp pixels)
const dword PLANE_8BPP_CHUNKY = $20000;
// Plane with horisontal stripes
const dword PLANE_HORISONTAL = $30000;
// Plane with vertical stripes
const dword PLANE_VERTICAL = $32000;
// Plane with horisontal stripes every 2 pixels
const dword PLANE_HORISONTAL2 = $34000;
// Plane with vertical stripes every 2 pixels
const dword PLANE_VERTICAL2 = $36000;
// Plane with blank pixels
const dword PLANE_BLANK = $38000;
// Plane with all pixels
const dword PLANE_FULL = $3a000;
// Plane with all pixels
const dword PLANE_CHARSET8 = $3c000;

// Get plane address from a plane index (from the form)
dword get_plane(byte idx) {
    if(idx==0) {
        return (dword)VICII_SCREEN0;
    } else if(idx==1) {
        return (dword)VICII_SCREEN1;
    } else if(idx==2) {
        return (dword)VICII_SCREEN2;
    } else if(idx==3) {
        return (dword)VICII_SCREEN3;
    } else if(idx==4) {
        return (dword)VICII_BITMAP;
    } else if(idx==5) {
        return (dword)VICII_CHARSET_ROM;
    } else if(idx==6) {
        return (dword)PLANE_8BPP_CHUNKY;
    } else if(idx==7) {
        return (dword)PLANE_HORISONTAL;
    } else if(idx==8) {
        return (dword)PLANE_VERTICAL;
    } else if(idx==9) {
        return (dword)PLANE_HORISONTAL2;
    } else if(idx==10) {
        return (dword)PLANE_VERTICAL2;
    } else if(idx==11) {
        return (dword)PLANE_CHARSET8;
    } else if(idx==12) {
        return (dword)PLANE_BLANK;
    } else if(idx==13) {
        return (dword)PLANE_FULL;
    }
    return (dword)VICII_SCREEN0;
}

// Get the VIC screen address from the screen index
byte* get_VICII_screen(byte idx) {
    if(idx==0) {
        return VICII_SCREEN0;
    } else if(idx==1) {
        return VICII_SCREEN1;
    } else if(idx==2) {
        return VICII_SCREEN2;
    } else if(idx==3) {
        return VICII_SCREEN3;
    } else if(idx==4) {
        return VICII_SCREEN4;
    }
    return VICII_SCREEN0;
}

// Get the VIC charset/bitmap address from the index
byte* get_VICII_charset(byte idx) {
    if(idx==0) {
        return VICII_CHARSET_ROM;
    } else if(idx==1) {
        return VICII_BITMAP;
    }
    return VICII_CHARSET_ROM;
}

// Screen containing the FORM
byte* const FORM_SCREEN = (byte*)$0400;
// Charset used for the FORM
byte* const FORM_CHARSET = (byte*)$1800; // Charset ROM

byte FORM_TEXT[] =
     " C64 DTV Graphics Mode Explorer         @"
     "                                        @"
     " PRESET 0 Standard Charset              @"
     "                                        @"
     " CONTROL        PLANE  A     VIC II     @"
     " bmm        0   pattern p0   screen s0  @"
     " mcm        0   start   00   gfx    g0  @"
     " ecm        0   step    00   colors c0  @"
     " hicolor    0   modulo  00              @"
     " linear     0                COLORS     @"
     " color off  0   PLANE  B     palet   0  @"
     " chunky     0   pattern p0   bgcol0 00  @"
     " border off 0   start   00   bgcol1 00  @"
     " overscan   0   step    00   bgcol2 00  @"
     "                modulo  00   bgcol3 00  @"
     ;
byte FORM_COLS[] =
     "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa@"
     "                                        @"
     "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa@"
     "                                        @"
     " nnnnnnnnnnnn   mmmmmmmmmm   ooooooooo  @"
     " nnnnnnnnnnnn   mmmmmmmmmm   ooooooooo  @"
     " nnnnnnnnnnnn   mmmmmmmmmm   ooooooooo  @"
     " nnnnnnnnnnnn   mmmmmmmmmm   ooooooooo  @"
     " nnnnnnnnnnnn   mmmmmmmmmm              @"
     " nnnnnnnnnnnn                jjjjjjjjj  @"
     " nnnnnnnnnnnn   mmmmmmmmmm   jjjjjjjjj  @"
     " nnnnnnnnnnnn   mmmmmmmmmm   jjjjjjjjj  @"
     " nnnnnnnnnnnn   mmmmmmmmmm   jjjjjjjjj  @"
     " nnnnnnnnnnnn   mmmmmmmmmm   jjjjjjjjj  @"
     " nnnnnnnnnnnn   mmmmmmmmmm   jjjjjjjjj  @"
     " nnnnnnnnnnnn   mmmmmmmmmm   jjjjjjjjj  @"
     ;

// Number of form fields
byte form_fields_cnt = 36;
// Form fields x/y-positions
byte form_fields_x[]        = {  8, 12, 12, 12, 12, 12, 12, 12, 12, 12, 25, 24, 25, 24, 25, 24, 25, 25, 24, 25, 24, 25, 24, 25, 37, 37, 37, 37, 36, 37, 36, 37, 36, 37, 36, 37 };
byte form_fields_y[]        = {  2,  5,  6,  7,  8,  9, 10, 11, 12, 13,  5,  6,  6,  7,  7,  8,  8, 11, 12, 12, 13, 13, 14, 14,  5,  6,  7, 10, 11, 11, 12, 12, 13, 13, 14, 14 };
// Form field max values (all values are in the interval 0..max)
byte form_fields_max[]      = { 10,  1,  1,  1,  1,  1,  1,  1,  1,  1, $d, $f, $f, $f, $f, $f, $f, $d, $f, $f, $f, $f, $f, $f, $3, $1, $4, $1, $f, $f, $f, $f, $f, $f, $f, $f };
// Form fields values
byte form_fields_val[]      = {  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 };

// Preset: Standard Char Mode
byte preset_stdchar[]       = {  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0 };
// Preset: Extended Color Char Mode
byte preset_ecmchar[]       = {  1,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0,  2,  0,  5,  0,  6 };
// Preset: Standard Bitmap
byte preset_stdbm[]         = {  2,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  2,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 };
// Preset: MC Bitmap
byte preset_mcbm[]          = {  3,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  2,  1,  0,  0,  0,  9,  0,  0,  0,  0,  0,  0 };
// Preset: Hicolor Standard Char Mode
byte preset_hi_stdchar[]    = {  4,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0 };
// Preset: Hicolor Extended Color Char Mode
byte preset_hi_ecmchar[]    = {  5,  0,  0,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  3,  4,  6,  8,  9, $c, $c };
// Preset: Two plane mode
byte preset_twoplane[]      = {  6,  1,  0,  1,  1,  1,  0,  0,  0,  0,  7,  0,  0,  0,  1,  0,  0,  8,  0,  0,  0,  1,  0,  0,  0,  0,  0,  1,  7,  0, $d,  4,  0,  0,  0,  0 };
// Preset: Chunky 8bpp
byte preset_chunky[]        = {  7,  0,  1,  1,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  6,  0,  0,  0,  8,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0 };
// Preset: Sixs FREDs mode
byte preset_sixsfred[]      = {  8,  1,  1,  1,  1,  1,  0,  0,  0,  0, $9,  0,  0,  0,  1,  0,  0, $a,  0,  0,  0,  1,  0,  0,  0,  0,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0 };
// Preset: Sixs FREDs 2 mode
byte preset_sixsfred2[]     = {  9,  1,  1,  1,  0,  1,  0,  0,  0,  0, $9,  0,  0,  0,  1,  0,  0, $a,  0,  0,  0,  1,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0 };
// Preset: 8bpp Pixel Cell
byte preset_8bpppixelcell[] = { 10,  0,  1,  1,  1,  1,  0,  1,  0,  0, $0,  0,  0,  0,  1,  0,  0, $b,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0 };

// Apply a form value preset to the form values
// idx is the ID of the preset
void apply_preset(byte idx) {
    byte* preset;
    if(idx==0) {
        preset = preset_stdchar;
    } else if(idx==1){
        preset = preset_ecmchar;
    } else if(idx==2){
        preset = preset_stdbm;
    } else if(idx==3){
        preset = preset_mcbm;
    } else if(idx==4){
        preset = preset_hi_stdchar;
    } else if(idx==5){
        preset = preset_hi_ecmchar;
    } else if(idx==6){
        preset = preset_twoplane;
    } else if(idx==7){
        preset = preset_chunky;
    } else if(idx==8){
        preset = preset_sixsfred;
    } else if(idx==9){
        preset = preset_sixsfred2;
    } else if(idx==10){
        preset = preset_8bpppixelcell;
    } else {
        preset = preset_stdchar;
    }
    // Copy preset values into the fields
    for( byte i=0; i != form_fields_cnt; i++) {
        form_fields_val[i] = preset[i];
    }

}

// Render form preset name in the form
// idx is the ID of the preset
void render_preset_name(byte idx) {
    byte* name;
    if(idx==0) {
        name = "Standard Charset              ";
    } else if(idx==1){
        name = "Extended Color Charset        ";
    } else if(idx==2){
        name = "Standard Bitmap               ";
    } else if(idx==3){
        name = "Multicolor Bitmap             ";
    } else if(idx==4){
        name = "Hicolor Charset               ";
    } else if(idx==5){
        name = "Hicolor Extended Color Charset";
    } else if(idx==6){
        name = "Twoplane Bitmap               ";
    } else if(idx==7){
        name = "Chunky 8bpp                   ";
    } else if(idx==8){
        name = "Sixs Fred                     ";
    } else if(idx==9){
        name = "Sixs Fred 2                   ";
    } else if(idx==10){
        name = "8bpp Pixel Cell               ";
    } else {
        name = "Standard Charset              ";
    }
    // Render it
    print_str_at(name, FORM_SCREEN+40*2+10);
}


// Form fields direct addressing
byte* const form_preset  = form_fields_val+0;
byte* const form_ctrl_bmm   = form_fields_val+1;
byte* const form_ctrl_mcm   = form_fields_val+2;
byte* const form_ctrl_ecm   = form_fields_val+3;
byte* const form_ctrl_hicol = form_fields_val+4;
byte* const form_ctrl_line  = form_fields_val+5;
byte* const form_ctrl_colof = form_fields_val+6;
byte* const form_ctrl_chunk = form_fields_val+7;
byte* const form_ctrl_borof = form_fields_val+8;
byte* const form_ctrl_overs = form_fields_val+9;
byte* const form_a_pattern  = form_fields_val+10;
byte* const form_a_start_hi = form_fields_val+11;
byte* const form_a_start_lo = form_fields_val+12;
byte* const form_a_step_hi  = form_fields_val+13;
byte* const form_a_step_lo  = form_fields_val+14;
byte* const form_a_mod_hi   = form_fields_val+15;
byte* const form_a_mod_lo   = form_fields_val+16;
byte* const form_b_pattern  = form_fields_val+17;
byte* const form_b_start_hi = form_fields_val+18;
byte* const form_b_start_lo = form_fields_val+19;
byte* const form_b_step_hi  = form_fields_val+20;
byte* const form_b_step_lo  = form_fields_val+21;
byte* const form_b_mod_hi   = form_fields_val+22;
byte* const form_b_mod_lo   = form_fields_val+23;
byte* const form_VICII_screen = form_fields_val+24;
byte* const form_VICII_gfx    = form_fields_val+25;
byte* const form_VICII_cols   = form_fields_val+26;
byte* const form_dtv_palet  = form_fields_val+27;
byte* const form_VICII_bg0_hi = form_fields_val+28;
byte* const form_VICII_bg0_lo = form_fields_val+29;
byte* const form_VICII_bg1_hi = form_fields_val+30;
byte* const form_VICII_bg1_lo = form_fields_val+31;
byte* const form_VICII_bg2_hi = form_fields_val+32;
byte* const form_VICII_bg2_lo = form_fields_val+33;
byte* const form_VICII_bg3_hi = form_fields_val+34;
byte* const form_VICII_bg3_lo = form_fields_val+35;

// Change graphics mode to show the selected graphics mode
void gfx_mode() {
    // Show the GFX configuration
    // DTV Graphics Mode
    byte dtv_control = 0;
    if(*form_ctrl_line!=0) {
        dtv_control = dtv_control | DTV_LINEAR;
    }
    if(*form_ctrl_borof!=0) {
        dtv_control = dtv_control | DTV_BORDER_OFF;
    }
    if(*form_ctrl_hicol!=0) {
        dtv_control = dtv_control | DTV_HIGHCOLOR;
    }
    if(*form_ctrl_overs!=0) {
        dtv_control = dtv_control | DTV_OVERSCAN;
    }
    if(*form_ctrl_colof!=0) {
        dtv_control = dtv_control | DTV_COLORRAM_OFF;
    }
    if(*form_ctrl_chunk!=0) {
        dtv_control = dtv_control | DTV_CHUNKY;
    }
    *DTV_CONTROL = dtv_control;

    // VIC Graphics Mode
    byte VICII_control = VICII_DEN | VICII_RSEL | 3;
    if(*form_ctrl_ecm!=0) {
        VICII_control = VICII_control | VICII_ECM;
    }
    if(*form_ctrl_bmm!=0) {
        VICII_control = VICII_control | VICII_BMM;
    }
    *VICII_CONTROL1 = VICII_control;
    byte VICII_control2 = VICII_CSEL;
    if(*form_ctrl_mcm!=0) {
        VICII_control2 = VICII_control2 | VICII_MCM;
    }
    *VICII_CONTROL2 = VICII_control2;

    // Linear Graphics Plane A Counter
    byte plane_a_offs = *form_a_start_hi*$10|*form_a_start_lo;
    dword plane_a = get_plane(*form_a_pattern) + plane_a_offs;
    *DTV_PLANEA_START_LO = BYTE0(plane_a);
    *DTV_PLANEA_START_MI = BYTE1(plane_a);
    *DTV_PLANEA_START_HI = BYTE2(plane_a);
    *DTV_PLANEA_STEP = *form_a_step_hi*$10|*form_a_step_lo;
    *DTV_PLANEA_MODULO_LO = *form_a_mod_hi*$10|*form_a_mod_lo;
    *DTV_PLANEA_MODULO_HI = 0;

    // Linear Graphics Plane B Counter
    byte plane_b_offs = *form_b_start_hi*$10|*form_b_start_lo;
    dword plane_b = get_plane(*form_b_pattern) + plane_b_offs;
    *DTV_PLANEB_START_LO = BYTE0(plane_b);
    *DTV_PLANEB_START_MI = BYTE1(plane_b);
    *DTV_PLANEB_START_HI = BYTE2(plane_b);
    *DTV_PLANEB_STEP = *form_b_step_hi*$10|*form_b_step_lo;
    *DTV_PLANEB_MODULO_LO = *form_b_mod_hi*$10|*form_b_mod_lo;
    *DTV_PLANEB_MODULO_HI = 0;

    // VIC Graphics Bank
    CIA2->PORT_A_DDR = %00000011; // Set VIC Bank bits to output - all others to input
    CIA2->PORT_A = %00000011 ^ (byte)((word)VICII_SCREEN0/$4000); // Set VIC Bank
    // VIC memory
    *VICII_MEMORY = (byte)(((word)get_VICII_screen(*form_VICII_screen)&$3fff)/$40)  |   ((BYTE1((word)get_VICII_charset(*form_VICII_gfx)&$3fff))/4);

    // VIC Colors
    byte* VICII_colors = get_VICII_screen(*form_VICII_cols);
    byte* col=COLS;
    for(byte cy: 0..24 ) {
        for(byte cx: 0..39) {
            *col++ = *VICII_colors++;
        }
    }

    // Background colors
    VICII->BORDER_COLOR = 0;
    VICII->BG_COLOR = *form_VICII_bg0_hi*$10|*form_VICII_bg0_lo;
    VICII->BG_COLOR1 = *form_VICII_bg1_hi*$10|*form_VICII_bg1_lo;
    VICII->BG_COLOR2 = *form_VICII_bg2_hi*$10|*form_VICII_bg2_lo;
    VICII->BG_COLOR3 = *form_VICII_bg3_hi*$10|*form_VICII_bg3_lo;

    // DTV Palette
    if(*form_dtv_palet==0) {
        // DTV Palette - default
        for(byte i : 0..$f) {
            DTV_PALETTE[i] = DTV_PALETTE_DEFAULT[i];
        }
    } else {
        // DTV Palette - Grey Tones
        for(byte j : 0..$f) {
            DTV_PALETTE[j] = j;
        }
    }

    // Wait for the user to press space
    while(true) {
        while(VICII->RASTER!=$ff) {}
        keyboard_event_scan();
        byte keyboard_event = keyboard_event_get();
        if(keyboard_event==KEY_SPACE) {
            // If space pressed - change to form mode         4
            return;
        }
    }

}

// Initialize the different graphics in the memory
void gfx_init() {
    gfx_init_screen0();
    gfx_init_screen1();
    gfx_init_screen2();
    gfx_init_screen3();
    gfx_init_screen4();
    gfx_init_charset();
    gfx_init_VICII_bitmap();
    gfx_init_plane_8bppchunky();
    gfx_init_plane_charset8();
    gfx_init_plane_horisontal();
    gfx_init_plane_vertical();
    gfx_init_plane_horisontal2();
    gfx_init_plane_vertical2();
    gfx_init_plane_blank();
    gfx_init_plane_full();
}

void gfx_init_charset() {
    *PROCPORT = $32;
    byte* chargen = CHARGEN;
    byte* charset = VICII_CHARSET_ROM;
    for(byte c: 0..$ff) {
        for( byte l: 0..7) {
            *charset++ = *chargen++;
        }
    }
    *PROCPORT = $37;
}

// Initialize VIC screen 0 ( value is %yyyyxxxx where yyyy is ypos and xxxx is xpos)
void gfx_init_screen0() {
    byte* ch=VICII_SCREEN0;
    for(byte cy: 0..24 ) {
        for(byte cx: 0..39) {
            *ch++ = (cy&$f)*$10|(cx&$f);
        }
    }
}

// Initialize VIC screen 1 ( value is %0000cccc where cccc is (x+y mod $f))
void gfx_init_screen1() {
    byte* ch=VICII_SCREEN1;
    for(byte cy: 0..24 ) {
        for(byte cx: 0..39) {
            *ch++ = (cx+cy)&$f;
        }
    }
}

// Initialize VIC screen 2 ( value is %ccccrrrr where cccc is (x+y mod $f) and rrrr is %1111-%cccc)
void gfx_init_screen2() {
    byte* ch=VICII_SCREEN2;
    for(byte cy: 0..24 ) {
        for(byte cx: 0..39) {
            byte col = (cx+cy)&$f;
            byte col2 = ($f-col);
            *ch++ = col*$10 | col2;
        }
    }
}

// Initialize VIC screen 3 ( value is %00xx00yy where xx is xpos and yy is ypos
void gfx_init_screen3() {
    byte* ch=VICII_SCREEN3;
    for(byte cy: 0..24 ) {
        for(byte cx: 0..39) {
            *ch++ = (cx&3)*$10|(cy&3);
        }
    }
}

// Initialize VIC screen 4 - all chars are 00
void gfx_init_screen4() {
    byte* ch=VICII_SCREEN4;
    for(byte cy: 0..24 ) {
        for(byte cx: 0..39) {
            *ch++ = 0;
        }
    }
}

// Initialize VIC bitmap
void gfx_init_VICII_bitmap() {
    // Draw some lines on the bitmap
    bitmap_init(VICII_BITMAP, VICII_SCREEN0);
    bitmap_clear(BLACK, WHITE);
    byte lines_x[] = { $00, $ff, $ff, $00, $00, $80, $ff, $80, $00, $80 };
    byte lines_y[] = { $00, $00, $c7, $c7, $00, $00, $64, $c7, $64, $00 };
    byte lines_cnt = 9;
    for(byte l=0; l<lines_cnt;l++) {
        bitmap_line(lines_x[l], lines_y[l], lines_x[l+1], lines_y[l+1]);
    }
}

// Initialize 8BPP Chunky Bitmap (contains 8bpp pixels)
void gfx_init_plane_8bppchunky() {
    // 320x200 8bpp pixels for Plane
    byte gfxbCpuBank = (byte)(PLANE_8BPP_CHUNKY/$4000);
    dtvSetCpuBankSegment1(gfxbCpuBank++);
    byte* gfxb = (char*)$4000;
    for(byte y : 0..199) {
        for (word x : 0..319) {
            // If we have crossed to $8000 increase the CPU BANK segment and reset to $4000
            if(gfxb==$8000) {
                dtvSetCpuBankSegment1(gfxbCpuBank++);
                gfxb = (byte*)$4000;
            }
            byte c = (byte)(x+y);
            *gfxb++ = c;
        }
    }
    // Reset CPU BANK segment to $4000
    dtvSetCpuBankSegment1((byte)($4000/$4000));
}

// Initialize Plane with Horizontal Stripes
void gfx_init_plane_horisontal() {
    byte gfxbCpuBank = (byte)(PLANE_HORISONTAL/$4000);
    dtvSetCpuBankSegment1(gfxbCpuBank++);
    byte* gfxa = (char*)$4000 + (PLANE_HORISONTAL & $3fff);
    for(byte ay : 0..199) {
        for (byte ax : 0..39) {
            if((ay&4)==0) {
                *gfxa++ = %00000000;
            } else {
                *gfxa++ = %11111111;
            }
        }
    }
    // Reset CPU BANK segment to $4000
    dtvSetCpuBankSegment1((byte)($4000/$4000));
}

// Initialize Plane with Horizontal Stripes every 2 pixels
void gfx_init_plane_horisontal2() {
    byte gfxbCpuBank = (byte)(PLANE_HORISONTAL2/$4000);
    dtvSetCpuBankSegment1(gfxbCpuBank++);
    byte* gfxa = (char*)$4000 + (PLANE_HORISONTAL2 & $3fff);
    byte row_bitmask[] = { %00000000, %01010101, %10101010, %11111111 };
    for(byte ay : 0..199) {
        for (byte ax : 0..39) {
            byte row = (ay/2) & 3;
            *gfxa++ = row_bitmask[row];
        }
    }
    // Reset CPU BANK segment to $4000
    dtvSetCpuBankSegment1((byte)($4000/$4000));
}

// Initialize Plane with Vertical Stripes
void gfx_init_plane_vertical() {
    byte gfxbCpuBank = (byte)(PLANE_VERTICAL/$4000);
    dtvSetCpuBankSegment1(gfxbCpuBank++);
    byte* gfxb = (char*)$4000 + (PLANE_VERTICAL & $3fff);
    for(byte by : 0..199) {
        for ( byte bx : 0..39) {
            *gfxb++ = %00001111;
        }
    }
    // Reset CPU BANK segment to $4000
    dtvSetCpuBankSegment1((byte)($4000/$4000));
}

// Initialize Plane with 8bpp charset
void gfx_init_plane_charset8() {
    // 8bpp cells for Plane B (charset) - ROM charset with 256 colors
    byte gfxbCpuBank = (byte)(PLANE_CHARSET8/$4000);
    dtvSetCpuBankSegment1(gfxbCpuBank++);
    byte* gfxa = (char*)$4000 + (PLANE_CHARSET8 & $3fff);
    byte* chargen = CHARGEN;
    *PROCPORT = PROCPORT_RAM_CHARROM;
    byte col = 0;
    for(byte ch : $00..$ff) {
        for ( byte cr : 0..7) {
            byte bits = *chargen++;
            for ( byte cp : 0..7) {
                byte c = 0;
                if((bits & $80) != 0) {
                    c = col;
                }
                *gfxa++ = c;
                bits = bits*2;
                col++;
            }
        }
    }
    *PROCPORT = PROCPORT_RAM_IO;
    // Reset CPU BANK segment to $4000
    dtvSetCpuBankSegment1((byte)($4000/$4000));
}

// Initialize Plane with Vertical Stripes every 2 pixels
void gfx_init_plane_vertical2() {
    gfx_init_plane_fill(PLANE_VERTICAL2, %00011011);
}

// Initialize Plane with blank pixels
void gfx_init_plane_blank() {
    gfx_init_plane_fill(PLANE_BLANK, 0);
}

// Initialize Plane with all pixels
void gfx_init_plane_full() {
    gfx_init_plane_fill(PLANE_FULL, $ff);
}

// Initialize 320*200 1bpp pixel ($2000) plane with identical bytes
void gfx_init_plane_fill(dword plane_addr, byte fill) {
    byte gfxbCpuBank = BYTE2(plane_addr*4);
    dtvSetCpuBankSegment1(gfxbCpuBank++);
    byte* gfxb = (byte*)$4000 + (WORD0(plane_addr) & $3fff);
    for(byte by : 0..199) {
        for ( byte bx : 0..39) {
                *gfxb++ = fill;
        }
    }
    // Reset CPU BANK segment to $4000
    dtvSetCpuBankSegment1((byte)($4000/$4000));
}

// Show the form - and let the user change values
void form_mode() {
    // Show the form

    // Form Colors
    print_set_screen(COLS);
    print_cls();
    print_str_lines(FORM_COLS);
    // Form Text
    print_set_screen(FORM_SCREEN);
    print_cls();
    print_str_lines(FORM_TEXT);
    // Form Fields
    form_set_screen(FORM_SCREEN);
    form_render_values();
    render_preset_name(*form_preset);

    // DTV Graphics Bank
    *DTV_GRAPHICS_VIC_BANK = (byte)((dword)FORM_CHARSET/$10000);
    // DTV Color Bank
    *DTV_COLOR_BANK_LO = BYTE0((word)(DTV_COLOR_BANK_DEFAULT/$400));
    *DTV_COLOR_BANK_HI = BYTE1((word)(DTV_COLOR_BANK_DEFAULT/$400));
    // VIC Graphics Bank
    CIA2->PORT_A_DDR = %00000011; // Set VIC Bank bits to output - all others to input
    CIA2->PORT_A = %00000011 ^ (byte)((word)FORM_CHARSET/$4000); // Set VIC Bank
    // DTV Graphics Mode
    *DTV_CONTROL = 0;
    // VIC Graphics Mode
    VICII->CONTROL1 = VICII_DEN|VICII_RSEL|3;
    VICII->CONTROL2 = VICII_CSEL;
    // VIC Memory Pointers
    VICII->MEMORY =  (byte)((((word)FORM_SCREEN&$3fff)/$40)|(((word)FORM_CHARSET&$3fff)/$400));
    // DTV Plane A to FORM_SCREEN also
    *DTV_PLANEA_START_LO = BYTE0(FORM_SCREEN);
    *DTV_PLANEA_START_MI = BYTE1(FORM_SCREEN);
    *DTV_PLANEA_START_HI = 0;
    // DTV Palette - default
    for(byte i : 0..$f) {
        DTV_PALETTE[i] = DTV_PALETTE_DEFAULT[i];
    }
    // Screen colors
    VICII->BG_COLOR = 0;
    VICII->BORDER_COLOR = 0;

    byte preset_current = *form_preset;

    // Let the user change values in the form
    while(true) {
        while(VICII->RASTER!=$ff) {}
        if(form_control()!=0) {
            // Space pressed - change to GFX mode
            return;
        }
        if(preset_current!=*form_preset) {
            // Preset changed - update field values and render
            apply_preset(*form_preset);
            preset_current = *form_preset;
            form_render_values();
            render_preset_name(*form_preset);
        }
    }
    return;
}

// Table with addresses of the y-lines of the form. The first line contains the address of the form screen.
byte form_line_lo[25];
byte form_line_hi[25];
// Current selected field in the form
byte form_field_idx = 0;

// The number of frames to use for a full blink cycle
const signed byte FORM_CURSOR_BLINK = 40;
// Counts down to blink for form cursor (it is inversed in the lower half)
signed byte form_cursor_count = FORM_CURSOR_BLINK/2;

// Set the screen to use for the form.
// screen is the start address of the screen to use
void form_set_screen(byte* screen) {
    // Calculate the field line table
    byte* line = screen;
    for(byte y: 0..24) {
        form_line_lo[y] = BYTE0(line);
        form_line_hi[y] = BYTE1(line);
        line = line + 40;
    }
}

// Get the screen address of a form field
// field_idx is the index of the field to get the screen address for
byte* form_field_ptr(byte field_idx) {
    byte y = form_fields_y[field_idx];
    byte* line = (byte*) MAKEWORD( form_line_hi[y], form_line_lo[y] );
    byte x = form_fields_x[field_idx];
    byte* field = line+x;
    return field;
}

// Render all form values from the form_fields_val array
void form_render_values() {
    for( byte idx=0; idx<form_fields_cnt; idx++) {
        byte* field = form_field_ptr(idx);
        *field = print_hextab[form_fields_val[idx]];
    }
}

// Reads keyboard and allows the user to navigate and change the fields of the form
// Returns 0 if space is not pressed, non-0 if space is pressed
byte form_control() {
    byte* field = form_field_ptr(form_field_idx);

    // Blinking cursor
    if(--form_cursor_count < 0) {
        form_cursor_count = FORM_CURSOR_BLINK;
    }
    if(form_cursor_count<FORM_CURSOR_BLINK/2) {
        *field = *field | $80;
    } else {
        *field = *field & $7f;
    }

    // Scan the keyboard
    keyboard_event_scan();
    byte key_event = keyboard_event_get();

    // Navigation using cursor up/down
    if(key_event==KEY_CRSR_DOWN) {
        // Unblink the cursor
        *field = *field & $7f;
        if((keyboard_modifiers&KEY_MODIFIER_SHIFT)==0) {
            // Move to next field
            if(++form_field_idx==form_fields_cnt) {
                form_field_idx = 0;
            }
         } else {
            // Move to previous field
            if(--form_field_idx==$ff) {
                form_field_idx = form_fields_cnt-1;
            }
         }
        // Always blink cursor in new field
        form_cursor_count = FORM_CURSOR_BLINK/2;
        // Return to refresh
        return 0;
    }

    // Change value with cursor left/right
    if(key_event==KEY_CRSR_RIGHT) {
        if((keyboard_modifiers&KEY_MODIFIER_SHIFT)==0) {
            // Increase value
            if(++form_fields_val[form_field_idx]>form_fields_max[form_field_idx]) {
                form_fields_val[form_field_idx] = 0;
            }
        } else {
            // Decrease value
            if(--form_fields_val[form_field_idx]==$ff) {
                form_fields_val[form_field_idx] = form_fields_max[form_field_idx];
            }
        }
        // Render field value
        *field = print_hextab[form_fields_val[form_field_idx]];
        return 0;
     }

     // Check for space press
     if(key_event==KEY_SPACE) {
        return $ff;
     }
     return 0;

}
