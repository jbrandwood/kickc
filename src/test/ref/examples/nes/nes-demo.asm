// A minimal NES demo
// Based on: https://github.com/gregkrsak/first_nes written by Greg M. Krsak, 2018. 
/// @file
/// Nintendo Entertainment System (NES
///
/// https://en.wikipedia.org/wiki/Nintendo_Entertainment_System_(Model_NES-101)
/// https://github.com/gregkrsak/first_nes
/// @file
/// Ricoh 2C02 - NES Picture Processing Unit (PPU)
///
/// Ricoh RP2C02 (NTSC version) / RP2C07 (PAL version),
/// https://en.wikipedia.org/wiki/Picture_Processing_Unit
/// https://wiki.nesdev.com/w/index.php/PPU_registers
/// http://nesdev.com/2C02%20technical%20reference.TXT
/// Based on: https://github.com/gregkrsak/first_nes written by Greg M. Krsak, 2018.
.cpu _6502
  // Nintendo Entertainment System (NES) ROM (Mapper 0 NROM, Vertical Mirroring)
// https://sadistech.com/nesromtool/romdoc.html
// https://forums.nesdev.com/viewtopic.php?f=2&t=9896
// https://github.com/gregkrsak/first_nes
.file [name="nes-demo.nes", type="bin", segments="NesRom"]
.file [name="nes-demo.nes_hdr", type="bin", segments="Header"]
.file [name="nes-demo.nes_prg", type="bin", segments="ProgramRom"]
.file [name="nes-demo.nes_chr", type="bin", segments="CharacterRom"]
.segmentdef Header  [ start=$0000,       min=$0000, max=$000f, fill ]
.segmentdef Tiles   [ start=$0000,       min=$0000, max=$1fff, fill ]
.segmentdef Code    [ start=$c000,       min=$c000, max=$fff9 ]
.segmentdef Data    [ startAfter="Code", min=$c000, max=$fff9 ]
.segmentdef Vectors [ start=$fffa,       min=$fffa, max=$ffff ]
.segmentdef GameRam [start=$200,max=$7ff, virtual]
.segmentdef ProgramRom [ segments="Code, Data, Vectors" ]
.segmentdef CharacterRom [ segments="Tiles" ]
.segmentdef NesRom
.segment NesRom
.segmentout [ segments="Header" ]
.segmentout [ segments="ProgramRom" ]
.segmentout [ segments="CharacterRom" ]
.segment Header
.text   @"NES\$1a"
.byte   $01           // 1x 16KB ROM (PRG)
.byte   $01           // 1x 8KB VROM (CHR)
.byte   %00000001     // Mapper nibble 0000 == No mapping (a simple 16KB PRG + 8KB CHR game)
                      // Mirroring nibble 0001 == Vertical mirroring only
  /// Standard Controller Right Button
  .const JOY_RIGHT = 1
  /// Standard Controller Left Button
  .const JOY_LEFT = 2
  /// Standard Controller Down Button
  .const JOY_DOWN = 4
  /// Standard Controller Up Button
  .const JOY_UP = 8
  .const SIZEOF_STRUCT_SPRITEDATA = 4
  .const OFFSET_STRUCT_RICOH_2C02_OAMADDR = 3
  .const OFFSET_STRUCT_RICOH_2A03_OAMDMA = $14
  .const OFFSET_STRUCT_RICOH_2A03_DMC_FREQ = $10
  .const OFFSET_STRUCT_RICOH_2C02_PPUMASK = 1
  .const OFFSET_STRUCT_RICOH_2C02_PPUSTATUS = 2
  .const OFFSET_STRUCT_RICOH_2A03_JOY1 = $16
  .const OFFSET_STRUCT_RICOH_2C02_PPUADDR = 6
  .const OFFSET_STRUCT_RICOH_2C02_PPUDATA = 7
  .const OFFSET_STRUCT_SPRITEDATA_X = 3
  .const OFFSET_STRUCT_RICOH_2C02_PPUSCROLL = 5
  .const SIZEOF_CHAR = 1
  /// $2000-$23bf	$03c0	Name table 0
  .label PPU_NAME_TABLE_0 = $2000
  /// $23c0-$23ff	$0040	Attribute table 0
  .label PPU_ATTRIBUTE_TABLE_0 = $23c0
  /// $3000-$3eff	$0f00	Mirrors of $2000-$2eff
  /// $3f00-$3f1f	$0020	Palette RAM indexes
  .label PPU_PALETTE = $3f00
  /// PPU Status Register for reading in ASM
  .label PPU_PPUSTATUS = $2002
  /// APU Frame Counter
  /// generates low-frequency clocks for the channels and an optional 60 Hz interrupt.
  /// https://wiki.nesdev.com/w/index.php/APU_Frame_Counter
  /// ------+-----+---------------------------------------------------------------
  ///  $4017 |	 W  | FR_COUNTER Frame Counter	Set mode and interrupt
  ///  ------+-----+---------------------------------------------------------------
  ///        |   7	| Sequencer mode: 0 selects 4-step sequence, 1 selects 5-step sequence
  ///        |   6	| Interrupt inhibit flag. If set, the frame interrupt flag is cleared, otherwise it is unaffected.
  ///  ------+-----+---------------------------------------------------------------
  /// Side effects	After 3 or 4 CPU clock cycles*, the timer is reset.
  /// If the mode flag is set, then both "quarter frame" and "half frame" signals are also generated.
  .label FR_COUNTER = $4017
  /// Pointer to the start of RAM memory
  .label MEMORY = 0
  /// NES Picture Processing Unit (PPU)
  .label PPU = $2000
  /// NES CPU and audion processing unit (APU)
  .label APU = $4000
.segment Code
// NMI Called when the PPU refreshes the screen (also known as the V-Blank period)
vblank: {
    pha
    txa
    pha
    tya
    pha
    // char joy = readJoy1()
    // Read controller 1
    jsr readJoy1
    tax
    // joy&JOY_DOWN
    txa
    and #JOY_DOWN
    // if(joy&JOY_DOWN)
    cmp #0
    beq __b1
    // SPRITE_BUFFER[0].y++;
    inc SPRITE_BUFFER
    // SPRITE_BUFFER[1].y++;
    inc SPRITE_BUFFER+1*SIZEOF_STRUCT_SPRITEDATA
    // SPRITE_BUFFER[2].y++;
    inc SPRITE_BUFFER+2*SIZEOF_STRUCT_SPRITEDATA
    // SPRITE_BUFFER[3].y++;
    inc SPRITE_BUFFER+3*SIZEOF_STRUCT_SPRITEDATA
  __b1:
    // joy&JOY_UP
    txa
    and #JOY_UP
    // if(joy&JOY_UP)
    cmp #0
    beq __b2
    // SPRITE_BUFFER[0].y--;
    dec SPRITE_BUFFER
    // SPRITE_BUFFER[1].y--;
    dec SPRITE_BUFFER+1*SIZEOF_STRUCT_SPRITEDATA
    // SPRITE_BUFFER[2].y--;
    dec SPRITE_BUFFER+2*SIZEOF_STRUCT_SPRITEDATA
    // SPRITE_BUFFER[3].y--;
    dec SPRITE_BUFFER+3*SIZEOF_STRUCT_SPRITEDATA
  __b2:
    // joy&JOY_LEFT
    txa
    and #JOY_LEFT
    // if(joy&JOY_LEFT)
    cmp #0
    beq __b3
    // SPRITE_BUFFER[0].x--;
    dec SPRITE_BUFFER+OFFSET_STRUCT_SPRITEDATA_X
    // SPRITE_BUFFER[1].x--;
    dec SPRITE_BUFFER+1*SIZEOF_STRUCT_SPRITEDATA+OFFSET_STRUCT_SPRITEDATA_X
    // SPRITE_BUFFER[2].x--;
    dec SPRITE_BUFFER+2*SIZEOF_STRUCT_SPRITEDATA+OFFSET_STRUCT_SPRITEDATA_X
    // SPRITE_BUFFER[3].x--;
    dec SPRITE_BUFFER+3*SIZEOF_STRUCT_SPRITEDATA+OFFSET_STRUCT_SPRITEDATA_X
  __b3:
    // joy&JOY_RIGHT
    txa
    and #JOY_RIGHT
    // if(joy&JOY_RIGHT)
    cmp #0
    beq ppuSpriteBufferDmaTransfer1
    // SPRITE_BUFFER[0].x++;
    inc SPRITE_BUFFER+OFFSET_STRUCT_SPRITEDATA_X
    // SPRITE_BUFFER[1].x++;
    inc SPRITE_BUFFER+1*SIZEOF_STRUCT_SPRITEDATA+OFFSET_STRUCT_SPRITEDATA_X
    // SPRITE_BUFFER[2].x++;
    inc SPRITE_BUFFER+2*SIZEOF_STRUCT_SPRITEDATA+OFFSET_STRUCT_SPRITEDATA_X
    // SPRITE_BUFFER[3].x++;
    inc SPRITE_BUFFER+3*SIZEOF_STRUCT_SPRITEDATA+OFFSET_STRUCT_SPRITEDATA_X
  ppuSpriteBufferDmaTransfer1:
    // PPU->OAMADDR = 0
    lda #0
    sta PPU+OFFSET_STRUCT_RICOH_2C02_OAMADDR
    // APU->OAMDMA = BYTE1(spriteBuffer)
    lda #>SPRITE_BUFFER
    sta APU+OFFSET_STRUCT_RICOH_2A03_OAMDMA
    // PPU->PPUSCROLL = 0
    // Set scroll
    lda #0
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUSCROLL
    // PPU->PPUSCROLL = -8
    lda #-8
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUSCROLL
    // }
    pla
    tay
    pla
    tax
    pla
    rti
}
// RESET Called when the NES is reset, including when it is turned on.
main: {
    // asm
    cld
    ldx #$ff
    txs
    // PPU->PPUCTRL = 0
    lda #0
    sta PPU
    // PPU->PPUMASK = 0
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUMASK
    // *FR_COUNTER = 0b01000000
    lda #$40
    sta FR_COUNTER
    // APU->DMC_FREQ  = 0b01000000
    sta APU+OFFSET_STRUCT_RICOH_2A03_DMC_FREQ
    // asm
    lda PPU_PPUSTATUS
  initNES1_waitForVBlank1:
    // PPU->PPUSTATUS&0x80
    lda #$80
    and PPU+OFFSET_STRUCT_RICOH_2C02_PPUSTATUS
    // while(!(PPU->PPUSTATUS&0x80))
    cmp #0
    beq initNES1_waitForVBlank1
    ldx #0
  initNES1___b1:
    // (MEMORY+0x000)[i] = 0
    lda #0
    sta MEMORY,x
    // (MEMORY+0x100)[i] = 0
    sta MEMORY+$100,x
    // (MEMORY+0x200)[i] = 0
    sta MEMORY+$200,x
    // (MEMORY+0x300)[i] = 0
    sta MEMORY+$300,x
    // (MEMORY+0x400)[i] = 0
    sta MEMORY+$400,x
    // (MEMORY+0x500)[i] = 0
    sta MEMORY+$500,x
    // (MEMORY+0x600)[i] = 0
    sta MEMORY+$600,x
    // (MEMORY+0x700)[i] = 0
    sta MEMORY+$700,x
    // while (++i)
    inx
    cpx #0
    bne initNES1___b1
  initNES1_waitForVBlank2:
    // PPU->PPUSTATUS&0x80
    lda #$80
    and PPU+OFFSET_STRUCT_RICOH_2C02_PPUSTATUS
    // while(!(PPU->PPUSTATUS&0x80))
    cmp #0
    beq initNES1_waitForVBlank2
    // asm
    lda PPU_PPUSTATUS
    // ppuDataTransfer(PPU_PALETTE, PALETTE, sizeof(PALETTE))
  // Transfer the palette
    jsr ppuDataTransfer
    // ppuDataFill(PPU_NAME_TABLE_0, 0xfc, 0x3c0)
  // Clear the name table
    ldx #$fc
    lda #<$3c0
    sta.z ppuDataFill.size
    lda #>$3c0
    sta.z ppuDataFill.size+1
    lda #<PPU_NAME_TABLE_0
    sta.z ppuDataFill.ppuDataPrepare1_ppuData
    lda #>PPU_NAME_TABLE_0
    sta.z ppuDataFill.ppuDataPrepare1_ppuData+1
    jsr ppuDataFill
    // ppuDataFill(PPU_ATTRIBUTE_TABLE_0, 0, 0x40)
  // Fill the PPU attribute table
    ldx #0
    lda #<$40
    sta.z ppuDataFill.size
    lda #>$40
    sta.z ppuDataFill.size+1
    lda #<PPU_ATTRIBUTE_TABLE_0
    sta.z ppuDataFill.ppuDataPrepare1_ppuData
    lda #>PPU_ATTRIBUTE_TABLE_0
    sta.z ppuDataFill.ppuDataPrepare1_ppuData+1
    jsr ppuDataFill
    ldx #0
  // Show floor
  __b1:
    // for(char x=0;x<32;x+=2)
    cpx #$20
    bcc __b2
    // ppuDataPutTile(PPU_NAME_TABLE_0+18*32+28, FLAG)
  // Show flag
    lda #<FLAG
    sta.z ppuDataPutTile.tile
    lda #>FLAG
    sta.z ppuDataPutTile.tile+1
    lda #<PPU_NAME_TABLE_0+$12*$20+$1c
    sta.z ppuDataPutTile.ppuData
    lda #>PPU_NAME_TABLE_0+$12*$20+$1c
    sta.z ppuDataPutTile.ppuData+1
    jsr ppuDataPutTile
    // memcpy(SPRITE_BUFFER, SPRITES, sizeof(SPRITES))
  // Initialize Sprite Buffer with the SPRITE data
    jsr memcpy
    // PPU->PPUCTRL = 0b10000000
    lda #$80
    sta PPU
    // PPU->PPUMASK = 0b00011110
    lda #$1e
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUMASK
  __b3:
  // Infinite loop
    jmp __b3
  __b2:
    // PPU_NAME_TABLE_0+20*32+x
    txa
    clc
    adc #<PPU_NAME_TABLE_0+$14*$20
    sta.z ppuDataPutTile.ppuData
    lda #>PPU_NAME_TABLE_0+$14*$20
    adc #0
    sta.z ppuDataPutTile.ppuData+1
    // ppuDataPutTile(PPU_NAME_TABLE_0+20*32+x, FLOOR)
    lda #<FLOOR
    sta.z ppuDataPutTile.tile
    lda #>FLOOR
    sta.z ppuDataPutTile.tile+1
    jsr ppuDataPutTile
    // x+=2
    inx
    inx
    jmp __b1
}
// Read Standard Controller #1
// Returns a byte representing the pushed buttons
// - bit 0: right
// - bit 1: left
// - bit 2: down
// - bit 3: up
// - bit 4: start
// - bit 5: select
// - bit 6: B
// - bit 7: A
readJoy1: {
    .label __1 = 8
    // APU->JOY1 = 1
    // Latch the controller buttons
    lda #1
    sta APU+OFFSET_STRUCT_RICOH_2A03_JOY1
    // APU->JOY1 = 0
    lda #0
    sta APU+OFFSET_STRUCT_RICOH_2A03_JOY1
    tax
  __b1:
    // for(char i=0;i<8;i++)
    cpx #8
    bcc __b2
    // }
    rts
  __b2:
    // joy<<1
    asl
    sta.z __1
    // APU->JOY1&1
    lda #1
    and APU+OFFSET_STRUCT_RICOH_2A03_JOY1
    // joy = joy<<1 | APU->JOY1&1
    ora.z __1
    // for(char i=0;i<8;i++)
    inx
    jmp __b1
}
// Transfer a number of bytes from the CPU memory to the PPU memory
// - ppuData : Pointer in the PPU memory
// - cpuData : Pointer to the CPU memory (RAM of ROM)
// - size : The number of bytes to transfer
// void ppuDataTransfer(void * const ppuData, void * const cpuData, unsigned int size)
ppuDataTransfer: {
    .const size = $20*SIZEOF_CHAR
    .label ppuData = PPU_PALETTE
    .label cpuData = PALETTE
    // Transfer to PPU
    .label cpuSrc = 6
    .label i = 4
    // PPU->PPUADDR = BYTE1(ppuData)
    lda #>ppuData
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    // PPU->PPUADDR = BYTE0(ppuData)
    lda #0
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    lda #<cpuData
    sta.z cpuSrc
    lda #>cpuData
    sta.z cpuSrc+1
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    // for(unsigned int i=0;i<size;i++)
    lda.z i+1
    cmp #>size
    bcc __b2
    bne !+
    lda.z i
    cmp #<size
    bcc __b2
  !:
    // }
    rts
  __b2:
    // ppuDataPut(*cpuSrc++)
    ldy #0
    lda (cpuSrc),y
    // PPU->PPUDATA = val
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUDATA
    // ppuDataPut(*cpuSrc++);
    inc.z cpuSrc
    bne !+
    inc.z cpuSrc+1
  !:
    // for(unsigned int i=0;i<size;i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
// Fill a number of bytes in the PPU memory
// - ppuData : Pointer in the PPU memory
// - size : The number of bytes to transfer
// void ppuDataFill(void * const ppuData, __register(X) char val, __zp(6) unsigned int size)
ppuDataFill: {
    .label ppuDataPrepare1_ppuData = 4
    .label i = 2
    .label size = 6
    // BYTE1(ppuData)
    lda.z ppuDataPrepare1_ppuData+1
    // PPU->PPUADDR = BYTE1(ppuData)
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    // BYTE0(ppuData)
    lda.z ppuDataPrepare1_ppuData
    // PPU->PPUADDR = BYTE0(ppuData)
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer to PPU
  __b1:
    // for(unsigned int i=0;i<size;i++)
    lda.z i+1
    cmp.z size+1
    bcc ppuDataPut1
    bne !+
    lda.z i
    cmp.z size
    bcc ppuDataPut1
  !:
    // }
    rts
  ppuDataPut1:
    // PPU->PPUDATA = val
    stx PPU+OFFSET_STRUCT_RICOH_2C02_PPUDATA
    // for(unsigned int i=0;i<size;i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
// Transfer a 2x2 tile into the PPU memory
// - ppuData : Pointer in the PPU memory
// - tile : The tile to transfer
// void ppuDataPutTile(__zp(2) char * const ppuData, __zp(4) char *tile)
ppuDataPutTile: {
    .label ppuDataPrepare2_ppuData = 2
    .label ppuData = 2
    .label tile = 4
    // BYTE1(ppuData)
    lda.z ppuData+1
    // PPU->PPUADDR = BYTE1(ppuData)
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    // BYTE0(ppuData)
    lda.z ppuData
    // PPU->PPUADDR = BYTE0(ppuData)
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    // ppuDataPut(tile[0])
    ldy #0
    lda (tile),y
    // PPU->PPUDATA = val
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUDATA
    // ppuDataPut(tile[1])
    ldy #1
    lda (tile),y
    // PPU->PPUDATA = val
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUDATA
    // (char*)ppuData+32
    lda #$20
    clc
    adc.z ppuDataPrepare2_ppuData
    sta.z ppuDataPrepare2_ppuData
    bcc !+
    inc.z ppuDataPrepare2_ppuData+1
  !:
    // BYTE1(ppuData)
    lda.z ppuDataPrepare2_ppuData+1
    // PPU->PPUADDR = BYTE1(ppuData)
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    // BYTE0(ppuData)
    lda.z ppuDataPrepare2_ppuData
    // PPU->PPUADDR = BYTE0(ppuData)
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    // ppuDataPut(tile[2])
    ldy #2
    lda (tile),y
    // PPU->PPUDATA = val
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUDATA
    // ppuDataPut(tile[3])
    ldy #3
    lda (tile),y
    // PPU->PPUDATA = val
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUDATA
    // }
    rts
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// void * memcpy(void *destination, void *source, unsigned int num)
memcpy: {
    .const num = 8*SIZEOF_STRUCT_SPRITEDATA
    .label destination = SPRITE_BUFFER
    .label source = SPRITES
    .label src_end = source+num
    .label dst = 6
    .label src = 4
    lda #<destination
    sta.z dst
    lda #>destination
    sta.z dst+1
    lda #<source
    sta.z src
    lda #>source
    sta.z src+1
  __b1:
    // while(src!=src_end)
    lda.z src+1
    cmp #>src_end
    bne __b2
    lda.z src
    cmp #<src_end
    bne __b2
    // }
    rts
  __b2:
    // *dst++ = *src++
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    inc.z src
    bne !+
    inc.z src+1
  !:
    jmp __b1
}
.segment Data
  // Flag tile
  FLAG: .byte $54, $55, $56, $57
  // Floor tile
  FLOOR: .byte $85, $85, $86, $86
  // Sprite Data
  SPRITES: .byte $96, $36, 2, $c, $96, $37, 2, $14, $9e, $38, 2, $c, $9e, $39, 2, $14, $96, $70, 0, $48, $96, $71, 0, $50, $9e, $72, 1, $48, $9e, $73, 1, $50
  // Color Palette
  PALETTE: .byte $11, $2d, 8, $18, $11, 6, $15, $36, $11, $39, $4a, $5b, $f, $3d, $4e, $5f, $11, $f, $30, 8, $11, $f, $18, 8, $11, $30, $37, $1a, $f, $f, $f, $f
.segment Tiles
TILES:
.import binary "smb1_chr.bin"

.segment GameRam
  .align $100
  SPRITE_BUFFER: .fill 4*$40, 0
.segment Vectors
  VECTORS: .word vblank, main, 0
