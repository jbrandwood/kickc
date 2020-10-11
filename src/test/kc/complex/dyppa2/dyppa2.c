// Chunky DYPP with arbitrary sinus
// First implemented as dyppa.asm in 2011

#pragma emulator("C64Debugger")

#include <c64.h>
#include <string.h>

// The DYPPA charset containing the sloped offset characters
char __address(0x2000) DYPPA_CHARSET[0x0800] = kickasm(resource "dyppacharset.bin") {{
    .var dyppaFile = LoadBinary("dyppacharset.bin", "Charset=$000,Tables=$800")
    .fill dyppaFile.getCharsetSize(), dyppaFile.getCharset(i) 
}};

// The DYPPA tables mapping the slopes, offsets and pixels to the right character in the charset
// for(offset:0..7) for(slope:0..f) for(pixels: 0..f) glyph_id(offset,slope,pixels)  
char align(0x100) DYPPA_TABLE[0x0800] = kickasm(resource "dyppacharset.bin") {{
    .var dyppaFile2 = LoadBinary("dyppacharset.bin", "Charset=$000,Tables=$800")
    .fill dyppaFile2.getTablesSize(), dyppaFile2.getTables(i) 
}};

void main() {
    VICII->MEMORY = toD018(DEFAULT_SCREEN, DYPPA_CHARSET);
    memset(DEFAULT_SCREEN, DYPPA_TABLE[0], 1000);

    for(;;) {
        (*(DEFAULT_SCREEN+999))++;
    }

}



