// SID music located in another bank being played in a raster IRQ using memory mapping on the MEGA65
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
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  // Bits for the VICII IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  // DMA command copy
  .const DMA_COMMAND_COPY = 0
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // RAM in 0xA000, 0xE000 I/O in 0xD000
  .const PROCPORT_RAM_IO = 5
  .const OFFSET_STRUCT_F018_DMAGIC_EN018B = 3
  .const OFFSET_STRUCT_DMA_LIST_F018B_COUNT = 1
  .const OFFSET_STRUCT_DMA_LIST_F018B_SRC = 3
  .const OFFSET_STRUCT_DMA_LIST_F018B_DEST = 6
  .const OFFSET_STRUCT_F018_DMAGIC_ADDRMB = 4
  .const OFFSET_STRUCT_F018_DMAGIC_ADDRBANK = 2
  .const OFFSET_STRUCT_F018_DMAGIC_ADDRMSB = 1
  .const OFFSET_STRUCT_DMA_LIST_F018B_SRC_BANK = 5
  .const OFFSET_STRUCT_DMA_LIST_F018B_DEST_BANK = 8
  .const OFFSET_STRUCT_MOS4569_VICIII_KEY = $2f
  .const OFFSET_STRUCT_MEGA65_VICIV_CONTROLB = $31
  .const OFFSET_STRUCT_MEGA65_VICIV_CONTROLC = $54
  .const OFFSET_STRUCT_MEGA65_VICIV_SIDBDRWD_LO = $5c
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  .const OFFSET_STRUCT_MOS6569_VICII_RASTER = $12
  .const OFFSET_STRUCT_MOS6569_VICII_CONTROL1 = $11
  .const OFFSET_STRUCT_MOS6569_VICII_IRQ_ENABLE = $1a
  .const OFFSET_STRUCT_MOS6569_VICII_IRQ_STATUS = $19
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // The VIC-II MOS 6567/6569
  .label VICII = $d000
  // The VIC III MOS 4567/4569
  .label VICIII = $d000
  // The VIC IV
  .label VICIV = $d000
  // DMAgic F018 Controller
  .label DMA = $d700
  // Default address of screen character matrix
  .label DEFAULT_SCREEN = $800
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  // The vector used when the HARDWARE serves IRQ interrupts
  .label HARDWARE_IRQ = $fffe
  // Address after the end of the music
  .label MUSIC_END = $5200
  // Pointer to the music init routine
  .label musicInit = MUSIC
  // Pointer to the music play routine
  .label musicPlay = MUSIC+3
.segment Code
// Raster IRQ routine
irq: {
    pha
    phx
    phy
    phz
    // VICII->IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_IRQ_STATUS
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
    // raster = VICII->RASTER
    // Wait for the next raster line
    lda VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
  __b1:
    // while(VICII->RASTER==raster)
    cmp VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    beq __b1
    // (VICII->BORDER_COLOR)--;
    dec VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // }
    plz
    ply
    plx
    pla
    rti
}
main: {
    // asm
    // Stop IRQ's
    sei
    // memoryRemap(0,0,0)
  // Map memory to BANK 0 : 0x00XXXX - giving access to I/O
    lda #<0
    sta.z memoryRemap.upperPageOffset
    sta.z memoryRemap.upperPageOffset+1
    ldz #0
    sta.z memoryRemap.lowerPageOffset
    sta.z memoryRemap.lowerPageOffset+1
    jsr memoryRemap
    // VICIII->KEY = 0x47
    // Enable MEGA65 features
    lda #$47
    sta VICIII+OFFSET_STRUCT_MOS4569_VICIII_KEY
    // VICIII->KEY = 0x53
    lda #$53
    sta VICIII+OFFSET_STRUCT_MOS4569_VICIII_KEY
    // VICIV->CONTROLB |= 0x40
    // Enable 48MHz fast mode
    lda #$40
    ora VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLB
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLB
    // VICIV->CONTROLC |= 0x40
    lda #$40
    ora VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLC
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLC
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // no kernal or BASIC rom visible
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // VICIV->SIDBDRWD_LO = 1
    // open sideborder
    lda #1
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_SIDBDRWD_LO
    // memcpy_dma4(1, 0x0000, 0, upperCodeData, MUSIC_END-MUSIC)
    // Transfer banked code/data to upper memory ($10000)
    jsr memcpy_dma4
    // memoryRemapBlock(0x40, 0x100)
  // Remap [$4000-$5fff] to point to [$10000-$11fff]
    jsr memoryRemapBlock
    // asm
    // Initialize SID 
    lda #0
    // (*musicInit)()
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
    // CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR
    // Set up raster interrupts C64 style
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_INTERRUPT
    // VICII->RASTER = 0xff
    // Set raster line to 0xff
    lda #$ff
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    // VICII->CONTROL1 &= 0x7f
    lda #$7f
    and VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    // VICII->IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_IRQ_ENABLE
    // *HARDWARE_IRQ = &irq
    // Set the IRQ routine
    lda #<irq
    sta HARDWARE_IRQ
    lda #>irq
    sta HARDWARE_IRQ+1
    // asm
    // Enable IRQ
    cli
    ldx #0
  __b1:
    // MUSIC[mem_destroy_i++]++;
    inc MUSIC,x
    inx
    ldy #0
  // Show unmapped MUSIC memory
  __b2:
    // for(char i=0;i<240;i++)
    cpy #$f0
    bcc __b3
    jmp __b1
  __b3:
    // DEFAULT_SCREEN[i] = MUSIC[i]
    lda MUSIC,y
    sta DEFAULT_SCREEN,y
    // for(char i=0;i<240;i++)
    iny
    jmp __b2
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
// memoryRemap(byte register(Z) remapBlocks, word zp(2) lowerPageOffset, word zp(4) upperPageOffset)
memoryRemap: {
    .label aVal = $fc
    .label xVal = $fd
    .label yVal = $fe
    .label zVal = $ff
    .label __1 = 6
    .label __6 = 7
    .label lowerPageOffset = 2
    .label upperPageOffset = 4
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
// Copy a memory block anywhere in first 4MB memory space using MEGA65 DMagic DMA
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// - dest_bank The 64KB bank for the destination (0-63)
// - dest The destination address (within the MB and bank)
// - src_bank The 64KB bank for the source (0-63)
// - src The source address (within the MB and bank)
// - num The number of bytes to copy
memcpy_dma4: {
    .const num = MUSIC_END-MUSIC
    .const dest_bank = 1
    .const src_bank = 0
    .label dest = 0
    .label src = upperCodeData
    // dmaMode = DMA->EN018B
    // Remember current F018 A/B mode
    ldx DMA+OFFSET_STRUCT_F018_DMAGIC_EN018B
    // memcpy_dma_command4.count = num
    // Set up command
    lda #<num
    sta memcpy_dma_command4+OFFSET_STRUCT_DMA_LIST_F018B_COUNT
    lda #>num
    sta memcpy_dma_command4+OFFSET_STRUCT_DMA_LIST_F018B_COUNT+1
    // memcpy_dma_command4.src_bank = src_bank
    lda #src_bank
    sta memcpy_dma_command4+OFFSET_STRUCT_DMA_LIST_F018B_SRC_BANK
    // memcpy_dma_command4.src = src
    lda #<src
    sta memcpy_dma_command4+OFFSET_STRUCT_DMA_LIST_F018B_SRC
    lda #>src
    sta memcpy_dma_command4+OFFSET_STRUCT_DMA_LIST_F018B_SRC+1
    // memcpy_dma_command4.dest_bank = dest_bank
    lda #dest_bank
    sta memcpy_dma_command4+OFFSET_STRUCT_DMA_LIST_F018B_DEST_BANK
    // memcpy_dma_command4.dest = dest
    lda #<dest
    sta memcpy_dma_command4+OFFSET_STRUCT_DMA_LIST_F018B_DEST
    lda #>dest
    sta memcpy_dma_command4+OFFSET_STRUCT_DMA_LIST_F018B_DEST+1
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
    // DMA-> ADDRMSB = >&memcpy_dma_command4
    lda #>memcpy_dma_command4
    sta DMA+OFFSET_STRUCT_F018_DMAGIC_ADDRMSB
    // DMA-> ADDRLSBTRIG = <&memcpy_dma_command4
    // Trigger the DMA (without option lists)
    lda #<memcpy_dma_command4
    sta DMA
    // DMA->EN018B = dmaMode
    // Re-enable F018A mode
    stx DMA+OFFSET_STRUCT_F018_DMAGIC_EN018B
    // }
    rts
}
.segment Data
  // Array containing the banked upper memory code/data to be transferred to upper memory before execution
upperCodeData:
.segmentout [segments="Banked"]

  // DMA list entry for copying data in the 1MB memory space
  memcpy_dma_command4: .byte DMA_COMMAND_COPY
  .word 0, 0
  .byte 0
  .word 0
  .byte 0, 0
  .word 0
.segment DataBanked
.pc = $4000 "MUSIC"
// SID tune at an absolute address
MUSIC:
.const music = LoadSid("Cybernoid_II_4000.sid")
    .fill music.size, music.getData(i)

