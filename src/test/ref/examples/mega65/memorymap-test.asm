// Test the MAP instruction for remapping memory
// MEGA65 Registers and Constants
// The MOS 6526 Complex Interface Adapter (CIA)
// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
.cpu _45gs02
  // MEGA65 platform PRG executable starting in MEGA65 mode.
.file [name="memorymap-test.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$2001]
.segmentdef Code [start=$2017]
.segmentdef Data [startAfter="Code"]
.segment Basic
.byte $0a, $20, $0a, $00, $fe, $02, $20, $30, $00       // 10 BANK 0
.byte $15, $20, $14, $00, $9e, $20                      // 20 SYS 
.text toIntString(main)                                   //         NNNN
.byte $00, $00, $00                                     // 
  // Bit representing 8K block #2 of the 64K addressable memory ($4000-$5fff)
  .const MEMORYBLOCK_4000 = 4
  // Bit representing 8K block #4 of the 64K addressable memory ($8000-$9fff)
  .const MEMORYBLOCK_8000 = $10
.segment Code
main: {
    .label block1 = $4000
    .label block2 = $8000
    // memoryRemapBlock(0x40, 0x100)
  // Remap [$4000-$5fff] to point to [$10000-$11fff]
    ldx #$40
    jsr memoryRemapBlock
    // block1[0] = 0x55
    // Put 0x55, 0xaa into $10000
    lda #$55
    sta block1
    // block1[1] = 0xaa
    lda #$aa
    sta block1+1
    // memoryRemapBlock(0x80, 0x100)
  // Remap [$8000-$9fff] to point to [$10000-$11fff]
    ldx #$80
    jsr memoryRemapBlock
    // block2[2] = 0x55
    // Put 0x55, 0xaainto $10002
    lda #$55
    sta block2+2
    // block2[3] = 0xaa
    lda #$aa
    sta block2+3
    // memoryRemap(MEMORYBLOCK_4000|MEMORYBLOCK_8000, 0x0c0, 0x080)
  // Remap [$4000-$5fff] and [$8000-$9fff] to both point to [$10000-$11fff] (notice usage of page offsets)
    lda #<$80
    sta.z memoryRemap.upperMemoryPageOffset
    lda #>$80
    sta.z memoryRemap.upperMemoryPageOffset+1
    ldz #MEMORYBLOCK_4000|MEMORYBLOCK_8000
    lda #<$c0
    sta.z memoryRemap.lowerMemoryPageOffset
    lda #>$c0
    sta.z memoryRemap.lowerMemoryPageOffset+1
    jsr memoryRemap
    // block2[4] = block1[2]
    // Put 0x55, 0xaa into $10004 in a convoluted way
    lda block1+2
    sta block2+4
    // block1[5] = block2[1]
    lda block2+1
    sta block1+5
    // }
    rts
}
// Remap a single 8K memory block in the 64K address space of the 6502 to point somewhere else in the first 1MB memory space of the MEGA65.
// All the other 8K memory blocks will not be mapped and will point to their own address in the lowest 64K of the MEGA65 memory.
// blockPage: Page address of the 8K memory block to remap (ie. the block that is remapped is $100 * the passed page address.) 
// memoryPage: Page address of the memory that the block should point to in the 1MB memory space of the MEGA65. 
// Ie. the memory that will be pointed to is $100 * the passed page address. Only the lower 12bits of the passed value is used.
// memoryRemapBlock(byte register(X) blockPage)
memoryRemapBlock: {
    .label pageOffset = 2
    // pageOffset = memoryPage-blockPage
    stx.z $ff
    lda #<$100
    sec
    sbc.z $ff
    sta.z pageOffset
    lda #>$100
    sbc #0
    sta.z pageOffset+1
    // block = blockPage / $20
    txa
    lsr
    lsr
    lsr
    lsr
    lsr
    // blockBits = 1<<block
    tay
    lda #1
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    // memoryRemap(blockBits, pageOffset, pageOffset)
    taz
    lda.z pageOffset
    sta.z memoryRemap.upperMemoryPageOffset
    lda.z pageOffset+1
    sta.z memoryRemap.upperMemoryPageOffset+1
    jsr memoryRemap
    // }
    rts
}
// Remap some of the eight 8K memory blocks in the 64K address space of the 6502 to point somewhere else in the first 1MB memory space of the MEGA65.
// After the remapping the CPU will access the mapped memory whenever it uses instructions that access a remapped block.
// remapBlocks: Indicates which 8K blocks of the 6502 address space to remap. Each bit represents one 8K block
// - bit 0  Memory block $0000-$1fff. Use constant MEMORYBLOCK_0000. 
// - bit 1  Memory block $2000-$3fff. Use constant MEMORYBLOCK_2000. 
// - bit 2  Memory block $4000-$5fff. Use constant MEMORYBLOCK_4000. 
// - bit 3  Memory block $6000-$7fff. Use constant MEMORYBLOCK_6000. 
// - bit 4  Memory block $8000-$9fff. Use constant MEMORYBLOCK_8000. 
// - bit 5  Memory block $a000-$bfff. Use constant MEMORYBLOCK_A000. 
// - bit 6  Memory block $c000-$dfff. Use constant MEMORYBLOCK_C000. 
// - bit 7  Memory block $e000-$ffff. Use constant MEMORYBLOCK_E000. 
// lowerMemoryPageOffset: Offset that will be added to any remapped blocks in the lower 32K of memory (block 0-3). 
// The offset is a page offset (meaning it is multiplied by 0x100). Only the lower 12bits of the passed value is used.
// - If block 0 ($0000-$1fff) is remapped it will point to lowerMemoryPageOffset*$100.  
// - If block 1 ($2000-$3fff) is remapped it will point to lowerMemoryPageOffset*$100 + $2000.  
// - If block 2 ($4000-$5fff) is remapped it will point to lowerMemoryPageOffset*$100 + $4000.  
// - If block 3 ($6000-$7fff) is remapped it will point to lowerMemoryPageOffset*$100 + $6000.  
// upperMemoryPageOffset: Offset that will be added to any remapped blocks in the upper 32K of memory (block 4-7). 
// The offset is a page offset (meaning it is multiplied by 0x100). Only the lower 12bits of the passed value is used.
// - If block 4 ($8000-$9fff) is remapped it will point to upperMemoryPageOffset*$100 + $8000  
// - If block 5 ($a000-$bfff) is remapped it will point to upperMemoryPageOffset*$100 + $a000.  
// - If block 6 ($c000-$dfff) is remapped it will point to upperMemoryPageOffset*$100 + $c000.  
// - If block 7 ($e000-$ffff) is remapped it will point to upperMemoryPageOffset*$100 + $e000.  
// memoryRemap(byte register(Z) remapBlocks, word zp(2) lowerMemoryPageOffset, word zp(4) upperMemoryPageOffset)
memoryRemap: {
    .label aVal = $fc
    .label xVal = $fd
    .label yVal = $fe
    .label zVal = $ff
    .label __1 = 6
    .label __6 = 7
    .label lowerMemoryPageOffset = 2
    .label upperMemoryPageOffset = 4
    // <lowerMemoryPageOffset
    lda.z lowerMemoryPageOffset
    // *aVal = <lowerMemoryPageOffset
    sta aVal
    // remapBlocks << 4
    tza
    asl
    asl
    asl
    asl
    sta.z __1
    // >lowerMemoryPageOffset
    lda.z lowerMemoryPageOffset+1
    // >lowerMemoryPageOffset & 0xf
    and #$f
    // (remapBlocks << 4)   | (>lowerMemoryPageOffset & 0xf)
    ora.z __1
    // *xVal = (remapBlocks << 4)   | (>lowerMemoryPageOffset & 0xf)
    sta xVal
    // <upperMemoryPageOffset
    lda.z upperMemoryPageOffset
    // *yVal = <upperMemoryPageOffset
    sta yVal
    // remapBlocks & 0xf0
    tza
    and #$f0
    sta.z __6
    // >upperMemoryPageOffset
    lda.z upperMemoryPageOffset+1
    // >upperMemoryPageOffset & 0xf
    and #$f
    // (remapBlocks & 0xf0) | (>upperMemoryPageOffset & 0xf)
    ora.z __6
    // *zVal = (remapBlocks & 0xf0) | (>upperMemoryPageOffset & 0xf)
    sta zVal
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
