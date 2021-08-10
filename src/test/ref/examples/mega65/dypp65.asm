// DYPP (Different Y Pixel Position) LOGO created using DMA
// Graphics mode is 45x25 full-colour super extended attribute mode text-mode
// Character layout is column-wise giving linear addressing of the graphics (one byte per pixel)
.cpu _45gs02
  // MEGA65 platform PRG executable starting in MEGA65 mode.
.file [name="dypp65.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$2001]
.segmentdef Code [start=$2017]
.segmentdef Data [startAfter="Code"]
.segment Basic
.byte $0a, $20, $0a, $00, $fe, $02, $20, $30, $00       // 10 BANK 0
.byte $15, $20, $14, $00, $9e, $20                      // 20 SYS 
.text toIntString(main)                                   //         NNNN
.byte $00, $00, $00                                     // 
  /// DMA command fill
  .const DMA_COMMAND_FILL = 3
  /// $00 = End of options
  .const DMA_OPTION_END = 0
  /// $0B = Use F018B list format
  .const DMA_OPTION_FORMAT_F018B = $a
  /// $81 $xx = Set MB of destination address
  .const DMA_OPTION_DEST_MB = $81
  .const WHITE = 1
  .const SIZEOF_UNSIGNED_INT = 2
  .const OFFSET_STRUCT_F018_DMAGIC_EN018B = 3
  .const OFFSET_STRUCT_DMA_LIST_F018B_COUNT = 1
  .const OFFSET_STRUCT_DMA_LIST_F018B_SRC = 3
  .const OFFSET_STRUCT_DMA_LIST_F018B_DEST = 6
  .const OFFSET_STRUCT_F018_DMAGIC_ADDRMB = 4
  .const OFFSET_STRUCT_F018_DMAGIC_ADDRBANK = 2
  .const OFFSET_STRUCT_F018_DMAGIC_ADDRMSB = 1
  .const OFFSET_STRUCT_DMA_LIST_F018B_DEST_BANK = 8
  .const OFFSET_STRUCT_F018_DMAGIC_ETRIG = 5
  .const OFFSET_STRUCT_MEGA65_VICIV_CONTROLB = $31
  .const OFFSET_STRUCT_MEGA65_VICIV_CONTROLC = $54
  .const OFFSET_STRUCT_MEGA65_VICIV_KEY = $2f
  .const OFFSET_STRUCT_MEGA65_VICIV_SIDBDRWD_LO = $5c
  .const OFFSET_STRUCT_MEGA65_VICIV_SIDBDRWD_HI = $5d
  .const OFFSET_STRUCT_MEGA65_VICIV_TBDRPOS_LO = $48
  .const OFFSET_STRUCT_MEGA65_VICIV_TBDRPOS_HI = $49
  .const OFFSET_STRUCT_MEGA65_VICIV_BBDRPOS_LO = $4a
  .const OFFSET_STRUCT_MEGA65_VICIV_BBDRPOS_HI = $4b
  .const OFFSET_STRUCT_MEGA65_VICIV_CHARSTEP_LO = $58
  .const OFFSET_STRUCT_MEGA65_VICIV_CHARSTEP_HI = $59
  .const OFFSET_STRUCT_MEGA65_VICIV_TEXTXPOS_LO = $4c
  .const OFFSET_STRUCT_MEGA65_VICIV_TEXTXPOS_HI = $4d
  .const OFFSET_STRUCT_MEGA65_VICIV_CHRCOUNT = $5e
  .const OFFSET_STRUCT_MEGA65_VICIV_SCRNPTR_LOLO = $60
  .const OFFSET_STRUCT_MEGA65_VICIV_SCRNPTR_LOHI = $61
  .const OFFSET_STRUCT_MEGA65_VICIV_SCRNPTR_HILO = $62
  .const OFFSET_STRUCT_MEGA65_VICIV_SCRNPTR_HIHI = $63
  .const OFFSET_STRUCT_MEGA65_VICIV_CHARPTR_LOLO = $68
  .const OFFSET_STRUCT_MEGA65_VICIV_CHARPTR_LOHI = $69
  .const OFFSET_STRUCT_MEGA65_VICIV_CHARPTR_HILO = $6a
  .const OFFSET_STRUCT_MOS6569_VICII_RASTER = $12
  .const OFFSET_STRUCT_MEGA65_VICIV_BG_COLOR = $21
  /// The VIC-II MOS 6567/6569
  .label VICII = $d000
  /// The VIC IV
  .label VICIV = $d000
  /// DMAgic F018 Controller
  .label DMA = $d700
  // The screen address (45*25*2=0x08ca bytes)
  .label SCREEN = $5000
  // The charset address (45*32*8=0x2d00 bytes)
  .label CHARSET = $6000
.segment Code
main: {
    .label c = 8
    // Fill extended screen to achieve column-wise linear addressing
    .label erow = 2
    //  Copy the LOGO to the CHARSET
    .label logo_dest = 6
    .label logo_src = 4
    // asm
    sei
    // memoryRemap(0,0,0)
    // Map memory to BANK 0 : 0x00XXXX - giving access to I/O
    jsr memoryRemap
    // VICIV->CONTROLB |= 0x40
    // Enable 48MHz fast mode
    lda #$40
    ora VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLB
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLB
    // VICIV->CONTROLC |= 0x40
    lda #$40
    ora VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLC
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLC
    // VICIV->KEY = 0x47
    // Enable the VIC 4
    lda #$47
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_KEY
    // VICIV->KEY = 0x53
    lda #$53
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_KEY
    // VICIV->SIDBDRWD_LO = 0
    // Set sideborder width=0, disable raster delay and hot registers
    lda #0
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_SIDBDRWD_LO
    // VICIV->SIDBDRWD_HI = 0
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_SIDBDRWD_HI
    // VICIV->TBDRPOS_LO = 0
    // Disable top/bottom borders
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_TBDRPOS_LO
    // VICIV->TBDRPOS_HI = 0
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_TBDRPOS_HI
    // VICIV->BBDRPOS_LO = 0
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_BBDRPOS_LO
    // VICIV->BBDRPOS_HI = 2
    lda #2
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_BBDRPOS_HI
    // VICIV->CONTROLC |= 1
    // Enable Super Extended Attribute Mode
    lda #1
    ora VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLC
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLC
    // VICIV->CONTROLB &= 0x7f
    // Mode 40x25 chars - will be 45*25 when utilizing the borders
    lda #$7f
    and VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLB
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLB
    // VICIV->CHARSTEP_LO = 90
    lda #$5a
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_CHARSTEP_LO
    // VICIV->CHARSTEP_HI = 0
    lda #0
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_CHARSTEP_HI
    // VICIV->TEXTXPOS_LO = 40
    // Start text in the left border
    lda #$28
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_TEXTXPOS_LO
    // VICIV->TEXTXPOS_HI = 0
    lda #0
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_TEXTXPOS_HI
    // VICIV->CHRCOUNT = 45
    // Set number of characters to display per row
    lda #$2d
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_CHRCOUNT
    // VICIV->SCRNPTR_LOLO = BYTE0(SCREEN)
    // Set exact screen address
    lda #0
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_SCRNPTR_LOLO
    // VICIV->SCRNPTR_LOHI = BYTE1(SCREEN)
    lda #>SCREEN
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_SCRNPTR_LOHI
    // VICIV->SCRNPTR_HILO = 0
    lda #0
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_SCRNPTR_HILO
    // VICIV->SCRNPTR_HIHI = 0
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_SCRNPTR_HIHI
    // VICIV->CHARPTR_LOLO = BYTE0(CHARSET)
    // Set exact charset address
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_CHARPTR_LOLO
    // VICIV->CHARPTR_LOHI = BYTE1(CHARSET)
    lda #>CHARSET
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_CHARPTR_LOHI
    // VICIV->CHARPTR_HILO = 0
    lda #0
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_CHARPTR_HILO
    // memset_dma(SCREEN, 0, 45*25*2)
  // Fill the screen with 0
    lda #<SCREEN
    sta.z memset_dma.dest
    lda #>SCREEN
    sta.z memset_dma.dest+1
    ldz #0
    lda #<$2d*$19*2
    sta.z memset_dma.num
    lda #>$2d*$19*2
    sta.z memset_dma.num+1
    jsr memset_dma
    // memset_dma256(0xff,0x08,(void*)0x0000, WHITE, 45*25*2)
    // Fill the colours with WHITE - directly into $ff80000
    jsr memset_dma256
    // memset_dma(CHARSET, 0x55, 45*32*8)
  // Fill the charset with 0x55
    lda #<CHARSET
    sta.z memset_dma.dest
    lda #>CHARSET
    sta.z memset_dma.dest+1
    ldz #$55
    lda #<$2d*$20*8
    sta.z memset_dma.num
    lda #>$2d*$20*8
    sta.z memset_dma.num+1
    jsr memset_dma
    lda #<SCREEN
    sta.z erow
    lda #>SCREEN
    sta.z erow+1
    ldx #0
  __b1:
    // for(char r=0; r<25; r++)
    cpx #$19
    bcc __b2
    lda #<CHARSET
    sta.z logo_dest
    lda #>CHARSET
    sta.z logo_dest+1
    lda #<LOGO
    sta.z logo_src
    lda #>LOGO
    sta.z logo_src+1
    ldx #0
  __b6:
    // for(char col=0;col<45;col++)
    cpx #$2d
    bcc __b5
  __b10:
    // VICIV->BG_COLOR = VICII->RASTER
    lda VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_BG_COLOR
    jmp __b10
  __b5:
    ldy #0
  __b7:
    // for(char y=0;y<25*8;y++)
    cpy #$19*8
    bcc __b8
    // logo_dest += 32*8
    lda.z logo_dest
    clc
    adc #<$20*8
    sta.z logo_dest
    lda.z logo_dest+1
    adc #>$20*8
    sta.z logo_dest+1
    // logo_src += 25*8
    lda #$19*8
    clc
    adc.z logo_src
    sta.z logo_src
    bcc !+
    inc.z logo_src+1
  !:
    // for(char col=0;col<45;col++)
    inx
    jmp __b6
  __b8:
    // logo_dest[y] = logo_src[y]
    lda (logo_src),y
    sta (logo_dest),y
    // for(char y=0;y<25*8;y++)
    iny
    jmp __b7
  __b2:
    // unsigned int c = r
    txa
    sta.z c
    lda #0
    sta.z c+1
    ldz #0
  __b3:
    // for(char i=0; i<45; i++)
    cpz #$2d
    bcc __b4
    // erow += 45
    lda #$2d*SIZEOF_UNSIGNED_INT
    clc
    adc.z erow
    sta.z erow
    bcc !+
    inc.z erow+1
  !:
    // for(char r=0; r<25; r++)
    inx
    jmp __b1
  __b4:
    // erow[i] = c
    tza
    asl
    tay
    lda.z c
    sta (erow),y
    iny
    lda.z c+1
    sta (erow),y
    // c += 32
    lda #$20
    clc
    adc.z c
    sta.z c
    bcc !+
    inc.z c+1
  !:
    // for(char i=0; i<45; i++)
    inz
    jmp __b3
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
    .label aVal = $e
    .label xVal = $f
    .label yVal = $10
    .label zVal = $11
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
// Fill a memory block within the first 64K memory space using MEGA65 DMagic DMA
// Fills the values of num bytes at the destination with a single byte value.
// - dest The destination address (within the MB and bank)
// - fill The char to fill with
// - num The number of bytes to copy
// void memset_dma(__zp($c) void *dest, __register(Z) char fill, __zp($a) unsigned int num)
memset_dma: {
    .label num = $a
    .label dest = $c
    // char dmaMode = DMA->EN018B
    // Remember current F018 A/B mode
    ldx DMA+OFFSET_STRUCT_F018_DMAGIC_EN018B
    // memset_dma_command.count = num
    // Set up command
    lda.z num
    sta memset_dma_command+OFFSET_STRUCT_DMA_LIST_F018B_COUNT
    lda.z num+1
    sta memset_dma_command+OFFSET_STRUCT_DMA_LIST_F018B_COUNT+1
    // memset_dma_command.src = (char*)fill
    tza
    sta memset_dma_command+OFFSET_STRUCT_DMA_LIST_F018B_SRC
    lda #0
    sta memset_dma_command+OFFSET_STRUCT_DMA_LIST_F018B_SRC+1
    // memset_dma_command.dest = dest
    lda.z dest
    sta memset_dma_command+OFFSET_STRUCT_DMA_LIST_F018B_DEST
    lda.z dest+1
    sta memset_dma_command+OFFSET_STRUCT_DMA_LIST_F018B_DEST+1
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
    // DMA-> ADDRMSB = BYTE1(&memset_dma_command)
    lda #>memset_dma_command
    sta DMA+OFFSET_STRUCT_F018_DMAGIC_ADDRMSB
    // DMA-> ADDRLSBTRIG = BYTE0(&memset_dma_command)
    // Trigger the DMA (without option lists)
    lda #<memset_dma_command
    sta DMA
    // DMA->EN018B = dmaMode
    // Re-enable F018A mode
    stx DMA+OFFSET_STRUCT_F018_DMAGIC_EN018B
    // }
    rts
}
// Set a memory block anywhere in the entire 256MB memory space using MEGA65 DMagic DMA
// Sets the values of num bytes to the memory block pointed to by destination.
// - dest_mb The MB value for the destination (0-255)
// - dest_bank The 64KB bank for the destination (0-15)
// - dest The destination address (within the MB and bank)
// - num The number of bytes to copy
// void memset_dma256(char dest_mb, char dest_bank, void *dest, char fill, unsigned int num)
memset_dma256: {
    .const dest_mb = $ff
    .const dest_bank = 8
    .const num = $2d*$19*2
    .label dest = 0
    .label f018b = memset_dma_command256+4
    // char dmaMode = DMA->EN018B
    // Remember current F018 A/B mode
    ldx DMA+OFFSET_STRUCT_F018_DMAGIC_EN018B
    // memset_dma_command256[1] = dest_mb
    // Set up command
    lda #dest_mb
    sta memset_dma_command256+1
    // f018b->count = num
    lda #<num
    sta f018b+OFFSET_STRUCT_DMA_LIST_F018B_COUNT
    lda #>num
    sta f018b+OFFSET_STRUCT_DMA_LIST_F018B_COUNT+1
    // f018b->dest_bank = dest_bank
    lda #dest_bank
    sta f018b+OFFSET_STRUCT_DMA_LIST_F018B_DEST_BANK
    // f018b->dest = dest
    lda #<dest
    sta f018b+OFFSET_STRUCT_DMA_LIST_F018B_DEST
    lda #>dest
    sta f018b+OFFSET_STRUCT_DMA_LIST_F018B_DEST+1
    // f018b->src = (char*)fill
    // Set fill byte
    lda #<WHITE
    sta f018b+OFFSET_STRUCT_DMA_LIST_F018B_SRC
    lda #>WHITE
    sta f018b+OFFSET_STRUCT_DMA_LIST_F018B_SRC+1
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
    // DMA-> ADDRMSB = BYTE1(memset_dma_command256)
    lda #>memset_dma_command256
    sta DMA+OFFSET_STRUCT_F018_DMAGIC_ADDRMSB
    // DMA-> ETRIG = BYTE0(memset_dma_command256)
    // Trigger the DMA (with option lists)
    lda #<memset_dma_command256
    sta DMA+OFFSET_STRUCT_F018_DMAGIC_ETRIG
    // DMA->EN018B = dmaMode
    // Re-enable F018A mode
    stx DMA+OFFSET_STRUCT_F018_DMAGIC_EN018B
    // }
    rts
}
.segment Data
  // DMA list entry with options for setting data in the 256MB memory space
  // Contains DMA options options for setting MB followed by DMA_LIST_F018B struct.
  memset_dma_command256: .byte DMA_OPTION_DEST_MB, 0, DMA_OPTION_FORMAT_F018B, DMA_OPTION_END, DMA_COMMAND_FILL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  // A logo in column-wide linear single-color memory layout
LOGO:
.var pic = LoadPicture("camelot.png", List().add($ffffff, $000000))
	.for (var x=0;x<45; x++)
    	.for (var y=0; y<25*8; y++)
            .byte pic.getSinglecolorByte(x,y)

  // DMA list entry for filling data
  memset_dma_command: .byte DMA_COMMAND_FILL
  .word 0, 0
  .byte 0
  .word 0
  .byte 0, 0
  .word 0
