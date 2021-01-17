// Test the MAP instruction for remapping memory
// See section 2.3.4 in http://www.zimmers.net/cbmpics/cbm/c65/c65manual.txt for a description of the CPU memory remapper of the C65.
// See Appendix G in https://mega.scryptos.com/sharefolder-link/MEGA/MEGA65+filehost/Docs/MEGA65-Book_draft.pdf for a description of the CPU memory remapper of the MEGA65.
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
  // Default address of screen character matrix
  .label DEFAULT_SCREEN = $800
.segment Code
main: {
    .label BLOCK_4000 = $4000
    .label BLOCK_8000 = $8000
    // memoryRemapBlock(0x40, 0x100)
  // Remap [$4000-$5fff] to point to [$10000-$11fff]
    ldx #$40
    jsr memoryRemapBlock
    // BLOCK_4000[0] = '-'
    // Put '-', '*' into $10000
    lda #'-'
    sta BLOCK_4000
    // BLOCK_4000[1] = '*'
    lda #'*'
    sta BLOCK_4000+1
    // memoryRemapBlock(0x80, 0x100)
  // Remap [$8000-$9fff] to point to [$10000-$11fff]
    ldx #$80
    jsr memoryRemapBlock
    // BLOCK_8000[2] = '-'
    // Put '-', '*' into $10002
    lda #'-'
    sta BLOCK_8000+2
    // BLOCK_8000[3] = '*'
    lda #'*'
    sta BLOCK_8000+3
    // memoryRemap(MEMORYBLOCK_4000|MEMORYBLOCK_8000, 0x0c0, 0x080)
  // Remap [$4000-$5fff] and [$8000-$9fff] to both point to [$10000-$11fff] (notice usage of page offsets)
    lda #<$80
    sta.z memoryRemap.upperPageOffset
    lda #>$80
    sta.z memoryRemap.upperPageOffset+1
    ldz #MEMORYBLOCK_4000|MEMORYBLOCK_8000
    lda #<$c0
    sta.z memoryRemap.lowerPageOffset
    lda #>$c0
    sta.z memoryRemap.lowerPageOffset+1
    jsr memoryRemap
    // BLOCK_8000[4] = BLOCK_4000[2]
    // Put '-', '*' into $10004 in a convoluted way
    lda BLOCK_4000+2
    sta BLOCK_8000+4
    // BLOCK_4000[5] = BLOCK_8000[1]
    lda BLOCK_8000+1
    sta BLOCK_4000+5
    ldx #0
  // copy the resulting values onto the screen - it should show '-*-*-*'
  __b1:
    // for(char i=0;i<6;i++)
    cpx #6
    bcc __b2
    // memoryRemap256M(MEMORYBLOCK_4000, 0xff800-0x00040, 0)
  // Remap [$4000-$5fff] to point to [$ff80000-$ff81fff] COLORRAM! (notice usage of page offsets)
    ldz #MEMORYBLOCK_4000
    lda #<$ff800-$40
    sta.z memoryRemap256M.lowerPageOffset
    lda #>$ff800-$40
    sta.z memoryRemap256M.lowerPageOffset+1
    lda #<$ff800-$40>>$10
    sta.z memoryRemap256M.lowerPageOffset+2
    lda #>$ff800-$40>>$10
    sta.z memoryRemap256M.lowerPageOffset+3
    jsr memoryRemap256M
    ldx #0
  // Put colors in the upper screen line
  __b4:
    // for( char i=0; i<16; i++)
    cpx #$10
    bcc __b5
    // memoryRemap256M(0, 0, 0)
  // Remap [$4000-$5fff] back to normal memory!
    ldz #0
    lda #0
    sta.z memoryRemap256M.lowerPageOffset
    sta.z memoryRemap256M.lowerPageOffset+1
    sta.z memoryRemap256M.lowerPageOffset+2
    sta.z memoryRemap256M.lowerPageOffset+3
    jsr memoryRemap256M
    // }
    rts
  __b5:
    // 0x40+i
    txa
    clc
    adc #$40
    // BLOCK_4000[i] = 0x40+i
    sta BLOCK_4000,x
    // for( char i=0; i<16; i++)
    inx
    jmp __b4
  __b2:
    // (DEFAULT_SCREEN+80-6)[i] = BLOCK_4000[i]
    lda BLOCK_4000,x
    sta DEFAULT_SCREEN+$50-6,x
    // for(char i=0;i<6;i++)
    inx
    jmp __b1
}
// Remap a single 8K memory block in the 64K address space of the 6502 to point somewhere else in the first 1MB memory space of the MEGA65.
// All the other 8K memory blocks will not be mapped and will point to their own address in the lowest 64K of the MEGA65 memory.
// blockPage: Page address of the 8K memory block to remap (ie. the block that is remapped is $100 * the passed page address.)
// memoryPage: Page address of the memory that the block should point to in the 1MB memory space of the MEGA65.
// Ie. the memory that will be pointed to is $100 * the passed page address. Only the lower 12bits of the passed value is used.
// memoryRemapBlock(byte register(X) blockPage)
memoryRemapBlock: {
    .label pageOffset = $11
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
    sta.z memoryRemap.upperPageOffset
    lda.z pageOffset+1
    sta.z memoryRemap.upperPageOffset+1
    jsr memoryRemap
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
// memoryRemap(byte register(Z) remapBlocks, word zp($11) lowerPageOffset, word zp($15) upperPageOffset)
memoryRemap: {
    .label aVal = 6
    .label xVal = 7
    .label __1 = $14
    .label yVal = 8
    .label zVal = $a
    .label __6 = 9
    .label lowerPageOffset = $11
    .label upperPageOffset = $15
    // <lowerPageOffset
    lda.z lowerPageOffset
    // aVal = <lowerPageOffset
    // lower blocks offset page low
    sta.z aVal
    // remapBlocks << 4
    tza
    asl
    asl
    asl
    asl
    sta.z __1
    // >lowerPageOffset
    lda.z lowerPageOffset+1
    // >lowerPageOffset & 0xf
    and #$f
    // (remapBlocks << 4)   | (>lowerPageOffset & 0xf)
    ora.z __1
    // xVal = (remapBlocks << 4)   | (>lowerPageOffset & 0xf)
    // lower blocks to map + lower blocks offset high nibble
    sta.z xVal
    // <upperPageOffset
    lda.z upperPageOffset
    // yVal = <upperPageOffset
    // upper blocks offset page
    sta.z yVal
    // remapBlocks & 0xf0
    tza
    and #$f0
    sta.z __6
    // >upperPageOffset
    lda.z upperPageOffset+1
    // >upperPageOffset & 0xf
    and #$f
    // (remapBlocks & 0xf0) | (>upperPageOffset & 0xf)
    ora.z __6
    // zVal = (remapBlocks & 0xf0) | (>upperPageOffset & 0xf)
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
// Remap some of the eight 8K memory blocks in the 64K address space of the 6502 to point somewhere else in the entire 256MB memory space of the MEGA65.
// After the remapping the CPU will access the mapped memory whenever it uses instructions that access a remapped block.
// See section 2.3.4 in http://www.zimmers.net/cbmpics/cbm/c65/c65manual.txt for a description of the CPU memory remapper of the C65.
// See Appendix G in file:///Users/jespergravgaard/Downloads/MEGA65-Book_draft%20(5).pdf for a description of the CPU memory remapper of the MEGA65.
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
// The offset is a page offset (meaning it is multiplied by 0x100). Only the lower 20bits of the passed value is used.
// - If block 0 ($0000-$1fff) is remapped it will point to lowerPageOffset*$100.
// - If block 1 ($2000-$3fff) is remapped it will point to lowerPageOffset*$100 + $2000.
// - If block 2 ($4000-$5fff) is remapped it will point to lowerPageOffset*$100 + $4000.
// - If block 3 ($6000-$7fff) is remapped it will point to lowerPageOffset*$100 + $6000.
// upperPageOffset: Offset that will be added to any remapped blocks in the upper 32K of memory (block 4-7).
// The offset is a page offset (meaning it is multiplied by 0x100). Only the lower 20bits of the passed value is used.
// - If block 4 ($8000-$9fff) is remapped it will point to upperPageOffset*$100 + $8000
// - If block 5 ($a000-$bfff) is remapped it will point to upperPageOffset*$100 + $a000.
// - If block 6 ($c000-$dfff) is remapped it will point to upperPageOffset*$100 + $c000.
// - If block 7 ($e000-$ffff) is remapped it will point to upperPageOffset*$100 + $e000.
// memoryRemap256M(byte register(Z) remapBlocks, dword zp(2) lowerPageOffset)
memoryRemap256M: {
    .label lMb = $f
    .label __0 = $b
    .label uMb = $10
    .label aVal = $13
    .label __4 = $11
    .label xVal = $17
    .label __6 = $14
    .label __7 = $15
    .label yVal = $18
    .label zVal = $19
    .label lowerPageOffset = 2
    // lowerPageOffset>>4
    lda.z lowerPageOffset+3
    lsr
    sta.z __0+3
    lda.z lowerPageOffset+2
    ror
    sta.z __0+2
    lda.z lowerPageOffset+1
    ror
    sta.z __0+1
    lda.z lowerPageOffset
    ror
    sta.z __0
    lsr.z __0+3
    ror.z __0+2
    ror.z __0+1
    ror.z __0
    lsr.z __0+3
    ror.z __0+2
    ror.z __0+1
    ror.z __0
    lsr.z __0+3
    ror.z __0+2
    ror.z __0+1
    ror.z __0
    // >((unsigned int)(lowerPageOffset>>4))
    lda.z __0+1
    // lMb = >((unsigned int)(lowerPageOffset>>4))
    // lower blocks offset megabytes
    sta.z lMb
    // uMb = >((unsigned int)(upperPageOffset>>4))
    // upper blocks offset megabytes
    lda #0
    sta.z uMb
    // <lowerPageOffset
    lda.z lowerPageOffset
    sta.z __4
    lda.z lowerPageOffset+1
    sta.z __4+1
    // < <lowerPageOffset
    lda.z __4
    // aVal = < <lowerPageOffset
    // lower blocks offset page low
    sta.z aVal
    // remapBlocks << 4
    tza
    asl
    asl
    asl
    asl
    sta.z __6
    // <lowerPageOffset
    lda.z lowerPageOffset
    sta.z __7
    lda.z lowerPageOffset+1
    sta.z __7+1
    // > <lowerPageOffset
    // > <lowerPageOffset & 0xf
    and #$f
    // (remapBlocks << 4)   | (> <lowerPageOffset & 0xf)
    ora.z __6
    // xVal = (remapBlocks << 4)   | (> <lowerPageOffset & 0xf)
    // lower blocks to map + lower blocks offset high nibble
    sta.z xVal
    // yVal = < <upperPageOffset
    // upper blocks offset page
    lda #0
    sta.z yVal
    // remapBlocks & 0xf0
    tza
    and #$f0
    // (remapBlocks & 0xf0) | (> <upperPageOffset & 0xf)
    // zVal = (remapBlocks & 0xf0) | (> <upperPageOffset & 0xf)
    // upper blocks to map + upper blocks offset page high nibble
    sta.z zVal
    // asm
    lda lMb
    ldx #$f
    ldy uMb
    ldz #0
    map
    lda aVal
    ldx xVal
    ldy yVal
    ldz zVal
    map
    eom
    // }
    rts
}
