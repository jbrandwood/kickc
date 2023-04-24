
/**
 * @file cx16.c
 * @author Jesper Gravgaard / Sven Van de Velde
 * @brief Contains functions to control the features of the Commander X16.
 * Commander X16 Functions.
 * https://www.commanderx16.com/forum/index.php?/about-faq/
 * https://github.com/commanderx16/x16-docs/blob/master/Commander%20X16%20Programmer's%20Reference%20Guide.md
 * @version 0.1
 * @date 2021-06-13
 *
 * @copyright Copyright (c) 2021
 *
 */

#ifndef __CX16__
#error "Target platform must be cx16"
#endif

#include <cx16.h>
#include <kernal.h>
#include <stdlib.h>
#include <cx16-vera.h>

// Initializer for X16 Commander interrupt vector
#pragma constructor_for(cx16_init, cx16_kernal_irq)

__mem __export word isr_vsync = 0x0314;

void cx16_init()
{
    isr_vsync = *(word *)0x0314;
}

void cx16_kernal_irq(IRQ_TYPE irq)
{
    *KERNEL_IRQ = irq;
}

/**
 * @brief Push the old bank on the stack and set the active bank of banked ram on the X16.
 * Banked ram is the memory location between 0xA000 and 0xBFFF.
 *
 * @param bank Switch to this bank.
 */
inline void bank_push_set_bram(bram_bank_t bank)
{
    asm {
        lda $00
        pha
    }
    BRAM = bank;
}

/**
 * @brief Set the active bank of banked ram on the X16.
 * Banked ram is the memory location between 0xA000 and 0xBFFF.
 *
 * @param bank Switch to this bank.
 */
inline void bank_set_bram(bram_bank_t bank)
{
    BRAM = bank;
}

/**
 * @brief Set the active bank of banked ram on the X16.
 * Banked ram is the memory location between 0xA000 and 0xBFFF.
 * The old bank is pushed on the stack, and must be retrieved with bank_pop_bram!!!
 *
 * @param bank Switch to this bank.
 */
inline void bank_push_bram()
{
    asm {
        lda $00
        pha
    }
}

/**
 * @brief Get the active bank of banked ram on the X16.
 * Banked ram is the memory location between 0xA000 and 0xBFFF.
 *
 * @return unsigned char The current active bank.
 */
inline unsigned char bank_get_bram()
{
    return BRAM;
}

/**
 * @brief Get the old bank of banked ram on the X16 from the stack.
 * Banked ram is the memory location between 0xA000 and 0xBFFF.
 * The old bank was set with bank_push_bram()!!!
 */
inline void bank_pull_bram()
{
    asm {
        pla
        sta $00
    }
}

/**
 * @brief Set the active banked rom on the X16.
 *
 * There are several banked roms available between 0xC000 and 0xFFFF.
 *
 * Bank	Name	Description
 * 0	KERNAL	character sets (uploaded into VRAM), MONITOR, KERNAL
 * 1	KEYBD	Keyboard layout tables
 * 2	CBDOS	The computer-based CBM-DOS for FAT32 SD cards
 * 3	GEOS	GEOS KERNAL
 * 4	BASIC	BASIC interpreter
 * 5	MONITOR	Machine Language Monitor
 *
 * Detailed documentation in the CX16 programmers reference:
 * https://github.com/commanderx16/x16-docs/blob/master/Commander%20X16%20Programmer's%20Reference%20Guide.md
 *
 * Note: This method will change when R39 is released,
 * as the bank is modified using zero page 0x01, instead of the VIA.
 *
 * @param bank Switch to this bank.
 */
inline void bank_set_brom(brom_bank_t bank)
{
    BROM = bank;
}

/**
 * @brief Get the active banked rom on the X16.
 * There are several banked roms available between 0xC000 and 0xFFFF.
 *
 * Bank	Name	Description
 * 0	KERNAL	character sets (uploaded into VRAM), MONITOR, KERNAL
 * 1	KEYBD	Keyboard layout tables
 * 2	CBDOS	The computer-based CBM-DOS for FAT32 SD cards
 * 3	GEOS	GEOS KERNAL
 * 4	BASIC	BASIC interpreter
 * 5	MONITOR	Machine Language Monitor
 *
 * Detailed documentation in the CX16 programmers reference:
 * https://github.com/commanderx16/x16-docs/blob/master/Commander%20X16%20Programmer's%20Reference%20Guide.md
 *
 * Note: This method will change when R39 is released,
 * as the bank is modified using zero page 0x01, instead of the VIA.
 *
 * @return unsigned char The current active bank.
 */
brom_bank_t bank_get_brom()
{
#ifdef X16_R38
    return VIA1->PORT_B;
#else
    return BROM;
#endif
}

/**
 * Call a far routine in a bank.
 *
 */
void call__far(bram_bank_t bank_func, bram_ptr_t ptr_func)
{

}

// Increase a cx16 banked pointer, so that the bank setting evolves with the increment.
/**
 * @brief Increase a banked pointer, located between 0xA000 and 0xBFFF,
 * so that the bank setting evolves with the increment, increasing the bank and restaring at 0xA000
 * once the 0xBFFF boundary has been reached.
 *
 * @param bank Bank on which the pointer is mapped.
 * @param sptr The pointer to increment.
 * @param inc The increment.
 * @return bram_ptr_t The new calculated pointer.
 */
bram_ptr_t bank_bram_ptr_inc(char bank, char *sptr, unsigned int inc)
{

    char banks = BYTE1(inc) >> 5; // This returns the number of banks the increment will cover.

    sptr -= 0xA000;
    unsigned int rptr = ((unsigned int)sptr + (inc & 0x1FFF));
    char diff = BYTE1(rptr) >> 5; // if the inc crosses the 0x2000 boundary, then this bit will be set.

    bank = bank + banks + diff;
    bank_set_bram(bank);

    rptr = (rptr & 0x1FFF) + 0xA000;

    return (bram_ptr_t)rptr;
}

/**
 * @brief Put a single byte into VRAM.
 * Uses VERA DATA0.
 *
 * @param vbank Which 64K VRAM bank to put data into (0/1).
 * @param vaddr The address in VRAM.
 * @param data The data to put into VRAM.
 */
void vpoke(vram_bank_t vbank, vram_offset_t vaddr, char data)
{

    *VERA_CTRL &= ~VERA_ADDRSEL;
    *VERA_ADDRX_L = BYTE0(vaddr);
    *VERA_ADDRX_M = BYTE1(vaddr);
    *VERA_ADDRX_H = VERA_INC_0 | vbank;

    *VERA_DATA0 = data;
}

/**
 * @brief Read a single byte from VRAM.
 * Uses VERA DATA0.
 *
 * @param vbank Which 64K VRAM bank to put data into (0/1).
 * @param vaddr The address in VRAM.
 * @return char The data to put into VRAM.
 */
char vpeek(vram_bank_t vbank, vram_offset_t vaddr)
{

    *VERA_CTRL &= ~VERA_ADDRSEL;
    *VERA_ADDRX_L = BYTE0(vaddr);
    *VERA_ADDRX_M = BYTE1(vaddr);
    *VERA_ADDRX_H = VERA_INC_0 | vbank;
    // Get data
    return *VERA_DATA0;
}

/**
 * @brief Copy block of memory from ram to vram.
 * Copies num bytes from the ram source pointer to the vram bank/offset.
 *
 * @param dbank_vram Destination vram bank.
 * @param doffset_vram The destination vram offset, 0x0000 till 0xFFFF)
 * @param sptr_ram Source pointer in ram.
 * @param num Amount of bytes to copy.
 */
void memcpy_vram_ram(vram_bank_t dbank_vram, vram_offset_t doffset_vram, ram_ptr_t sptr_ram, unsigned int num)
{

    *VERA_CTRL &= ~VERA_ADDRSEL;
    *VERA_ADDRX_L = BYTE0(doffset_vram);
    *VERA_ADDRX_M = BYTE1(doffset_vram);
    *VERA_ADDRX_H = dbank_vram | VERA_INC_1;

    // Transfer the data
    unsigned char *end = (unsigned char *)sptr_ram + num;
    for (char *s = sptr_ram; s != end; s++)
        *VERA_DATA0 = *s;
}

/**
 * @brief Copy block of memory from vram to ram.
 * Copies num bytes from the source vram bank/offset to the ram destination pointer.
 *
 * @param dptr Destination vram pointer.
 * @param sbank_vram Source vram bank.
 * @param soffset_vram Source vram offset.
 * @param num Amount of bytes to copy.
 */
void memcpy_ram_vram(ram_ptr_t dptr, vram_bank_t sbank_vram, vram_offset_t soffset_vram, unsigned int num)
{

    *VERA_CTRL &= ~VERA_ADDRSEL;
    *VERA_ADDRX_L = BYTE0(soffset_vram);
    *VERA_ADDRX_M = BYTE1(soffset_vram);
    *VERA_ADDRX_H = sbank_vram | VERA_INC_1;

    // Get the data
    unsigned char *end = (unsigned char *)dptr + num;
    for (unsigned char *s = dptr; s != end; s++)
        *s = *VERA_DATA0;
}

/**
 * @brief Copy block of memory from vram to vram with specified vera increments/decrements.
 * Copies num bytes from the source vram bank/offset to the destination vram bank/offset, with specified increment/decrement.
 *
 * @param dbank_vram Destination vram bank.
 * @param doffset_vram Destination vram offset.
 * @param dinc Destination vram increment/decrement.
 * @param sbank_vram Source vram bank.
 * @param soffset_vram Source vram offset.
 * @param sinc Source vram increment/decrement.
 * @param num Amount of bytes to copy.
 */
void memcpy_vram_vram_inc(vram_bank_t dbank_vram, vram_offset_t doffset_vram, unsigned char dinc, vram_bank_t sbank_vram, vram_offset_t soffset_vram, unsigned char sinc, unsigned int num)
{

    // DATA0
    *VERA_CTRL &= ~VERA_ADDRSEL;
    *VERA_ADDRX_L = BYTE0(soffset_vram);
    *VERA_ADDRX_M = BYTE1(soffset_vram);
    *VERA_ADDRX_H = sbank_vram | sinc;

    // DATA1
    *VERA_CTRL |= VERA_ADDRSEL;
    *VERA_ADDRX_L = BYTE0(doffset_vram);
    *VERA_ADDRX_M = BYTE1(doffset_vram);
    *VERA_ADDRX_H = dbank_vram | dinc;

    // Transfer the data
    for (unsigned int i = 0; i < num; i++)
    {
        *VERA_DATA1 = *VERA_DATA0;
    }
}


/**
 * @brief Fast initialization of an area pointed by a destination memory address to one value c.
 * Since the amount of bytes to be initialized is a byte long, it can be executed very fast.
 * The parameter num can have a value 0, which in case is equal to 256,
 * which allows 256 bytes to be copied using one single byte counter!
 * Depending on the optimization of the compiler, this implementation can
 * result in very fast code, but it should be inlined!
 * 
 * @param destination The destination memory address as the start of the memory area.
 * @param c The byte value initializing the memory area..
 * @param num The amount of bytes to be copied. A value of 0 will set an area of 256 bytes!!!
 * @return void* The resulting destination memory address.

/**
 * @brief Fast and inline copy of memory from bram to vram.
 * Copies num bytes (max 256) from the source bram bank/pointer to the destination vram bank/offset.
 * Since the amount of bytes to be initialized is a byte long, it can be executed very fast.
 * The parameter num can have a value 0, which in case is equal to 256,
 * which allows 256 bytes to be copied using one single byte counter!
 * Depending on the optimization of the compiler, this implementation can
 * result in very fast code, but it should be inlined!
 * NOTE! sptr_bram + amount of bytes to be copied must be between BRAM page boundaries!
 *
 * @param dbank_vram Destination vram bank between 0 and 1.
 * @param doffset_vram Destination vram offset between 0x0000 and 0xFFFF.
 * @param sbank_vram Source bram bank between 0 and 255 (Depending on banked ram availability, maxima can be 63, 127, 191 or 255).
 * @param sptr_bram Source bram pointer between 0xA000 and 0xBFFF. 
 * @param num Amount of bytes to copy.
 */
inline void memcpy_vram_bram_fast(vram_bank_t dbank_vram, vram_offset_t doffset_vram, bram_bank_t sbank_bram, bram_ptr_t sptr_bram, unsigned char num)
{
    bank_push_set_bram(sbank_bram);

    *VERA_CTRL &= ~VERA_ADDRSEL;
    *VERA_ADDRX_L = BYTE0(doffset_vram);
    *VERA_ADDRX_M = BYTE1(doffset_vram);
    *VERA_ADDRX_H = dbank_vram | VERA_INC_1;

    char add = 0;
    do {
        *VERA_DATA0 = sptr_bram[add];
        add++;
        num--;
    } while(num);

    bank_pull_bram();
}



/**
 * @brief Copy block of memory from bram to vram.
 * Copies num bytes from the source bram bank/pointer to the destination vram bank/offset.
 *
 * @param dbank_vram Destination vram bank between 0 and 1.
 * @param doffset_vram Destination vram offset between 0x0000 and 0xFFFF.
 * @param sbank_vram Source bram bank between 0 and 255 (Depending on banked ram availability, maxima can be 63, 127, 191 or 255).
 * @param sptr_bram Source bram pointer between 0xA000 and 0xBFFF.
 * @param num Amount of bytes to copy.
 */
void memcpy_vram_bram(vram_bank_t dbank_vram, vram_offset_t doffset_vram, bram_bank_t sbank_bram, bram_ptr_t sptr_bram, unsigned int num)
{

    byte bank = bank_get_bram();
    bank_set_bram(sbank_bram);

    *VERA_CTRL &= ~VERA_ADDRSEL;
    *VERA_ADDRX_L = BYTE0(doffset_vram);
    *VERA_ADDRX_M = BYTE1(doffset_vram);
    *VERA_ADDRX_H = dbank_vram | VERA_INC_1;


    // byte* ptr = (byte*)sptr_bram;
    // for(unsigned int i=0; i<num; i++) {
    //     if(ptr == 0xC000) {
    //         sbank_bram++;
    //         bank_set_bram(sbank_bram); // select the bank
    //         ptr = (byte*)0xA000;
    //     }
    //     *VERA_DATA0 = *ptr;
    //     ptr++;
    // }

    const bram_ptr_t pagesize = (bram_ptr_t)0x100;
    const bram_ptr_t pagemask = (bram_ptr_t)0xFF00;

    // Set the page boundary.
    bram_ptr_t ptr = (bram_ptr_t)((unsigned int)sptr_bram & (unsigned int)pagemask);
    unsigned char pos = BYTE0(sptr_bram);
    unsigned char len = -BYTE0(sptr_bram);

    if (num <= (unsigned int)len)
        len = BYTE0(num);
    if (len)
    {
        asm {
            ldy pos
            ldx len
            inx
            lda ptr
            sta !ptr+ +1
            lda ptr+1
            sta !ptr+ +2
            !ptr: lda $ffff,y
            sta VERA_DATA0
            iny
            dex
            bne !ptr-
        }
        // do {
        //     // *VERA_DATA0 = ptr[y];
        //     asm {
        //         !ptr: lda $ffff,y
        //         sta VERA_DATA0
        //     }
        //     y++;
        //     // ptr++;
        // } while(y<x);
        ptr += 0x100;
        num -= len;
    }

    // Adjust the ptr and check if we are at page boundary.
    if (BYTE1(ptr) == 0xC0)
    {
        ptr = (unsigned char *)0xA000;
        bank_set_bram(++sbank_bram); // select the bank
    }

    // Copy the paged part for long lasting copies.
    if (BYTE1(num))
    {
        do
        {
            // register unsigned char y = 0;
            asm {
                ldy #0
                lda ptr
                sta !ptr+ +1
                lda ptr+1
                sta !ptr+ +2
                !:
                !ptr: lda $ffff,y
                sta VERA_DATA0
                iny
                bne !-
            }
            // do {
            //     // *VERA_DATA0 = ptr[y];
            //     asm {
            //         !ptr: lda $ffff,y
            //         sta VERA_DATA0
            //     }
            //     y++;
            //     // ptr++;
            // } while(y);
            ptr += 0x100;
            if (BYTE1(ptr) == 0xC0)
            {
                ptr = (unsigned char *)0xA000;
                bank_set_bram(++sbank_bram); // select the bank
            }
            num -= 256;
        } while (BYTE1(num));
    }

    // Now copy the remainder part.
    if (num)
    {
        asm {
            ldy #0
            ldx num
            inx
            lda ptr
            sta !ptr+ +1
            lda ptr+1
            sta !ptr+ +2
            !ptr: lda $ffff,y
            sta VERA_DATA0
            iny
            dex
            bne !ptr-
        }
        // do {
        //     // *VERA_DATA0 = ptr[y];
        //     asm {
        //         !ptr: lda $ffff,y
        //         sta VERA_DATA0
        //     }
        //     y++;
        // } while(y<x);
    }


    // unsigned char size_low = BYTE0(num);
    // unsigned char size_high = BYTE1(num);

    // unsigned char i=0;
    // for(char o=0; o<size_high; o++) {
    //     i=0;
    //     do {
    //         *VERA_DATA0 = *(sptr_bram+i);
    //         i--;
    //     } while(i);
    //     sptr_bram+=256;
    // }

    // i=size_low;
    // do {
    //     *VERA_DATA0 = *(sptr_bram+i);
    //     i--;
    // } while(i);

    bank_set_bram(bank);
}

/**
 * @brief Copy a block of memory in VRAM from a source to a target destination.
 * This function is designed to copy maximum 255 bytes of memory in one step.
 * If more than 255 bytes need to be copied, use the memcpy_vram_vram function.
 *
 * @see memcpy_vram_vram
 *
 * @param dbank_vram Bank of the destination location in vram.
 * @param doffset_vram Offset of the destination location in vram.
 * @param sbank_vram Bank of the source location in vram.
 * @param soffset_vram Offset of the source location in vram.
 * @param num16 Specified the amount of bytes to be copied.
 */
void memcpy8_vram_vram(vram_bank_t dbank_vram, vram_offset_t doffset_vram, vram_bank_t sbank_vram, vram_offset_t soffset_vram, unsigned char num8)
{

    *VERA_CTRL &= ~VERA_ADDRSEL;
    *VERA_ADDRX_L = BYTE0(soffset_vram);
    *VERA_ADDRX_M = BYTE1(soffset_vram);
    *VERA_ADDRX_H = sbank_vram | VERA_INC_1;

    *VERA_CTRL |= VERA_ADDRSEL;
    *VERA_ADDRX_L = BYTE0(doffset_vram);
    *VERA_ADDRX_M = BYTE1(doffset_vram);
    *VERA_ADDRX_H = dbank_vram | VERA_INC_1;

    // the size is only a byte, this is the fastest loop!
    while (num8--)
    {
        *VERA_DATA1 = *VERA_DATA0;
    }
}

/**
 * @brief Copy a block of memory in VRAM from a source to a target destination.
 * This function is designed to copy more than 255 bytes of memory in one step.
 * If less than 255 bytes need to be copied, use the memcpy8_vram_vram function.
 *
 * @see memcpy8_vram_vram
 *
 * @param dbank_vram Bank of the destination location in vram.
 * @param doffset_vram Offset of the destination location in vram.
 * @param sbank_vram Bank of the source location in vram.
 * @param soffset_vram Offset of the source location in vram.
 * @param num16 Specified the amount of bytes to be copied.
 */
void memcpy_vram_vram(vram_bank_t dbank_vram, vram_offset_t doffset_vram, vram_bank_t sbank_vram, vram_offset_t soffset_vram, unsigned int num16)
{

    *VERA_CTRL &= ~VERA_ADDRSEL;
    *VERA_ADDRX_L = BYTE0(soffset_vram);
    *VERA_ADDRX_M = BYTE1(soffset_vram);
    *VERA_ADDRX_H = sbank_vram | VERA_INC_1;

    *VERA_CTRL |= VERA_ADDRSEL;
    *VERA_ADDRX_L = BYTE0(doffset_vram);
    *VERA_ADDRX_M = BYTE1(doffset_vram);
    *VERA_ADDRX_H = dbank_vram | VERA_INC_1;

    // the size is a word.
    while (num16--)
    {
        *VERA_DATA1 = *VERA_DATA0;
    }
}

/**
 * @brief Set block of memory in vram to a value.
 * Sets num bytes to the destination vram bank/offset to the specified data value.
 *
 * @param dbank_vram Destination vram bank between 0 and 1.
 * @param doffset_vram Destination vram offset between 0x0000 and 0xFFFF.
 * @param data The data to be set in char value.
 * @param num Amount of bytes to set.
 */
void memset_vram(vram_bank_t dbank_vram, vram_offset_t doffset_vram, unsigned char data, unsigned int num)
{

    *VERA_CTRL &= ~VERA_ADDRSEL;
    *VERA_ADDRX_L = BYTE0(doffset_vram);
    *VERA_ADDRX_M = BYTE1(doffset_vram);
    *VERA_ADDRX_H = dbank_vram | VERA_INC_1;

    // Transfer the data
    for (word i = 0; i < num; i++)
    {
        *VERA_DATA0 = data;
    }
}
