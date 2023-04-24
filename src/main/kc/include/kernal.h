/**
 * @file kernal.h
 * @author your name (you@domain.com)
 * @brief Most common CBM Kernal calls with it's dialects in the different CBM kernal family platforms.
 * Please refer to http://sta.c64.org/cbm64krnfunc.html for the list of standard CBM C64 kernal functions.
 *
 * @version 1.0
 * @date 2023-03-22
 *
 * @copyright Copyright (c) 2023
 *
 */

const unsigned int CBM_SETNAM = 0xFFBD; ///< Set the name of a file.
const unsigned int CBM_SETLFS = 0xFFBA; ///< Set the logical file.
const unsigned int CBM_OPEN   = 0xFFC0; ///< Open the file for the current logical file.
const unsigned int CBM_CHKIN  = 0xFFC6; ///< Set the logical channel for input.
const unsigned int CBM_READST = 0xFFB7; ///< Check I/O errors.
const unsigned int CBM_CHRIN  = 0xFFCF; ///< Read a character from the current channel for input.
const unsigned int CBM_GETIN  = 0xFFE4; ///< Scan a character from the keyboard.
const unsigned int CBM_CLOSE  = 0xFFC3; ///< Close a logical file.
const unsigned int CBM_CLRCHN = 0xFFCC; ///< Close all logical files.
const unsigned int CBM_LOAD   = 0xFFD5; ///< Load a logical file.
const unsigned int CBM_PLOT   = 0xFFF0; ///< Set or get current cursor location.
const unsigned int CBM_CHROUT = 0xFFD2; ///< Output a character.


/* inline */ void cbm_k_setlfs(char channel, char device, char command);
/* inline */ void cbm_k_setnam(char* filename);
/* inline */ void cbm_k_open();
/* inline */ void cbm_k_close(char channel);
/* inline */ unsigned char cbm_k_chkin(char channel);
/* inline */ unsigned char cbm_k_chrin();
/* inline */ void cbm_k_clrchn();
/* inline */ unsigned char cbm_k_getin();
/* inline */ unsigned char cbm_k_readst();
/* inline */ unsigned char cbm_k_load(char* address, char verify);
/* inline */ unsigned int cbm_k_plot_get();
/* inline */ void cbm_k_plot_set(unsigned char x, unsigned char y);
/* inline */ void cbm_k_chrout(char c);




#if defined(__CX16__)
#include <cx16-kernal.h>
#endif
