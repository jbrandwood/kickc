// MEGA65 DMA test using 4MB version
// Appendix J in https://mega.scryptos.com/sharefolder-link/MEGA/MEGA65+filehost/Docs/MEGA65-Book_draft.pdf
/// @file
/// Functions for using the F018 DMA for very fast copying or filling of memory
/// @file
/// MEGA65 Registers and Constants
/// @file
/// The MOS 6526 Complex Interface Adapter (CIA)
///
/// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
.cpu _45gs02
  // MEGA65 platform PRG executable starting in MEGA65 mode.
.file [name="dma-test3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$2001]
.segmentdef Code [start=$2017]
.segmentdef Data [startAfter="Code"]
.segment Basic
.byte $0a, $20, $0a, $00, $fe, $02, $20, $30, $00       // 10 BANK 0
.byte $15, $20, $14, $00, $9e, $20                      // 20 SYS 
.text toIntString(main)                                   //         NNNN
.byte $00, $00, $00                                     // 
  /// DMA command copy
  .const DMA_COMMAND_COPY = 0
  .const OFFSET_STRUCT_F018_DMAGIC_EN018B = 3
  .const OFFSET_STRUCT_DMA_LIST_F018B_COUNT = 1
  .const OFFSET_STRUCT_DMA_LIST_F018B_SRC = 3
  .const OFFSET_STRUCT_DMA_LIST_F018B_DEST = 6
  .const OFFSET_STRUCT_F018_DMAGIC_ADDRMB = 4
  .const OFFSET_STRUCT_F018_DMAGIC_ADDRBANK = 2
  .const OFFSET_STRUCT_F018_DMAGIC_ADDRMSB = 1
  .const OFFSET_STRUCT_DMA_LIST_F018B_SRC_BANK = 5
  .const OFFSET_STRUCT_DMA_LIST_F018B_DEST_BANK = 8
  /// DMAgic F018 Controller
  .label DMA = $d700
  /// Default address of screen character matrix
  .label DEFAULT_SCREEN = $800
.segment Code
main: {
    // memoryRemap(0,0,0)
    // Map memory to BANK 0 : 0x00XXXX - giving access to I/O
    jsr memoryRemap
    // memcpy_dma4(0, DEFAULT_SCREEN, 0, DEFAULT_SCREEN+80, 24*80)
    // Move screen up using DMA
    jsr memcpy_dma4
    // }
    rts
}
// Remap some of the eight 8K memory blocks in the 64K address space of the 6502 to point somewhere else in the first 1MB memory space of the MEGA65.
// After the remapping the CPU will access the mapped memory whenever it uses instructions that access a remapped block.
// See section 2.3.4 in http://www.zimmers.net/cbmpics/cbm/c65/c65manual.txt for a description of the CPU memory remapper of the C65.
// remapBlocks: Indicates which 8K blocks of the 6502 address space to remap. Each bit represents one 8K block
// - bit 0  Memory block $0000-$1fff. Use constant MEMORYBLOCK_0000.
// - bit 1  Memory block $2000-$3fff. Use constant MEMORYBLOCK_2000.
// - bit 2  Memory block $4000-$5fff. Use constant MEMORYBLOCK_4000.
// - bit 3  Memory block $6000-$7fff. Use constant MEMORYBLOCK_6000.
// - bit 4  Memory block $8000-$9fff. Use constant MEMORYBLOCK_8000.
// - bit 5  Memory block $a000-$bfff. Use constant MEMORYBLOCK_A000.
// - bit 6  Memory block $c000-$dfff. Use constant MEMORYBLOCK_C000.
// - bit 7  Memory block $e000-$ffff. Use constant MEMORYBLOCK_E000.
// lowerPageOffset: Offset that will be added to any remapped blocks in the lower 32K of memory (block 0-3).
// The offset is a page offset (meaning it is multiplied by 0x100). Only the lower 12bits of the passed value is used.
// - If block 0 ($0000-$1fff) is remapped it will point to lowerPageOffset*$100.
// - If block 1 ($2000-$3fff) is remapped it will point to lowerPageOffset*$100 + $2000.
// - If block 2 ($4000-$5fff) is remapped it will point to lowerPageOffset*$100 + $4000.
// - If block 3 ($6000-$7fff) is remapped it will point to lowerPageOffset*$100 + $6000.
// upperPageOffset: Offset that will be added to any remapped blocks in the upper 32K of memory (block 4-7).
// The offset is a page offset (meaning it is multiplied by 0x100). Only the lower 12bits of the passed value is used.
// - If block 4 ($8000-$9fff) is remapped it will point to upperPageOffset*$100 + $8000
// - If block 5 ($a000-$bfff) is remapped it will point to upperPageOffset*$100 + $a000.
// - If block 6 ($c000-$dfff) is remapped it will point to upperPageOffset*$100 + $c000.
// - If block 7 ($e000-$ffff) is remapped it will point to upperPageOffset*$100 + $e000.
// void memoryRemap(char remapBlocks, unsigned int lowerPageOffset, unsigned int upperPageOffset)
memoryRemap: {
    .label aVal = 5
    .label xVal = 4
    .label yVal = 3
    .label zVal = 2
    // char aVal = BYTE0(lowerPageOffset)
    // lower blocks offset page low
    ldz #0
    stz.z aVal
    // char xVal = (remapBlocks << 4)   | (BYTE1(lowerPageOffset) & 0xf)
    // lower blocks to map + lower blocks offset high nibble
    stz.z xVal
    // char yVal = BYTE0(upperPageOffset)
    // upper blocks offset page
    stz.z yVal
    // char zVal = (remapBlocks & 0xf0) | (BYTE1(upperPageOffset) & 0xf)
    // upper blocks to map + upper blocks offset page high nibble
    stz.z zVal
    // asm
    lda aVal
    ldx xVal
    ldy yVal
    map
    eom
    // }
    rts
}
// Copy a memory block anywhere in first 4MB memory space using MEGA65 DMagic DMA
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// - dest_bank The 64KB bank for the destination (0-127)
// - dest The destination address (within the MB and bank)
// - src_bank The 64KB bank for the source (0-127)
// - src The source address (within the MB and bank)
// - num The number of bytes to copy
// void memcpy_dma4(char dest_bank, void *dest, char src_bank, void *src, unsigned int num)
memcpy_dma4: {
    .const dest_bank = 0
    .const src_bank = 0
    .const num = $18*$50
    .label dest = DEFAULT_SCREEN
    .label src = DEFAULT_SCREEN+$50
    // char dmaMode = DMA->EN018B
    // Remember current F018 A/B mode
    ldx DMA+OFFSET_STRUCT_F018_DMAGIC_EN018B
    // memcpy_dma_command4.count = num
    // Set up command
    lda #<num
    sta memcpy_dma_command4+OFFSET_STRUCT_DMA_LIST_F018B_COUNT
    lda #>num
    sta memcpy_dma_command4+OFFSET_STRUCT_DMA_LIST_F018B_COUNT+1
    // memcpy_dma_command4.src_bank = src_bank
    ldz #src_bank
    stz memcpy_dma_command4+OFFSET_STRUCT_DMA_LIST_F018B_SRC_BANK
    // memcpy_dma_command4.src = src
    lda #<src
    sta memcpy_dma_command4+OFFSET_STRUCT_DMA_LIST_F018B_SRC
    lda #>src
    sta memcpy_dma_command4+OFFSET_STRUCT_DMA_LIST_F018B_SRC+1
    // memcpy_dma_command4.dest_bank = dest_bank
    ldz #dest_bank
    stz memcpy_dma_command4+OFFSET_STRUCT_DMA_LIST_F018B_DEST_BANK
    // memcpy_dma_command4.dest = dest
    lda #<dest
    sta memcpy_dma_command4+OFFSET_STRUCT_DMA_LIST_F018B_DEST
    lda #>dest
    sta memcpy_dma_command4+OFFSET_STRUCT_DMA_LIST_F018B_DEST+1
    // DMA->EN018B = 1
    // Set F018B mode
    ldz #1
    stz DMA+OFFSET_STRUCT_F018_DMAGIC_EN018B
    // DMA->ADDRMB = 0
    // Set address of DMA list
    ldz #0
    stz DMA+OFFSET_STRUCT_F018_DMAGIC_ADDRMB
    // DMA->ADDRBANK = 0
    stz DMA+OFFSET_STRUCT_F018_DMAGIC_ADDRBANK
    // DMA-> ADDRMSB = BYTE1(&memcpy_dma_command4)
    ldz #>memcpy_dma_command4
    stz DMA+OFFSET_STRUCT_F018_DMAGIC_ADDRMSB
    // DMA-> ADDRLSBTRIG = BYTE0(&memcpy_dma_command4)
    // Trigger the DMA (without option lists)
    ldz #<memcpy_dma_command4
    stz DMA
    // DMA->EN018B = dmaMode
    // Re-enable F018A mode
    stx DMA+OFFSET_STRUCT_F018_DMAGIC_EN018B
    // }
    rts
}
.segment Data
  // DMA list entry for copying data in the 1MB memory space
  memcpy_dma_command4: .byte DMA_COMMAND_COPY
  .word 0, 0
  .byte 0
  .word 0
  .byte 0, 0
  .word 0
