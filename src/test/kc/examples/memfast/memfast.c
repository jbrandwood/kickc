/**
 * @file memfast.c
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief Demonstration of functions memcpy_fast and memset_fast
 * for 8 bit architectures.
 * @version 0.1
 * @date 2023-04-14
 * 
 * @copyright Copyright (c) 2023
 * 
 */

#include <conio.h>
#include <ctype.h>
#include <string.h>


void main() {
    const char* screen = (char*)0x0400;
    const char* bottom = (char*)0x0400 + 40*12;

    // Show mixed chars on screen
    *((char*)0xd018) = 0x17;

    // Clear screen
    clrscr();

    for(char i:0..255) {
        memset_fast(screen, i, 256); // 256 will be truncated to 0, which will copy 256 bytes!
        memcpy_fast(bottom, screen, 256);
    }

    // There is a longer term plan to allow these calls to be written as "inline" ...
    // Which would give the programmer the means to decide how the code should
    // be generated for these copy functions.
    // inline memset_fast(screen, i, 256); // 256 will be truncated to 0, which will copy 256 bytes!
    // inline memcpy_fast(bottom, screen, 256);

}