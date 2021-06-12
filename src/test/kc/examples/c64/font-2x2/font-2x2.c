// Creates a 2x2 font from the system CHARGEN font and compress it by identifying identical chars

#include <c64.h>
#include <string.h>

char* const SCREEN = (char*)0x0400;
char* const FONT_ORIGINAL = (char*)0x2000;
char* const FONT_COMPRESSED = (char*)0x2800;
char __align(0x100) FONT_COMPRESSED_MAP[0x100];

void main() {
    // Create 2x2 font from CHARGEN
    asm { sei }
    *PROCPORT = PROCPORT_RAM_CHARROM;
    font_2x2(CHARGEN, FONT_ORIGINAL);
    *PROCPORT = PROCPORT_BASIC_KERNEL_IO;
    asm { cli }
    // Compress the font finding identical characters
    char size = font_compress(FONT_ORIGINAL, FONT_COMPRESSED, FONT_COMPRESSED_MAP);
    // Show compressed font
    *D018 = toD018(SCREEN, FONT_COMPRESSED);
    // Clear the screen
    memset(SCREEN, FONT_COMPRESSED_MAP[' '], 0x0400);
    // Show the font
    char* cursor = SCREEN;
    char c = 0;
    for(char y:0..7) {
        for(char x:0..7) {
            show(c++, x, y, FONT_COMPRESSED_MAP);
        }
    }
    while(true)
        (*(SCREEN+999))++;
}

// Show a 2x2 char on the screen at 2x2-position (x, y) using a font compress mapping
void show(char c, char x, char y, char* font_mapping) {
    char* ptr = SCREEN + (unsigned int)y*80 + x*2;
    ptr[0] = font_mapping[c];
    ptr[1] = font_mapping[c+0x40];
    ptr[40] = font_mapping[c+0x80];
    ptr[41] = font_mapping[c+0xc0];
}

// Create a 2x2-font by doubling all pixels of the 64 first chars
void font_2x2(char* font_original, char* font_2x2) {
    char* next_original = font_original;
    char* next_2x2 = font_2x2;
    for(char c: 0..0x3f) {
        char* next_2x2_left = next_2x2;
        char* next_2x2_right = next_2x2 + 0x40*8;
        char l2 = 0;
        for(char l: 0..7) {
            char glyph_bits = next_original[l];
            unsigned int glyph_bits_2x2 = 0;
            for(char b: 0..7) {
                // Find the bit
                char glyph_bit = (glyph_bits&0x80)?1uc:0uc;
                // Roll the bit into the current char twice
                glyph_bits_2x2 = glyph_bits_2x2<<1|glyph_bit;
                glyph_bits_2x2 = glyph_bits_2x2<<1|glyph_bit;
                // Move to next bit
                glyph_bits <<= 1;
            }
            // Put the generated 2x2-line into the 2x2-font twice
            next_2x2_left[l2] = BYTE1(glyph_bits_2x2);
            next_2x2_left[l2+1] = BYTE1(glyph_bits_2x2);
            next_2x2_right[l2] = BYTE0(glyph_bits_2x2);
            next_2x2_right[l2+1] = BYTE0(glyph_bits_2x2);
            l2 += 2;
            if(l2==8) {
                // Move to bottom chars
                next_2x2_left = next_2x2 + 0x80*8;
                next_2x2_right = next_2x2 + 0xc0*8;
                l2 = 0;
            }
        }
        next_2x2 += 8;
        next_original += 8;
    }
}


// Compress a font finding identical characters
// The compressed font is put into font_compressed and the compress_mapping is updated
// so that compress_mapping[c] points to the char in font_compressed that is identical to char c in font_original
// Returns the size of the compressed font (in chars)
char font_compress(char* font_original, char* font_compressed, char* compress_mapping) {
    char font_size = 0;
    char* next_original = font_original;
    char* next_compressed = font_compressed;
    for(char i: 0..0xff) {
        // Look for the char in font_compressed
        char found = font_find(next_original, font_compressed, font_size);
        if(found==0xff) {
            // Glyph not found - create it
            for(char l:0..7)
                next_compressed[l] = next_original[l];
            next_compressed += 8;
            found = font_size;
            font_size++;
        }
        compress_mapping[i] = found;
        next_original += 8;
    }
    return font_size;
}

// Look for a glyph within a font
// Only looks at the first font_size glyphs
// Returns the index of the glyph within the font. Returns 0xff if the glyph is not found.
char font_find(char* glyph, char* font, char font_size) {
    for(char i=0;i<font_size;i++) {
        char found = 1;
        for(char l:0..7) {
            if(glyph[l]!=font[l]) {
                found = 0;
                break;
            }
        }
        if(found)
            return i;
        font += 8;
    }
    // Not found
    return 0xff;
}
