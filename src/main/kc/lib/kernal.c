/**
 * @file kernal.h
 * @author Sven Van de Velde (sven.van.de.velde@telenet.com)
 * @brief Most common CBM Kernal calls with it's dialects in the different CBM kernal family platforms.
 * Please refer to http://sta.c64.org/cbm64krnfunc.html for the list of standard CBM C64 kernal functions.
 *
 * @version 1.0
 * @date 2023-03-22
 *
 * @copyright Copyright (c) 2023
 *
 */


/**
 * @brief Sets the logical file channel.
 *
 * @param channel the logical file number.
 * @param device the device number.
 * @param command the command.
 */
void cbm_k_setlfs(char channel, char device, char command)
{
    {asm {
        ldx device
        lda channel
        ldy command
        jsr CBM_SETLFS
    }}
}

/**
 * @brief Sets the name of the file before opening.
 *
 * @param filename The name of the file.
 */
inline void cbm_k_setnam(char* filename)
{
    char filename_len = (char)strlen(filename);
    {asm {
        lda filename_len
        ldx filename
        ldy filename+1
        jsr CBM_SETNAM
    }}
}

/**
 * @brief Open a logical file.
 *
 * @return char The status.
 */
inline void cbm_k_open()
{
    {asm {
        //.byte $db
        jsr CBM_OPEN
    }}
}

/**
 * @brief Close a logical file.
 *
 * @param channel The channel to close.
 * @return char Status.
 */
inline void cbm_k_close(char channel)
{

    {asm {
      //   .byte $db
        lda channel
        jsr CBM_CLOSE
    }}
}


/**
 * @brief Open a channel for input.
 *
 * @param channel
 * @return char
 */
inline unsigned char cbm_k_chkin(char channel)
{
    char status;
    {asm {
        ldx channel
        jsr CBM_CHKIN
        sta status
    }}
    return status;
}

/**
 * @brief Scan a character from keyboard without pressing enter.
 * 
 * @return char The character read.
 */
unsigned char cbm_k_getin() 
{
    __mem unsigned char ch;
    {asm {
        jsr CBM_GETIN
        sta ch
    }}
    return ch;
}

/**
 * @brief Clear all I/O channels.
 *
 */
inline void cbm_k_clrchn() {
    {asm {
        jsr CBM_CLRCHN
    }}
}


/**
 * @brief Get a character from the input channel.
 *
 * @return char
 */
inline unsigned char cbm_k_chrin()
{
    char ch;
    {asm {
        jsr CBM_CHRIN
        sta ch
    }}
    return ch;
}

/**
 * @brief Read the status of the I/O.
 *
 * @return char Status.
 */
inline unsigned char cbm_k_readst()
{
    char status;
    {asm {
        jsr CBM_READST
        sta status
    }}
    return status;
}


/**
 * @brief Load into RAM from a device.
 *
 * @param address Target address in RAM.
 * @param verify
 * @return char Status
 */
unsigned char cbm_k_load(char* address, char verify)
{
    __mem unsigned char status;
    {asm {
        //LOAD. Load or verify file. (Must call SETLFS and SETNAM beforehands.)
        // Input: A: 0 = Load, 1-255 = Verify; X/Y = Load address (if secondary address = 0).
        // Output: Carry: 0 = No errors, 1 = Error; A = KERNAL error code (if Carry = 1); X/Y = Address of last byte loaded/verified (if Carry = 0).
        .byte $db
        ldx address
        ldy address+1
        lda verify
        jsr $ffd5
        bcs !error+
        lda #$ff
        !error:
        sta status
    }}
    return status;
}
/**
 * @brief Get current x and y cursor position.
 * @return An unsigned int where the hi byte is the x coordinate and the low byte is the y coordinate of the screen position.
 */
unsigned int cbm_k_plot_get()
{
    __mem unsigned char x;
    __mem unsigned char y;
    {kickasm(uses x, uses y, uses CBM_PLOT) {{
        sec
        jsr CBM_PLOT
        stx y
        sty x
    }}}
    return MAKEWORD(x,y);
}

/**
 * @brief Set current cursor position using x and y coordinates.
 *
 */
void cbm_k_plot_set(unsigned char x, unsigned char y)
{
    {kickasm(uses x, uses y, uses CBM_PLOT) {{
        ldx y
        ldy x
        clc
        jsr CBM_PLOT
    }}}
}


/**
 * @brief Output a character to the defined channel.
 *
 */
inline void cbm_k_chrout(char ch)
{
    {asm {
        lda ch
        jsr CBM_CHROUT
    }}
}
