// SID music located in another bank being played in a raster IRQ using memory mapping on the MEGA65
// Music is Cybernoid II by Jeroen Tel released in 1988 by Hewson https://csdb.dk/sid/?id=28140
// SID relocated using http://www.linusakesson.net/software/sidreloc/index.php
#pragma target(mega65)
#pragma link("mega65_banked.ld")
#include <mega65.h>

void main() {
    // Stop IRQ's
    asm { sei }
    // Map memory to BANK 0 : 0x00XXXX - giving access to I/O
    memoryRemap(0,0,0);
    // Enable MEGA65 features
    VICIII->KEY = 0x47;   
    VICIII->KEY = 0x53;
    // Enable 48MHz fast mode
    VICIV->CONTROLB |= 0x40;
    VICIV->CONTROLC |= 0x40;
    // no kernal or BASIC rom visible
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;
    // open sideborder
    VICIV->SIDBDRWD_LO = 1;    

    // Remap [$4000-$5fff] to point to [$10000-$11fff]
    memoryRemapBlock(0x40, 0x100);
    // Transfer banked code/data to upper memory ($10000)
    for( char *src=upperCodeData, *dst=MUSIC; dst<MUSIC_END; )
        *dst++ = *src++;
    // Initialize SID memory is still remapped)
    (*musicInit)();
    // Reset memory mapping
    memoryRemap(0,0,0);

    // Set up raster interrupts C64 style
    // Disable CIA 1 Timer IRQ
    CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR;
    // Set raster line to 0xff
    VICII->RASTER = 0xff;
    VICII->CONTROL1 &= 0x7f;
    // Enable Raster Interrupt
    VICII->IRQ_ENABLE = IRQ_RASTER;
    // Set the IRQ routine
    *HARDWARE_IRQ = &irq;

    // Enable IRQ
    asm { cli }
    
    // Loop forever - while destroying and showing unmapped MUSIC memory to screen (to demonstrate that mapping works)
    char mem_destroy_i = 0;
    for(;;) {
        // Overwrite unmapped MUSIC memory
        MUSIC[mem_destroy_i++]++;
        // Show unmapped MUSIC memory
        for(char i=0;i<240;i++)
            DEFAULT_SCREEN[i] = MUSIC[i];
    }

}

// Raster IRQ routine
interrupt(hardware_stack) void irq() {
    // Acknowledge the IRQ
    VICII->IRQ_STATUS = IRQ_RASTER;
    // Color border
    (VICII->BORDER_COLOR)++;
    // Remap memory to put music at $4000
    memoryRemapBlock(0x40, 0x100);
    // Play remapped SID
    (*musicPlay)();
    // Reset memory mapping
    memoryRemap(0,0,0);
    // Wait for the next raster line
    char raster = VICII->RASTER;
    while(VICII->RASTER==raster) ;    
    // Color border
    (VICII->BORDER_COLOR)--;        
}

// Array containing the banked upper memory code/data to be transferred to upper memory before execution
char upperCodeData[] = kickasm {{
    .segmentout [segments="Banked"]
}};

// Code and data to be put into upper memory, which will be banked into $4000 by mempry mapping
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