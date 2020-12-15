// Commander X16 Functions
// https://www.commanderx16.com/forum/index.php?/about-faq/
// https://github.com/commanderx16/x16-docs/blob/master/Commander%20X16%20Programmer's%20Reference%20Guide.md

#include <cx16.h>

// Put a single byte into VRAM.
// Uses VERA DATA0
// - bank: Which 64K VRAM bank to put data into (0/1)
// - addr: The address in VRAM
// - data: The data to put into VRAM
void vpoke(char vbank, char* vaddr, char data) {
    // Select DATA0
    *VERA_CTRL &= ~VERA_ADDRSEL;
    // Set address
    *VERA_ADDRX_L = <vaddr;
    *VERA_ADDRX_M = >vaddr;
    *VERA_ADDRX_H = VERA_INC_0 | vbank;
    // Set data
    *VERA_DATA0 = data;
}

// Copy block of memory (from RAM to VRAM)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination in VRAM.
// - vbank: Which 64K VRAM bank to put data into (0/1)
// - vdest: The destination address in VRAM
// - src: The source address in RAM
// - num: The number of bytes to copy
void memcpy_to_vram(char vbank, void* vdest, void* src, unsigned int num ) {
    // Select DATA0
    *VERA_CTRL &= ~VERA_ADDRSEL;
    // Set address
    *VERA_ADDRX_L = <vdest;
    *VERA_ADDRX_M = >vdest;
    *VERA_ADDRX_H = VERA_INC_1 | vbank;
    // Transfer the data
    char *s = src;
    char *end = (char*)src+num;
    for(; s!=end; s++)
        *VERA_DATA0 = *s;
}
