/**
 * @file cx16-kernal.h
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief CBM kernal API dialect and additions to the Commander X16 platform.
 * Please refer to https://github.com/commanderx16/x16-docs/blob/master/X16%20Reference%20-%2004%20-%20KERNAL.md for the detailed list
 * of APIs backward compatible with the C64.
 *
 * @version 1.0
 * @date 2023-03-22
 *
 * @copyright Copyright (c) 2023
 *
 */

const unsigned int CX16_SCREEN_SET_CHARSET = 0xFF62;  ///< CX16 Set character set.
const unsigned int CX16_MACPTR = 0xFF44; ///< CX16 Faster loading from SDCARD.


unsigned int cx16_k_macptr(unsigned char bytes, void* buffer);
void cx16_k_screen_set_charset(char charset, char *offset);

