/**
 * @file cx16.h
 * @author Sven Van de Velde
 * @brief Type definitions for the CX16 platform.
 * @version 0.2
 * @date 2022-10-13
 *
 * @copyright Copyright (c) 2022
 *
 */

#ifndef __CX16__
#error "Target platform must be cx16"
#endif


typedef void (*IRQ_TYPE)(void);                         ///< Pointer to interrupt function.

typedef unsigned char       bram_bank_t;                ///< Represents a bank in banked ram.
typedef unsigned char       brom_bank_t;                ///< Represents a bank in banked rom.
typedef unsigned char       vram_bank_t;                ///< Represents a bank in vera ram.
typedef unsigned char*      ram_ptr_t;                  ///< Expresses a pointer to a location in main ram of the CX16..
typedef unsigned char*      bram_ptr_t;                 ///< Expresses a pointer location in banked ram of the CX16, excluding any bank information!
typedef unsigned char*      brom_ptr_t;                 ///< Expresses a pointer location in banked rom of the CX16, excluding any bank information!
typedef unsigned int        vram_offset_t;              ///< Expresses an offset location in vera ram, excluding any bank information!

