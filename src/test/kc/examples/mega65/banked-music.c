// SID music located in another bank being played using memory mapping on MEGA65
// Music is Cybernoid II by Jeroen Tel released in 1988 by Hewson https://csdb.dk/sid/?id=28140
// SID relocated using http://www.linusakesson.net/software/sidreloc/index.php
#pragma target(mega65)
#pragma link("mega65_banked.ld")
#include <mega65.h>

void main() {
    // Stop IRQ's
    asm { sei }
    // Remap [$4000-$5fff] to point to [$10000-$11fff]
    memoryRemapBlock(0x40, 0x100);
    // Transfer banked code/data to upper memory ($11000)
    for( char *src=upperCodeData, *dst=MUSIC; dst<MUSIC_END; )
        *dst++ = *src++;
    // Initialize SID memory is still remapped)
    (*musicInit)();
    // Reset memory mapping
    memoryRemap(0,0,0);

    // Pointer to (unmapped) $4000 used for overwriting to demonstrate the mapping works
    char* mem_destroy = MUSIC;
    
    for(;;) {
        // Overwrite data in the unmapped memory where the music is mapped in (to demonstrate that mapping works)
        *mem_destroy = 0;
        if(++mem_destroy==MUSIC_END) mem_destroy = MUSIC;
        // Wait for the raster
        while(VICII->RASTER!=0xff) ;            
        // Color border
        (VICII->BORDER_COLOR)++;
        // Remap memory to put music at $4000
        memoryRemapBlock(0x40, 0x100);
        // Play remapped SID
        (*musicPlay)();
        // Reset memory mapping
        memoryRemap(0,0,0);
        // Color border
        (VICII->BORDER_COLOR)--;        
        // Wait for the raster
        while(VICII->RASTER==0xff) ;
    }

}

// Array containing the banked upper memory code/data to be transferred to upper memory before execution
char upperCodeData[] = kickasm {{
    .segmentout [segments="Banked"]
}};

// Code and data to be put into upper memory, which will be banked into $4000
#pragma code_seg(CodeBanked)
#pragma data_seg(DataBanked)

// SID tune at an absolute address
__address(0x4000) char MUSIC[] = kickasm(resource "Cybernoid_II_4000.sid") {{
    .const music = LoadSid("Cybernoid_II_4000.sid")
    .fill music.size, music.getData(i)
}};

// Address after the end of the music
char * const MUSIC_END = 0x5200;

// Pointer to the music init routine
void()* musicInit = (void()*) MUSIC;
// Pointer to the music play routine
void()* musicPlay = (void()*) MUSIC+3;