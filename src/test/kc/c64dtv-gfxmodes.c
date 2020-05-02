// Exploring C64DTV Screen Modes
#include <c64dtv.h>
#include <print.h>
#include <keyboard.h>
#include <bitmap-draw.h>

void main() {
    asm { sei }  // Disable normal interrupt (prevent keyboard reading glitches and allows to hide basic/kernal)
    // Disable kernal & basic
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;
    // Enable DTV extended modes
    *DTV_FEATURE = DTV_FEATURE_ENABLE;
    // Enter the menu for ever
    while(true) {
        menu();
    }
}

byte MENU_TEXT[] =
     "C64DTV Graphics Modes            CCLHBME@"
     "                                 OHIIMCC@"
     "                                 LUNCMMM@"
     "----------------------------------------@"
     "1. Standard Char             (V) 0000000@"
     "2. Extended Color Char       (V) 0000001@"
     "3. Multicolor Char           (V) 0000010@"
     "4. Standard Bitmap           (V) 0000100@"
     "5. Multicolor Bitmap         (V) 0000110@"
     "6. High Color Standard Char  (H) 0001000@"
     "7. High Extended Color Char  (H) 0001001@"
     "8. High Multicolor Char      (H) 0001010@"
     "9. High Multicolor Bitmap    (H) 0001110@"
     "a. Sixs Fred 2               (D) 0010111@"
     "b. Two Plane Bitmap          (D) 0011101@"
     "c. Sixs Fred (2 Plane MC BM) (D) 0011111@"
     "d. 8bpp Pixel Cell           (D) 0111011@"
     "e. Chunky 8bpp Bitmap        (D) 1111011@"
     "----------------------------------------@"
     "    (V) vicII (H) vicII+hicol (D) c64dtv@"
     ;


void menu() {
    byte* const SCREEN = $8000;
    byte* const CHARSET = $9800; // Charset ROM
    // DTV Graphics Bank
    *DTV_GRAPHICS_VIC_BANK = (byte)((dword)CHARSET/$10000);
    // DTV Color Bank
     *DTV_COLOR_BANK_LO = <((word)(DTV_COLOR_BANK_DEFAULT/$400));
     *DTV_COLOR_BANK_HI = >((word)(DTV_COLOR_BANK_DEFAULT/$400));
    // DTV Graphics Mode
    *DTV_CONTROL = 0;
    // VIC Graphics Bank
    CIA2->PORT_A_DDR = %00000011; // Set VIC Bank bits to output - all others to input
    CIA2->PORT_A = %00000011 ^ (byte)((word)CHARSET/$4000); // Set VIC Bank
    // VIC Graphics Mode
    *VIC_CONTROL = VIC_DEN|VIC_RSEL|3;
    *VIC_CONTROL2 = VIC_CSEL;
    // VIC Memory Pointers
    *VIC_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)CHARSET&$3fff)/$400));
    // DTV Palette - default
    for(byte i : 0..$f) {
        DTV_PALETTE[i] = DTV_PALETTE_DEFAULT[i];
    }
    // Char Colors
    for(byte* c=COLS;c!=COLS+1000;c++) *c=LIGHT_GREEN;
    // Screen colors
    *BG_COLOR = 0;
    *BORDER_COLOR = 0;
    // Display menu Text
    print_set_screen(SCREEN);
    print_cls();
    print_str_lines(MENU_TEXT);
    // Wait for key press
    while(true) {
        if(keyboard_key_pressed(KEY_1)!=0) {
            mode_stdchar();
            return;
        }
        if(keyboard_key_pressed(KEY_2)!=0) {
            mode_ecmchar();
            return;
        }
        if(keyboard_key_pressed(KEY_3)!=0) {
            mode_mcchar();
            return;
        }
        if(keyboard_key_pressed(KEY_4)!=0) {
            mode_stdbitmap();
            return;
        }
        if(keyboard_key_pressed(KEY_6)!=0) {
            mode_hicolstdchar();
            return;
        }
        if(keyboard_key_pressed(KEY_7)!=0) {
            mode_hicolecmchar();
            return;
        }
        if(keyboard_key_pressed(KEY_8)!=0) {
            mode_hicolmcchar();
            return;
        }
        if(keyboard_key_pressed(KEY_A)!=0) {
            mode_sixsfred2();
            return;
        }
        if(keyboard_key_pressed(KEY_B)!=0) {
            mode_twoplanebitmap();
            return;
        }
        if(keyboard_key_pressed(KEY_C)!=0) {
            mode_sixsfred();
            return;
        }
        if(keyboard_key_pressed(KEY_D)!=0) {
            mode_8bpppixelcell();
            return;
        }
        if(keyboard_key_pressed(KEY_E)!=0) {
            mode_8bppchunkybmm();
            return;
        }
    }

}

// The value of the DTV control register
byte dtv_control = 0;

// Allow the user to control the DTV graphics using different keys
void mode_ctrl() {
    while(true) {
        // Wait for the raster
        while(*RASTER!=$ff) { }
        // Check for space to exit
        if(keyboard_key_pressed(KEY_SPACE)!=0) {
            return;
        }
        // Read the current control byte
        byte ctrl = dtv_control;
        // Test for control keys
        if(keyboard_key_pressed(KEY_L)!=0) {
            // DTV Graphics Mode - Linear
            ctrl = ctrl|DTV_LINEAR;
        }
        if(keyboard_key_pressed(KEY_H)!=0) {
            // DTV Graphics Mode - HighCol
            ctrl = ctrl|DTV_HIGHCOLOR;
        }
        if(keyboard_key_pressed(KEY_O)!=0) {
            // DTV Graphics Mode - Overscan
            ctrl = ctrl|DTV_OVERSCAN;
        }
        if(keyboard_key_pressed(KEY_B)!=0) {
            // DTV Graphics Mode - Border off
            ctrl = ctrl|DTV_BORDER_OFF;
        }
        if(keyboard_key_pressed(KEY_U)!=0) {
            // DTV Graphics Mode - chunky
            ctrl = ctrl|DTV_CHUNKY;
        }
        if(keyboard_key_pressed(KEY_C)!=0) {
            // DTV Graphics Mode - color ram off
            ctrl = ctrl|DTV_COLORRAM_OFF;
        }
        if(keyboard_key_pressed(KEY_0)!=0) {
            // DTV Graphics Mode - Reset
            ctrl = 0;
        }
        // If the control byte is modified - write it
        if(ctrl != dtv_control) {
            dtv_control = ctrl;
            *DTV_CONTROL = ctrl;
            *BORDER_COLOR = ctrl;
        }
    }
}


// Standard Character Mode (LINEAR/HICOL/CHUNK/COLDIS/ECM/MCM/BMM = 0)
// Resolution: 320x200
// Normal VIC Adressing:
// VicGfxData[16]: ( VicBank[1:0] & CharBase[2:0] & CharData[7:0] & RowCounter[2:0] )
// Pixel Shifter (1)
// - 0: 4bpp BG_COLORor0[3:0]
// - 1: 4bpp ColorData[3:0]
void mode_stdchar() {
    byte* const SCREEN = $8000;
    byte* const CHARSET = $9000; // Charset ROM
    byte* const COLORS = $d800;
    // DTV Graphics Bank
    *DTV_GRAPHICS_VIC_BANK = (byte)((dword)CHARSET/$10000);
    // DTV Color Bank
     *DTV_COLOR_BANK_LO = <((word)(DTV_COLOR_BANK_DEFAULT/$400));
     *DTV_COLOR_BANK_HI = >((word)(DTV_COLOR_BANK_DEFAULT/$400));
    // DTV Graphics Mode
    dtv_control = 0;
    *DTV_CONTROL = 0;
    // VIC Graphics Bank
    CIA2->PORT_A_DDR = %00000011; // Set VIC Bank bits to output - all others to input
    CIA2->PORT_A = %00000011 ^ (byte)((word)CHARSET/$4000); // Set VIC Bank
    // VIC Graphics Mode
    *VIC_CONTROL = VIC_DEN|VIC_RSEL|3;
    *VIC_CONTROL2 = VIC_CSEL;
    // VIC Memory Pointers
    *VIC_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)CHARSET&$3fff)/$400));
    // DTV Palette - default
    for(byte i : 0..$f) {
        DTV_PALETTE[i] = DTV_PALETTE_DEFAULT[i];
    }
    // Screen colors
    *BG_COLOR = 0;
    *BORDER_COLOR = 0;
    // Char Colors and screen chars
    byte* col=COLORS;
    byte* ch=SCREEN;
    for(byte cy: 0..24 ) {
        for(byte cx: 0..39) {
            *col++ = (cx+cy)&$f;
            *ch++ = (cy&$f)*$10|(cx&$f);
        }
    }
    // Leave control to the user until exit
    mode_ctrl();
}

// Extended Background Color Character Mode (LINEAR/HICOL/CHUNK/COLDIS/MCM/BMM = 0, ECM = 1)
// Resolution: 320x200
// Normal VIC Adressing:
// VicGfxData[16]: ( VicBank[1:0] & CharBase[2:0] & "00" & CharData[5:0] & RowCounter[2:0] ) 
// GfxData Pixel Shifter (1)
//  - 0: 4bpp Background Color
//    - CharData[7:6] 00: 4bpp BG_COLORor0[3:0]
//    - CharData[7:6] 01: 4bpp BG_COLORor1[3:0]
//    - CharData[7:6] 10: 4bpp BG_COLORor2[3:0]
//    - CharData[7:6] 11: 4bpp BG_COLORor3[3:0]
//  - 1: 4bpp ColorData[3:0]
void mode_ecmchar() {
    byte* const SCREEN = $8000;
    byte* const CHARSET = $9000; // Charset ROM
    byte* const COLORS = $d800;
    // DTV Graphics Bank
    *DTV_GRAPHICS_VIC_BANK = (byte)((dword)CHARSET/$10000);
    // DTV Color Bank
     *DTV_COLOR_BANK_LO = <((word)(DTV_COLOR_BANK_DEFAULT/$400));
     *DTV_COLOR_BANK_HI = >((word)(DTV_COLOR_BANK_DEFAULT/$400));
    // DTV Graphics Mode
    dtv_control = 0;
    *DTV_CONTROL = 0;
    // VIC Graphics Bank
    CIA2->PORT_A_DDR = %00000011; // Set VIC Bank bits to output - all others to input
    CIA2->PORT_A = %00000011 ^ (byte)((word)CHARSET/$4000); // Set VIC Bank
    // VIC Graphics Mode
    *VIC_CONTROL = VIC_DEN|VIC_RSEL|VIC_ECM|3;
    *VIC_CONTROL2 = VIC_CSEL;
    // VIC Memory Pointers
    *VIC_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)CHARSET&$3fff)/$400));
    // DTV Palette - default
    for(byte i : 0..$f) {
        DTV_PALETTE[i] = DTV_PALETTE_DEFAULT[i];
    }
    // Screen colors
    *BORDER_COLOR = 0;
    *BG_COLOR = 0;
    *BG_COLOR1 = 2;
    *BG_COLOR2 = 5;
    *BG_COLOR3 = 6;
    // Char Colors and screen chars
    byte* col=COLORS;
    byte* ch=SCREEN;
    for(byte cy: 0..24 ) {
        for(byte cx: 0..39) {
            *col++ = (cx+cy)&$f;
            *ch++ = (cy&$f)*$10|(cx&$f);
        }
    }
    // Leave control to the user until exit
    mode_ctrl();

}

// Multicolor Character Mode (LINEAR/HICOL/CHUNK/COLDIS/BMM/ECM = 0, MCM = 1)
// Resolution: 160x200 (320x200)
// Normal VIC Adressing:
// VicGfxData[16]: ( VicBank[1:0] & CharBase[2:0] & CharData[7:0] & RowCounter[2:0] )
// GfxData Pixel Shifter (1) if ColorData[3:3] = 0:
//  - 0: 4bpp BG_COLORor0[3:0]
//  - 1: 4bpp ColorData[2:0]
// GfxData Pixel Shifter (2) if ColorData[3:3] = 1:
//  - 00: 4bpp BG_COLORor0[3:0]
//  - 01: 4bpp BG_COLORor1[3:0]
//  - 10: 4bpp BG_COLORor2[3:0]
//  - 11: 4bpp ColorData[2:0]// Standard Character Mode (LINEAR/HICOL/CHUNK/COLDIS/ECM/MCM/BMM = 0)
void mode_mcchar() {
    byte* const SCREEN = $8000;
    byte* const CHARSET = $9000; // Charset ROM
    byte* const COLORS = $d800;
    // DTV Graphics Bank
    *DTV_GRAPHICS_VIC_BANK = (byte)((dword)CHARSET/$10000);
    // DTV Color Bank
     *DTV_COLOR_BANK_LO = <((word)(DTV_COLOR_BANK_DEFAULT/$400));
     *DTV_COLOR_BANK_HI = >((word)(DTV_COLOR_BANK_DEFAULT/$400));
    // DTV Graphics Mode
    dtv_control = 0;
    *DTV_CONTROL = 0;
    // VIC Graphics Bank
    CIA2->PORT_A_DDR = %00000011; // Set VIC Bank bits to output - all others to input
    CIA2->PORT_A = %00000011 ^ (byte)((word)CHARSET/$4000); // Set VIC Bank
    // VIC Graphics Mode
    *VIC_CONTROL = VIC_DEN|VIC_RSEL|3;
    *VIC_CONTROL2 = VIC_CSEL|VIC_MCM;
    // VIC Memory Pointers
    *VIC_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)CHARSET&$3fff)/$400));
    // DTV Palette - default
    for(byte i : 0..$f) {
        DTV_PALETTE[i] = DTV_PALETTE_DEFAULT[i];
    }
    // Screen colors
    *BORDER_COLOR = 0;
    *BG_COLOR = BLACK;
    *BG_COLOR1 = GREEN;
    *BG_COLOR2 = BLUE;
    // Char Colors and screen chars
    byte* col=COLORS;
    byte* ch=SCREEN;
    for(byte cy: 0..24 ) {
        for(byte cx: 0..39) {
            *col++ = (cx+cy)&$f;
            *ch++ = (cy&$f)*$10|(cx&$f);
        }
    }
    // Leave control to the user until exit
    mode_ctrl();

}

// Standard Bitmap Mode (LINEAR/HICOL/CHUNK/COLDIS/MCM/ECM = 0, BMM = 1)
// Resolution: 320x200
// Normal VIC Adressing:
// VicGfxData[16]: ( VicBank[1:0] & CharBase[2:2] & Matrix[9:0] & RowCounter[2:0] )
// Pixel Shifter (1)
//  - 0: 4bpp CharData[3:0]
//  - 1: 4bpp CharData[7:4]
void mode_stdbitmap() {
    byte* const SCREEN = $4000;
    byte* const BITMAP = $6000;
    // DTV Graphics Bank
    *DTV_GRAPHICS_VIC_BANK = (byte)((dword)BITMAP/$10000);
    // DTV Graphics Mode
    dtv_control = 0;
    *DTV_CONTROL = 0;
    // VIC Graphics Bank
    CIA2->PORT_A_DDR = %00000011; // Set VIC Bank bits to output - all others to input
    CIA2->PORT_A = %00000011 ^ (byte)((word)BITMAP/$4000); // Set VIC Bank
    // VIC Graphics Mode
    *VIC_CONTROL = VIC_BMM|VIC_DEN|VIC_RSEL|3;
    *VIC_CONTROL2 = VIC_CSEL;
    // VIC Memory Pointers
    *VIC_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)BITMAP&$3fff)/$400));
    // DTV Palette - default
    for(byte i : 0..$f) {
        DTV_PALETTE[i] = DTV_PALETTE_DEFAULT[i];
    }
    // Screen colors
    *BG_COLOR = BLACK;
    *BORDER_COLOR = BLACK;
    // Bitmap Colors
    byte* ch=SCREEN;
    for(byte cy: 0..24 ) {
        for(byte cx: 0..39) {
            byte col = (cx+cy)&$f;
            byte col2 = ($f-col);
            *ch++ = col*$10 | col2;
        }
    }
    // Draw some lines on the bitmap
    bitmap_init(BITMAP);
    bitmap_clear();
    byte lines_x[] = { $00, $ff, $ff, $00, $00, $80, $ff, $80, $00, $80 };
    byte lines_y[] = { $00, $00, $c7, $c7, $00, $00, $64, $c7, $64, $00 };
    byte lines_cnt = 9;
    for(byte l=0; l<lines_cnt;l++) {
        bitmap_line(lines_x[l], lines_x[l+1], lines_y[l], lines_y[l+1]);
    }
    // Leave control to the user until exit
    mode_ctrl();
}

// High Color Standard Character Mode (LINEAR/CHUNK/COLDIS/ECM/MCM/BMM = 0, HICOL = 1)
// Resolution: 320x200
// Normal VIC Adressing:
// VicGfxData[16]: ( VicBank[1:0] & CharBase[2:0] & CharData[7:0] & RowCounter[2:0] )
// Pixel Shifter (1)
//  - 0: 8bpp BG_COLORor0[7:0]
//  - 1: 8bpp ColorData[7:0]
void mode_hicolstdchar() {
    byte* const SCREEN = $8000;
    byte* const CHARSET = $9000; // Charset ROM
    byte* const COLORS = $8400;
    // DTV Graphics Bank
    *DTV_GRAPHICS_VIC_BANK = (byte)((dword)CHARSET/$10000);
    // DTV Color Bank
     *DTV_COLOR_BANK_LO = <((word)(COLORS/$400));
     *DTV_COLOR_BANK_HI = >((word)(COLORS/$400));
    // DTV Graphics Mode
    dtv_control = DTV_HIGHCOLOR;
    *DTV_CONTROL = DTV_HIGHCOLOR;
    // VIC Graphics Bank
    CIA2->PORT_A_DDR = %00000011; // Set VIC Bank bits to output - all others to input
    CIA2->PORT_A = %00000011 ^ (byte)((word)CHARSET/$4000); // Set VIC Bank
    // VIC Graphics Mode
    *VIC_CONTROL = VIC_DEN|VIC_RSEL|3;
    *VIC_CONTROL2 = VIC_CSEL;
    // VIC Memory Pointers
    *VIC_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)CHARSET&$3fff)/$400));
    // DTV Palette - Grey Tones
     for(byte i : 0..$f) {
         DTV_PALETTE[i] = i;
     }
    // Screen colors
    *BG_COLOR = 0;
    *BORDER_COLOR = 0;
    // Char Colors and screen chars
    byte* col=COLORS;
    byte* ch=SCREEN;
    for(byte cy: 0..24 ) {
        for(byte cx: 0..39) {
            byte v = (cy&$f)*$10|(cx&$f);
            *col++ = v;
            *ch++ = v;
        }
    }
    // Leave control to the user until exit
    mode_ctrl();

}

// High Color Extended Background Color Character Mode (LINEAR/CHUNK/COLDIS/MCM/BMM = 0, ECM/HICOL = 1)
// Resolution: 320x200
// Normal VIC Adressing:
// VicGfxData[16]: ( VicBank[1:0] & CharBase[2:0] & "00" & CharData[5:0] & RowCounter[2:0] )
// GfxData Pixel Shifter (1)
//  - 0: 8bpp Background Color
//    - CharData[7:6] 00: 8bpp BG_COLORor0[7:0]
//    - CharData[7:6] 01: 8bpp BG_COLORor1[7:0]
//    - CharData[7:6] 10: 8bpp BG_COLORor2[7:0]
//    - CharData[7:6] 11: 8bpp BG_COLORor3[7:0]
//  - 1: 8bpp ColorData[7:0]
void mode_hicolecmchar() {
    byte* const SCREEN = $8000;
    byte* const CHARSET = $9000; // Charset ROM
    byte* const COLORS = $8400;
    // DTV Graphics Bank
    *DTV_GRAPHICS_VIC_BANK = (byte)((dword)CHARSET/$10000);
    // DTV Color Bank
     *DTV_COLOR_BANK_LO = <((word)(COLORS/$400));
     *DTV_COLOR_BANK_HI = >((word)(COLORS/$400));
    // DTV Graphics Mode
    dtv_control = DTV_HIGHCOLOR;
    *DTV_CONTROL = DTV_HIGHCOLOR;
    // VIC Graphics Bank
    CIA2->PORT_A_DDR = %00000011; // Set VIC Bank bits to output - all others to input
    CIA2->PORT_A = %00000011 ^ (byte)((word)CHARSET/$4000); // Set VIC Bank
    // VIC Graphics Mode
    *VIC_CONTROL = VIC_DEN|VIC_RSEL|VIC_ECM|3;
    *VIC_CONTROL2 = VIC_CSEL;
    // VIC Memory Pointers
    *VIC_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)CHARSET&$3fff)/$400));
    // DTV Palette - Grey Tones
     for(byte i : 0..$f) {
         DTV_PALETTE[i] = i;
     }
    // Screen colors
    *BORDER_COLOR = 0;
    *BG_COLOR = $50;
    *BG_COLOR1 = $54;
    *BG_COLOR2 = $58;
    *BG_COLOR3 = $5c;
    // Char Colors and screen chars
    byte* col=COLORS;
    byte* ch=SCREEN;
    for(byte cy: 0..24 ) {
        for(byte cx: 0..39) {
            byte v = (cy&$f)*$10|(cx&$f);
            *col++ = v;
            *ch++ = v;
        }
    }
    // Leave control to the user until exit
    mode_ctrl();
}

// High Color Multicolor Character Mode (LINEAR/CHUNK/COLDIS/BMM/ECM = 0, MCM/HICOL = 1)
// Resolution: 160x200 (320x200)
// Normal VIC Adressing:
// VicGfxData[16]: ( VicBank[1:0] & CharBase[2:0] & CharData[7:0] & RowCounter[2:0] )
//GfxData Pixel Shifter (1) if ColorData[3:3] = 0:
// - 0: 8bpp BG_COLORor0[7:0]
// - 1: 8bpp ColorData[7:4] "0" & Color[2:0]
//GfxData Pixel Shifter (2) if ColorData[3:3] = 1:
// - 00: 8bpp BG_COLORor0[7:0]
// - 01: 8bpp BG_COLORor1[7:0]
// - 10: 8bpp BG_COLORor2[7:0]
// - 11: 8bpp ColorData[7:4] "0" & Color[2:0]
void mode_hicolmcchar() {
    byte* const SCREEN = $8000;
    byte* const CHARSET = $9000; // Charset ROM
    byte* const COLORS = $8400;
    // DTV Graphics Bank
    *DTV_GRAPHICS_VIC_BANK = (byte)((dword)CHARSET/$10000);
    // DTV Color Bank
     *DTV_COLOR_BANK_LO = <((word)(COLORS/$400));
     *DTV_COLOR_BANK_HI = >((word)(COLORS/$400));
    // DTV Graphics Mode
    dtv_control = DTV_HIGHCOLOR;
    *DTV_CONTROL = DTV_HIGHCOLOR;
    // VIC Graphics Bank
    CIA2->PORT_A_DDR = %00000011; // Set VIC Bank bits to output - all others to input
    CIA2->PORT_A = %00000011 ^ (byte)((word)CHARSET/$4000); // Set VIC Bank
    // VIC Graphics Mode
    *VIC_CONTROL = VIC_DEN|VIC_RSEL|3;
    *VIC_CONTROL2 = VIC_CSEL|VIC_MCM;
    // VIC Memory Pointers
    *VIC_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)CHARSET&$3fff)/$400));
    // DTV Palette - Grey Tones
     for(byte i : 0..$f) {
         DTV_PALETTE[i] = i;
     }
    // Screen colors
    *BORDER_COLOR = 0;
    *BG_COLOR = $50;
    *BG_COLOR1 = $54;
    *BG_COLOR2 = $58;
    // Char Colors and screen chars
    byte* col=COLORS;
    byte* ch=SCREEN;
    for(byte cy: 0..24 ) {
        for(byte cx: 0..39) {
            byte v = (cy&$f)*$10|(cx&$f);
            *col++ = v;
            *ch++ = v;
        }
    }
    // Leave control to the user until exit
    mode_ctrl();
}

// Two Plane Bitmap - generated from the two DTV linear graphics plane counters
// Two Plane Bitmap Mode (CHUNK/COLDIS/MCM = 0, ECM/BMM/HICOL/LINEAR = 1)
// Resolution: 320x200
// Linear Adressing
// GfxData/PlaneA Pixel Shifter (1), CharData/PlaneB Pixel Shifter (1):
// - Plane A = 0 Plane B = 0: 8bpp BG_COLORor0[7:0]
// - Plane A = 0 Plane B = 1: 8bpp "0000" & ColorData[7:4]
// - Plane A = 1 Plane B = 0: 8bpp "0000" & ColorData[3:0]
// - Plane A = 1 Plane B = 1: 8bpp BG_COLORor1[7:0]
void mode_twoplanebitmap() {
    byte* const PLANEA = $4000;
    byte* const PLANEB = $6000;
    byte* const COLORS = $8000;
    // DTV Graphics Mode
    dtv_control = DTV_HIGHCOLOR | DTV_LINEAR;
    *DTV_CONTROL = DTV_HIGHCOLOR | DTV_LINEAR;
    // VIC Graphics Mode
    *VIC_CONTROL = VIC_ECM|VIC_BMM|VIC_DEN|VIC_RSEL|3;
    *VIC_CONTROL2 = VIC_CSEL;
    // Linear Graphics Plane A Counter
    *DTV_PLANEA_START_LO = <PLANEA;
    *DTV_PLANEA_START_MI = >PLANEA;
    *DTV_PLANEA_START_HI = 0;
    *DTV_PLANEA_STEP = 1;
    *DTV_PLANEA_MODULO_LO = 0;
    *DTV_PLANEA_MODULO_HI = 0;
    // Linear Graphics Plane B Counter
    *DTV_PLANEB_START_LO = <PLANEB;
    *DTV_PLANEB_START_MI = >PLANEB;
    *DTV_PLANEB_START_HI = 0;
    *DTV_PLANEB_STEP = 1;
    *DTV_PLANEB_MODULO_LO = 0;
    *DTV_PLANEB_MODULO_HI = 0;
    // DTV Color Bank
     *DTV_COLOR_BANK_LO = <(COLORS/$400);
     *DTV_COLOR_BANK_HI = >(COLORS/$400);
    // DTV Palette - Grey Tones
    for(byte i : 0..$f) {
        DTV_PALETTE[i] = i;
    }
    // Screen colors
    *BORDER_COLOR = $00;
    *BG_COLOR = $70; // Color for bits 00
    *BG_COLOR1 = $d4; // Color for bits 11
    // Colors for bits 01 / 10
    byte* col=COLORS;
    for(byte cy: 0..24 ) {
        for(byte cx: 0..39) {
            *col++ = (cy & $f)*$10 | (cx &$f);
        }
    }
    // Graphics for Plane A - horizontal stripes
    byte* gfxa = PLANEA;
    for(byte ay : 0..199) {
        for (byte ax : 0..39) {
            if((ay&4)==0) {
                *gfxa++ = %00000000;
            } else {
                *gfxa++ = %11111111;
            }
        }
    }
    // Graphics for Plane B - vertical stripes
    byte* gfxb = PLANEB;
    for(byte by : 0..199) {
        for ( byte bx : 0..39) {
            *gfxb++ = %00001111;
        }
    }
    // Leave control to the user until exit
    mode_ctrl();
}

// Sixs Fred Mode - 8bpp Packed Bitmap - Generated from the two DTV linear graphics plane counters
// Two Plane MultiColor Bitmap - 8bpp Packed Bitmap (CHUNK/COLDIS = 0, ECM/BMM/MCM/HICOL/LINEAR = 1)
// Resolution: 160x200
// Linear Adressing
// GfxData/PlaneA Pixel Shifter (2), CharData/PlaneB Pixel Shifter (2):
// - 8bpp color (ColorData[3:0],CharData/PlaneB[1:0], GfxData/PlaneA[1:0])
void mode_sixsfred() {
    byte* const PLANEA = $4000;
    byte* const PLANEB = $6000;
    byte* const COLORS = $8000;
    // DTV Graphics Mode
    dtv_control = DTV_HIGHCOLOR | DTV_LINEAR;
    *DTV_CONTROL = DTV_HIGHCOLOR | DTV_LINEAR;
    // VIC Graphics Mode
    *VIC_CONTROL = VIC_ECM|VIC_BMM|VIC_DEN|VIC_RSEL|3;
    *VIC_CONTROL2 = VIC_MCM|VIC_CSEL;
    // Linear Graphics Plane A Counter
    *DTV_PLANEA_START_LO = <PLANEA;
    *DTV_PLANEA_START_MI = >PLANEA;
    *DTV_PLANEA_START_HI = 0;
    *DTV_PLANEA_STEP = 1;
    *DTV_PLANEA_MODULO_LO = 0;
    *DTV_PLANEA_MODULO_HI = 0;
    // Linear Graphics Plane B Counter
    *DTV_PLANEB_START_LO = <PLANEB;
    *DTV_PLANEB_START_MI = >PLANEB;
    *DTV_PLANEB_START_HI = 0;
    *DTV_PLANEB_STEP = 1;
    *DTV_PLANEB_MODULO_LO = 0;
    *DTV_PLANEB_MODULO_HI = 0;
    // DTV Color Bank
     *DTV_COLOR_BANK_LO = <(COLORS/$400);
     *DTV_COLOR_BANK_HI = >(COLORS/$400);
    // DTV Palette - Grey Tones
    for(byte i : 0..$f) {
        DTV_PALETTE[i] = i;
    }
    // Screen colors
    *BORDER_COLOR = $00;
    // Colors for high 4 bits of 8bpp
    byte* col=COLORS;
    for(byte cy: 0..24 ) {
        for(byte cx: 0..39) {
            *col++ = (cx+cy) & $f;
        }
    }
    // Graphics for Plane A () - horizontal stripes every 2 pixels
    byte* gfxa = PLANEA;
    byte row_bitmask[] = { %00000000, %01010101, %10101010, %11111111 };
    for(byte ay : 0..199) {
        for (byte ax : 0..39) {
            byte row = (ay/2) & 3;
            *gfxa++ = row_bitmask[row];
        }
    }
    // Graphics for Plane B - vertical stripes every 2 pixels
    byte* gfxb = PLANEB;
    for(byte by : 0..199) {
        for ( byte bx : 0..39) {
                *gfxb++ = %00011011;
        }
    }
    // Leave control to the user until exit
    mode_ctrl();
}

// Sixs Fred Mode 2 - 8bpp Packed Bitmap - Generated from the two DTV linear graphics plane counters
// Two Plane MultiColor Bitmap - 8bpp Packed Bitmap (CHUNK/COLDIS/HICOL = 0, ECM/BMM/MCM/LINEAR = 1)
// Resolution: 160x200
// Linear Adressing
// PlaneA Pixel Shifter (2), PlaneB Pixel Shifter (2):
// - 8bpp color (PlaneB[1:0],ColorData[5:4],PlaneA[1:0],ColorData[1:0])
void mode_sixsfred2() {
    byte* const PLANEA = $4000;
    byte* const PLANEB = $6000;
    byte* const COLORS = $8000;
    // DTV Graphics Mode
    dtv_control = DTV_LINEAR;
    *DTV_CONTROL = DTV_LINEAR;
    // VIC Graphics Mode
    *VIC_CONTROL = VIC_ECM|VIC_BMM|VIC_DEN|VIC_RSEL|3;
    *VIC_CONTROL2 = VIC_MCM|VIC_CSEL;
    // Linear Graphics Plane A Counter
    *DTV_PLANEA_START_LO = <PLANEA;
    *DTV_PLANEA_START_MI = >PLANEA;
    *DTV_PLANEA_START_HI = 0;
    *DTV_PLANEA_STEP = 1;
    *DTV_PLANEA_MODULO_LO = 0;
    *DTV_PLANEA_MODULO_HI = 0;
    // Linear Graphics Plane B Counter
    *DTV_PLANEB_START_LO = <PLANEB;
    *DTV_PLANEB_START_MI = >PLANEB;
    *DTV_PLANEB_START_HI = 0;
    *DTV_PLANEB_STEP = 1;
    *DTV_PLANEB_MODULO_LO = 0;
    *DTV_PLANEB_MODULO_HI = 0;
    // DTV Color Bank
     *DTV_COLOR_BANK_LO = <(COLORS/$400);
     *DTV_COLOR_BANK_HI = >(COLORS/$400);
    // DTV Palette - Grey Tones
    for(byte i : 0..$f) {
        DTV_PALETTE[i] = i;
    }
    // Screen colors
    *BORDER_COLOR = $00;
    // Colors for high 4 bits of 8bpp
    byte* col=COLORS;
    for(byte cy: 0..24 ) {
        for(byte cx: 0..39) {
            *col++ = (cx&3)*$10|(cy&3);
        }
    }
    // Graphics for Plane A () - horizontal stripes every 2 pixels
    byte* gfxa = PLANEA;
    byte row_bitmask[] = { %00000000, %01010101, %10101010, %11111111 };
    for(byte ay : 0..199) {
        for (byte ax : 0..39) {
            byte row = (ay/2) & 3;
            *gfxa++ = row_bitmask[row];
        }
    }
    // Graphics for Plane B - vertical stripes every 2 pixels
    byte* gfxb = PLANEB;
    for(byte by : 0..199) {
        for ( byte bx : 0..39) {
                *gfxb++ = %00011011;
        }
    }
    // Leave control to the user until exit
    mode_ctrl();
}


//8bpp Pixel Cell Mode (BMM/COLDIS = 0, ECM/MCM/HICOL/LINEAR/CHUNK = 1)
//Pixel Cell Adressing
//CharData[8]: (PlaneA[21:0])
//GfxData[8]: (PlaneB[21:14] & CharData[7:0] & RowCounter[3:0] & PixelCounter[7:0] )
//GfxData Pixel Shifter (8):
//- 8bpp color GfxData[7:0]
//Pixel cell mode can be thought of as a text mode that uses a 8x8 pixel 8bpp font (64 bytes/char).
//The characters come from counter A and the font (or "cells") from counter B.
//Counter B step and modulo should be set to 0, counter A modulo to 0 and counter A step to 1 for normal operation.
void mode_8bpppixelcell() {
    // 8BPP Pixel Cell Screen (contains 40x25=1000 chars)
    byte* const PLANEA = $3c00;
    // 8BPP Pixel Cell Charset (contains 256 64 byte chars)
    byte* const PLANEB = $4000;
    // DTV Graphics Mode
    dtv_control = DTV_HIGHCOLOR | DTV_LINEAR | DTV_CHUNKY;
    *DTV_CONTROL = DTV_HIGHCOLOR | DTV_LINEAR | DTV_CHUNKY;
    // VIC Graphics Mode
    *VIC_CONTROL = VIC_ECM|VIC_DEN|VIC_RSEL|3;
    *VIC_CONTROL2 = VIC_MCM|VIC_CSEL;
    // Linear Graphics Plane A Counter
    *DTV_PLANEA_START_LO = <PLANEA;
    *DTV_PLANEA_START_MI = >PLANEA;
    *DTV_PLANEA_START_HI = 0;
    *DTV_PLANEA_STEP = 1;
    *DTV_PLANEA_MODULO_LO = 0;
    *DTV_PLANEA_MODULO_HI = 0;
    // Linear Graphics Plane B Counter
    *DTV_PLANEB_START_LO = <PLANEB;
    *DTV_PLANEB_START_MI = >PLANEB;
    *DTV_PLANEB_START_HI = 0;
    *DTV_PLANEB_STEP = 0;
    *DTV_PLANEB_MODULO_LO = 0;
    *DTV_PLANEB_MODULO_HI = 0;
    // Border color
    *BORDER_COLOR = $00;
    // DTV Palette - Grey Tones
    for(byte i : 0..$f) {
        DTV_PALETTE[i] = i;
    }
    // Screen Chars for Plane A (screen) - 16x16 repeating
    byte* gfxa = PLANEA;
    for(byte ay : 0..24) {
        for (byte ax : 0..39) {
            *gfxa++ = (ay & $f)*$10 | (ax & $f);
        }
    }
    // 8bpp cells for Plane B (charset) - ROM charset with 256 colors
    *PROCPORT = PROCPORT_RAM_CHARROM;
    byte* CHARGEN = $d000;
    byte* gfxb = PLANEB;
    byte* chargen = CHARGEN;
    byte col = 0;
    for(byte ch : $00..$ff) {
        for ( byte cr : 0..7) {
            byte bits = *chargen++;
            for ( byte cp : 0..7) {
                byte c = 0;
                if((bits & $80) != 0) {
                    c = col;
                }
                *gfxb++ = c;
                bits = bits*2;
                col++;
            }
        }
    }
    *PROCPORT = PROCPORT_RAM_IO;
    // Leave control to the user until exit
    mode_ctrl();
}


//Chunky 8bpp Bitmap Mode (BMM = 0, ECM/MCM/HICOL/LINEAR/CHUNK/COLDIS = 1)
// Resolution: 320x200
// Linear Adressing
// CharData/PlaneB Pixel Shifter (8):
// - 8bpp color PlaneB[7:0]
// To set up a linear video frame buffer the step size must be set to 8.
void mode_8bppchunkybmm() {
    // 8BPP Chunky Bitmap (contains 8bpp pixels)
    const dword PLANEB = $20000;
    // DTV Graphics Mode
    dtv_control = DTV_HIGHCOLOR | DTV_LINEAR | DTV_CHUNKY | DTV_COLORRAM_OFF;
    *DTV_CONTROL = DTV_HIGHCOLOR | DTV_LINEAR | DTV_CHUNKY | DTV_COLORRAM_OFF;
    // VIC Graphics Mode
    *VIC_CONTROL = VIC_ECM | VIC_DEN | VIC_RSEL | 3;
    *VIC_CONTROL2 = VIC_MCM | VIC_CSEL;
    // Linear Graphics Plane B Counter
    *DTV_PLANEB_START_LO = < < PLANEB;
    *DTV_PLANEB_START_MI = > < PLANEB;
    *DTV_PLANEB_START_HI = < > PLANEB;
    *DTV_PLANEB_STEP = 8;
    *DTV_PLANEB_MODULO_LO = 0;
    *DTV_PLANEB_MODULO_HI = 0;
    // Border color
    *BORDER_COLOR = $00;
    // DTV Palette - Grey Tones
    for(byte i : 0..$f) {
        DTV_PALETTE[i] = i;
    }

    // 320x200 8bpp pixels for Plane B
    byte gfxbCpuBank = (byte)(PLANEB/$4000);
    dtvSetCpuBankSegment1(gfxbCpuBank++);
    byte* gfxb = $4000;
    for(byte y : 0..199) {
        for (word x : 0..319) {
            // If we have crossed to $8000 increase the CPU BANK segment and reset to $4000
            if(gfxb==$8000) {
                dtvSetCpuBankSegment1(gfxbCpuBank++);
                gfxb = $4000;
            }
            byte c = (byte)(x+y);
            *gfxb++ = c;
        }
    }
    // Reset CPU BANK segment to $4000
    dtvSetCpuBankSegment1((byte)($4000/$4000));
    // Leave control to the user until exit
    mode_ctrl();
}
