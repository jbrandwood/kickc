// SID music located in another bank being played using memory mapping on MEGA65
// Music is Cybernoid II by Jeroen Tel released in 1988 by Hewson https://csdb.dk/sid/?id=28140
// SID relocated using http://www.linusakesson.net/software/sidreloc/index.php
.cpu _45gs02
  // MEGA65 platform PRG executable with banked code and data starting in MEGA65 mode.
.file [name="banked-music.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$2001]
.segmentdef Code [start=$2017]
.segmentdef Data [startAfter="Code"]
.segmentdef Banked [segments="CodeBanked, DataBanked"]
.segmentdef CodeBanked [start=$4000]
.segmentdef DataBanked [startAfter="CodeBanked"]
.segment Basic
.byte $0a, $20, $0a, $00, $fe, $02, $20, $30, $00       // 10 BANK 0
.byte $15, $20, $14, $00, $9e, $20                      // 20 SYS 
.text toIntString(main)                                   //         NNNN
.byte $00, $00, $00                                     // 
  .const OFFSET_STRUCT_MOS6569_VICII_RASTER = $12
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  // The VIC-II MOS 6567/6569
  .label VICII = $d000
  // Address after the end of the music
  .label MUSIC_END = $5200
  // Pointer to the music init routine
  .label musicInit = MUSIC
  // Pointer to the music play routine
  .label musicPlay = MUSIC+3
.segment Code
main: {
    .label dst = 2
    .label src = 4
    // Pointer to (unmapped) $4000 used for overwriting to demonstrate the mapping works
    .label mem_destroy = 6
    // asm
    // Stop IRQ's
    sei
    // memoryRemapBlock(0x40, 0x100)
  // Remap [$4000-$5fff] to point to [$10000-$11fff]
    jsr memoryRemapBlock
    lda #<upperCodeData
    sta.z src
    lda #>upperCodeData
    sta.z src+1
    lda #<MUSIC
    sta.z dst
    lda #>MUSIC
    sta.z dst+1
  // Transfer banked code/data to upper memory ($11000)
  __b1:
    // for( char *src=upperCodeData, *dst=MUSIC; dst<MUSIC_END; )
    lda.z dst+1
    cmp #>MUSIC_END
    bcc __b2
    bne !+
    lda.z dst
    cmp #<MUSIC_END
    bcc __b2
  !:
    // (*musicInit)()
    // Initialize SID memory is still remapped)
    jsr musicInit
    // memoryRemap(0,0,0)
  // Reset memory mapping
    lda #<0
    sta.z memoryRemap.upperPageOffset
    sta.z memoryRemap.upperPageOffset+1
    ldz #0
    sta.z memoryRemap.lowerPageOffset
    sta.z memoryRemap.lowerPageOffset+1
    jsr memoryRemap
    lda #<MUSIC
    sta.z mem_destroy
    lda #>MUSIC
    sta.z mem_destroy+1
  __b4:
    // *mem_destroy = 0
    // Overwrite data in the unmapped memory where the music is mapped in (to demonstrate that mapping works)
    lda #0
    tay
    sta (mem_destroy),y
    // if(++mem_destroy==MUSIC_END)
    inw.z mem_destroy
    lda.z mem_destroy+1
    cmp #>MUSIC_END
    bne __b10
    lda.z mem_destroy
    cmp #<MUSIC_END
    bne __b10
    lda #<MUSIC
    sta.z mem_destroy
    lda #>MUSIC
    sta.z mem_destroy+1
  __b10:
  // Wait for the raster
    // while(VICII->RASTER!=0xff)
    lda #$ff
    cmp VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    bne __b10
    // (VICII->BORDER_COLOR)++;
    inc VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // memoryRemapBlock(0x40, 0x100)
  // Remap memory to put music at $4000
    jsr memoryRemapBlock
    // (*musicPlay)()
    // Play remapped SID
    jsr musicPlay
    // memoryRemap(0,0,0)
  // Reset memory mapping
    lda #<0
    sta.z memoryRemap.upperPageOffset
    sta.z memoryRemap.upperPageOffset+1
    ldz #0
    sta.z memoryRemap.lowerPageOffset
    sta.z memoryRemap.lowerPageOffset+1
    jsr memoryRemap
    // (VICII->BORDER_COLOR)--;
    dec VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
  // Wait for the raster
  __b7:
    // while(VICII->RASTER==0xff)
    lda #$ff
    cmp VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    beq __b7
    jmp __b4
  __b2:
    // *dst++ = *src++
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    inw.z dst
    inw.z src
    jmp __b1
}
// Remap a single 8K memory block in the 64K address space of the 6502 to point somewhere else in the first 1MB memory space of the MEGA65.
// All the other 8K memory blocks will not be mapped and will point to their own address in the lowest 64K of the MEGA65 memory.
// blockPage: Page address of the 8K memory block to remap (ie. the block that is remapped is $100 * the passed page address.)
// memoryPage: Page address of the memory that the block should point to in the 1MB memory space of the MEGA65.
// Ie. the memory that will be pointed to is $100 * the passed page address. Only the lower 12bits of the passed value is used.
memoryRemapBlock: {
    .const pageOffset = $100-$40
    .const block = $40>>5
    .const blockBits = 1<<block
    // memoryRemap(blockBits, pageOffset, pageOffset)
    lda #<pageOffset
    sta.z memoryRemap.upperPageOffset
    lda #>pageOffset
    sta.z memoryRemap.upperPageOffset+1
    ldz #blockBits
    lda #<pageOffset
    sta.z memoryRemap.lowerPageOffset
    lda #>pageOffset
    sta.z memoryRemap.lowerPageOffset+1
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
// memoryRemap(byte register(Z) remapBlocks, word zp(8) lowerPageOffset, word zp($a) upperPageOffset)
memoryRemap: {
    .label aVal = $fc
    .label xVal = $fd
    .label yVal = $fe
    .label zVal = $ff
    .label __1 = $c
    .label __6 = $d
    .label lowerPageOffset = 8
    .label upperPageOffset = $a
    // <lowerPageOffset
    lda.z lowerPageOffset
    // *aVal = <lowerPageOffset
    sta aVal
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
    // *xVal = (remapBlocks << 4)   | (>lowerPageOffset & 0xf)
    sta xVal
    // <upperPageOffset
    lda.z upperPageOffset
    // *yVal = <upperPageOffset
    sta yVal
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
    // *zVal = (remapBlocks & 0xf0) | (>upperPageOffset & 0xf)
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
.segment Data
// Array containing the banked upper memory code/data to be transferred to upper memory before execution
upperCodeData:
.segmentout [segments="Banked"]

.segment DataBanked
.pc = $4000 "MUSIC"
// SID tune at an absolute address
MUSIC:
.const music = LoadSid("Cybernoid_II_4000.sid")
    .fill music.size, music.getData(i)

