// Commander X16 Functions
// https://www.commanderx16.com/forum/index.php?/about-faq/
// https://github.com/commanderx16/x16-docs/blob/master/Commander%20X16%20Programmer's%20Reference%20Guide.md

#include <cx16.h>

// Put a single byte into VRAM.
// Uses VERA DATA0
// - bank: Which 64K VRAM bank to put data into (0/1)
// - addr: The address in VRAM
// - data: The data to put into VRAM
void vpoke(char bank, char* addr, char data) {
    // Select DATA0
    *VERA_CTRL &= ~VERA_ADDRSEL;
    // Set address
    *VERA_ADDRX_L = <addr;
    *VERA_ADDRX_M = >addr;
    *VERA_ADDRX_H = VERA_INC_0 | bank;
    // Set data
    *VERA_DATA0 = data;
}