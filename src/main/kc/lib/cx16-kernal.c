/**
 * @file cx16-kernal.c
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief 
 * Please refer to http://sta.c64.org/cbm64krnfunc.html for the list of standard CBM C64 kernal functions.
 * Please refer to https://github.com/commanderx16/x16-docs/blob/master/Commander%20X16%20Programmer's%20Reference%20Guide.md for the detailed list
 * of APIs backward compatible with the C64.

 * @version 0.1
 * @date 2022-01-29
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <cx16.h>
#include <cx16-kernal.h>


/**
 * @brief Read a number of bytes from the sdcard using kernal macptr call.
 * BRAM bank needs to be set properly before the load between adressed A000 and BFFF.
 *
 * @return x the size of bytes read
 * @return y the size of bytes read
 * @return if carry is set there is an error
 */
unsigned int cx16_k_macptr(unsigned char bytes, void* buffer)
{
    unsigned int bytes_read;
    {asm {
        lda bytes
        ldx buffer
        ldy buffer+1

        clc  // needed from R42 of the CX16 commander rom to ensure MACPTR is progressing the read address.
        // .byte $db
        jsr CX16_MACPTR
        stx bytes_read
        sty bytes_read+1
        bcc !+
        lda #$FF
        sta bytes_read
        sta bytes_read+1
        !:
    }}
    return bytes_read;
}



/**
 * @brief Sets the [character set](https://github.com/commanderx16/x16-docs/blob/master/X16%20Reference%20-%2004%20-%20KERNAL.md#function-name-screen_set_charset).
 * 
 * @param charset The code of the charset to copy.
 * @param offset The offset of the character set in ram.
 */
inline void cx16_k_screen_set_charset(char charset, char *offset) {

    
    {asm {
        lda charset
        ldx <offset
        ldy >offset
        jsr CX16_SCREEN_SET_CHARSET
    }}
}
