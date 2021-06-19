// MEGA65 DMA test using 256MB version
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
.file [name="dma-test4.prg", type="prg", segments="Program"]
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
  /// $00 = End of options
  .const DMA_OPTION_END = 0
  /// $0B = Use F018B list format
  .const DMA_OPTION_FORMAT_F018B = $a
  /// $80 $xx = Set MB of source address
  .const DMA_OPTION_SRC_MB = $80
  /// $81 $xx = Set MB of destination address
  .const DMA_OPTION_DEST_MB = $81
  .const OFFSET_STRUCT_F018_DMAGIC_EN018B = 3
  .const OFFSET_STRUCT_DMA_LIST_F018B_COUNT = 1
  .const OFFSET_STRUCT_DMA_LIST_F018B_SRC = 3
  .const OFFSET_STRUCT_DMA_LIST_F018B_DEST = 6
  .const OFFSET_STRUCT_F018_DMAGIC_ADDRMB = 4
  .const OFFSET_STRUCT_F018_DMAGIC_ADDRBANK = 2
  .const OFFSET_STRUCT_F018_DMAGIC_ADDRMSB = 1
  .const OFFSET_STRUCT_DMA_LIST_F018B_SRC_BANK = 5
  .const OFFSET_STRUCT_DMA_LIST_F018B_DEST_BANK = 8
  .const OFFSET_STRUCT_F018_DMAGIC_ETRIG = 5
  /// DMAgic F018 Controller
  .label DMA = $d700
  /// Default address of screen character matrix
  .label DEFAULT_SCREEN = $800
.segment Code
main: {
    // memoryRemap(0,0,0)
    // Map memory to BANK 0 : 0x00XXXX - giving access to I/O
    jsr memoryRemap
    // memcpy_dma256(0,0, DEFAULT_SCREEN, 0,0, DEFAULT_SCREEN+80, 24*80)
    // Move screen up using DMA
    jsr memcpy_dma256
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
memoryRemap: {
    .label aVal = 2
    .label xVal = 3
    .label yVal = 4
    .label zVal = 5
    // char aVal = BYTE0(lowerPageOffset)
    // lower blocks offset page low
    lda #0
    sta.z aVal
    // char xVal = (remapBlocks << 4)   | (BYTE1(lowerPageOffset) & 0xf)
    // lower blocks to map + lower blocks offset high nibble
    sta.z xVal
    // char yVal = BYTE0(upperPageOffset)
    // upper blocks offset page
    sta.z yVal
    // char zVal = (remapBlocks & 0xf0) | (BYTE1(upperPageOffset) & 0xf)
    // upper blocks to map + upper blocks offset page high nibble
    sta.z zVal
    // asm
    lda aVal
    ldx xVal
    ldy yVal
    ldz zVal
    map
    eom
    // }
    rts
}
// Copy a memory block anywhere in the entire 256MB memory space using MEGA65 DMagic DMA
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// - dest_mb The MB value for the destination (0-255)
// - dest_bank The 64KB bank for the destination (0-15)
// - dest The destination address (within the MB and bank)
// - src_mb The MB value for the source (0-255)
// - src_bank The 64KB bank for the source (0-15)
// - src The source address (within the MB and bank)
// - num The number of bytes to copy
memcpy_dma256: {
    .const dest_mb = 0
    .const dest_bank = 0
    .const src_mb = 0
    .const src_bank = 0
    .const num = $18*$50
    .label dest = DEFAULT_SCREEN
    .label src = DEFAULT_SCREEN+$50
    .label f018b = memcpy_dma_command256+6
    // char dmaMode = DMA->EN018B
    // Remember current F018 A/B mode
    ldx DMA+OFFSET_STRUCT_F018_DMAGIC_EN018B
    // memcpy_dma_command256[1] = src_mb
    // Set up command
    lda #src_mb
    sta memcpy_dma_command256+1
    // memcpy_dma_command256[3] = dest_mb
    lda #dest_mb
    sta memcpy_dma_command256+3
    // f018b->count = num
    lda #<num
    sta f018b+OFFSET_STRUCT_DMA_LIST_F018B_COUNT
    lda #>num
    sta f018b+OFFSET_STRUCT_DMA_LIST_F018B_COUNT+1
    // f018b->src_bank = src_bank
    lda #src_bank
    sta f018b+OFFSET_STRUCT_DMA_LIST_F018B_SRC_BANK
    // f018b->src = src
    lda #<src
    sta f018b+OFFSET_STRUCT_DMA_LIST_F018B_SRC
    lda #>src
    sta f018b+OFFSET_STRUCT_DMA_LIST_F018B_SRC+1
    // f018b->dest_bank = dest_bank
    lda #dest_bank
    sta f018b+OFFSET_STRUCT_DMA_LIST_F018B_DEST_BANK
    // f018b->dest = dest
    lda #<dest
    sta f018b+OFFSET_STRUCT_DMA_LIST_F018B_DEST
    lda #>dest
    sta f018b+OFFSET_STRUCT_DMA_LIST_F018B_DEST+1
    // DMA->EN018B = 1
    // Set F018B mode
    lda #1
    sta DMA+OFFSET_STRUCT_F018_DMAGIC_EN018B
    // DMA->ADDRMB = 0
    // Set address of DMA list
    lda #0
    sta DMA+OFFSET_STRUCT_F018_DMAGIC_ADDRMB
    // DMA->ADDRBANK = 0
    sta DMA+OFFSET_STRUCT_F018_DMAGIC_ADDRBANK
    // DMA-> ADDRMSB = BYTE1(memcpy_dma_command256)
    lda #>memcpy_dma_command256
    sta DMA+OFFSET_STRUCT_F018_DMAGIC_ADDRMSB
    // DMA-> ETRIG = BYTE0(memcpy_dma_command256)
    // Trigger the DMA (with option lists)
    lda #<memcpy_dma_command256
    sta DMA+OFFSET_STRUCT_F018_DMAGIC_ETRIG
    // DMA->EN018B = dmaMode
    // Re-enable F018A mode
    stx DMA+OFFSET_STRUCT_F018_DMAGIC_EN018B
    // }
    rts
}
.segment Data
  // DMA list entry with options for copying data in the 256MB memory space
  // Contains DMA options options for setting MB followed by DMA_LIST_F018B struct.
  memcpy_dma_command256: .byte DMA_OPTION_SRC_MB, 0, DMA_OPTION_DEST_MB, 0, DMA_OPTION_FORMAT_F018B, DMA_OPTION_END, DMA_COMMAND_COPY, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
