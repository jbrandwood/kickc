//#pragma emulator("java -jar /Applications/Nintaco_bin_2020-05-01/Nintaco.jar")
// Nintendo Entertainment System (NES
// https://en.wikipedia.org/wiki/Nintendo_Entertainment_System_(Model_NES-101)
// https://github.com/gregkrsak/first_nes
// Ricoh 2C02 - NES Picture Processing Unit (PPU)
// Ricoh RP2C02 (NTSC version) / RP2C07 (PAL version),
// https://en.wikipedia.org/wiki/Picture_Processing_Unit
// https://wiki.nesdev.com/w/index.php/PPU_registers
// http://nesdev.com/2C02%20technical%20reference.TXT
// Based on: https://github.com/gregkrsak/first_nes written by Greg M. Krsak, 2018. 
  // Nintendo Entertainment System (NES) ROM (Mapper 0 NROM, Vertical Mirroring)
// https://sadistech.com/nesromtool/romdoc.html
// https://forums.nesdev.com/viewtopic.php?f=2&t=9896
// https://github.com/gregkrsak/first_nes
.file [name="kickballs-2.nes", type="bin", segments="NesRom"]
.file [name="kickballs-2.nes_hdr", type="bin", segments="Header"]
.file [name="kickballs-2.nes_prg", type="bin", segments="ProgramRom"]
.file [name="kickballs-2.nes_chr", type="bin", segments="CharacterRom"]
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
.segment Code

  .const OFFSET_STRUCT_RICOH_2A03_DMC_FREQ = $10
  .const OFFSET_STRUCT_RICOH_2C02_PPUMASK = 1
  .const OFFSET_STRUCT_RICOH_2C02_PPUSTATUS = 2
  .const OFFSET_STRUCT_RICOH_2C02_OAMADDR = 3
  .const OFFSET_STRUCT_RICOH_2A03_OAMDMA = $14
  .const OFFSET_STRUCT_RICOH_2C02_PPUADDR = 6
  .const OFFSET_STRUCT_RICOH_2C02_PPUDATA = 7
  .const OFFSET_STRUCT_SPRITEDATA_TILE = 1
  .const OFFSET_STRUCT_SPRITEDATA_ATTRIBUTES = 2
  .const OFFSET_STRUCT_SPRITEDATA_X = 3
  .const OFFSET_STRUCT_RICOH_2C02_PPUSCROLL = 5
  .const SIZEOF_BYTE = 1
  // $2000-$23bf	$03c0	Name table 0
  .label PPU_NAME_TABLE_0 = $2000
  // $23c0-$23ff	$0040	Attribute table 0
  .label PPU_ATTRIBUTE_TABLE_0 = $23c0
  // $3000-$3eff	$0f00	Mirrors of $2000-$2eff
  // $3f00-$3f1f	$0020	Palette RAM indexes
  .label PPU_PALETTE = $3f00
  // PPU Status Register for reading in ASM
  .label PPU_PPUSTATUS = $2002
  // APU Frame Counter
  // generates low-frequency clocks for the channels and an optional 60 Hz interrupt.
  // https://wiki.nesdev.com/w/index.php/APU_Frame_Counter
  // ------+-----+---------------------------------------------------------------
  //  $4017 |	 W  | FR_COUNTER Frame Counter	Set mode and interrupt
  //  ------+-----+---------------------------------------------------------------
  //        |   7	| Sequencer mode: 0 selects 4-step sequence, 1 selects 5-step sequence
  //        |   6	| Interrupt inhibit flag. If set, the frame interrupt flag is cleared, otherwise it is unaffected.
  //  ------+-----+---------------------------------------------------------------
  // Side effects	After 3 or 4 CPU clock cycles*, the timer is reset.
  // If the mode flag is set, then both "quarter frame" and "half frame" signals are also generated.
  .label FR_COUNTER = $4017
  // Pointer to the start of RAM memory
  .label MEMORY = 0
  // NES Picture Processing Unit (PPU)
  .label PPU = $2000
  // NES CPU and audion processing unit (APU)
  .label APU = $4000
  .label scroll_y = $a
  .label vblank_hit = $b
  // The random state variable
  .label rand_state = 8
.segment Code
__start: {
    // scroll_y = 0
    lda #0
    sta.z scroll_y
    // vblank_hit = 0
    sta.z vblank_hit
    jsr main
    rts
}
// NMI Called when the PPU refreshes the screen (also known as the V-Blank period)
vblank: {
    pha
    txa
    pha
    tya
    pha
    // PPU->PPUSCROLL = 0
    // Set scroll
    lda #0
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUSCROLL
    // PPU->PPUSCROLL = scroll_y
    lda.z scroll_y
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUSCROLL
    // PPU->OAMADDR = 0
    lda #0
    sta PPU+OFFSET_STRUCT_RICOH_2C02_OAMADDR
    // APU->OAMDMA = >spriteBuffer
    lda #>SPRITE_BUFFER
    sta APU+OFFSET_STRUCT_RICOH_2A03_OAMDMA
    // vblank_hit++;
    inc.z vblank_hit
    // }
    pla
    tay
    pla
    tax
    pla
    rti
}
main: {
    .label __9 = $1a
    .label __10 = $1a
    .label __11 = $1a
    .label __20 = $d
    .label __23 = $f
    .label __25 = $11
    .label __26 = $13
    .label __31 = $14
    .label __32 = $16
    .label __33 = $18
    .label __56 = $14
    .label i = 2
    .label timer_2 = 3
    .label h_bar = $c
    .label active_balls = 4
    .label sprite_idx = 7
    .label i_1 = 6
    .label timer = 5
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
    // ppuDataTransfer(PPU_PALETTE, palette, sizeof(palette))
  // Transfer the palette
    lda #<palette
    sta.z ppuDataTransfer.cpuData
    lda #>palette
    sta.z ppuDataTransfer.cpuData+1
    lda #<PPU_PALETTE
    sta.z ppuDataTransfer.ppuDataPrepare1_ppuData
    lda #>PPU_PALETTE
    sta.z ppuDataTransfer.ppuDataPrepare1_ppuData+1
    jsr ppuDataTransfer
    // ppuDataFill(PPU_NAME_TABLE_0, 0, 32*30)
  // Fill the PPU attribute table
    lda #<$20*$1e
    sta.z ppuDataFill.size
    lda #>$20*$1e
    sta.z ppuDataFill.size+1
    lda #<PPU_NAME_TABLE_0
    sta.z ppuDataFill.ppuDataPrepare1_ppuData
    lda #>PPU_NAME_TABLE_0
    sta.z ppuDataFill.ppuDataPrepare1_ppuData+1
    jsr ppuDataFill
    // ppuDataFill(PPU_ATTRIBUTE_TABLE_0, 0, 0x40)
    lda #<$40
    sta.z ppuDataFill.size
    lda #>$40
    sta.z ppuDataFill.size+1
    lda #<PPU_ATTRIBUTE_TABLE_0
    sta.z ppuDataFill.ppuDataPrepare1_ppuData
    lda #>PPU_ATTRIBUTE_TABLE_0
    sta.z ppuDataFill.ppuDataPrepare1_ppuData+1
    jsr ppuDataFill
    // ppuDataTransfer(0x2040, h_bar_tilemap, sizeof(h_bar_tilemap))
    lda #<h_bar_tilemap
    sta.z ppuDataTransfer.cpuData
    lda #>h_bar_tilemap
    sta.z ppuDataTransfer.cpuData+1
    lda #<$2040
    sta.z ppuDataTransfer.ppuDataPrepare1_ppuData
    lda #>$2040
    sta.z ppuDataTransfer.ppuDataPrepare1_ppuData+1
    jsr ppuDataTransfer
    // PPU->PPUCTRL = 0b10000000
    lda #$80
    sta PPU
    // PPU->PPUMASK = 0b00011110
    lda #$1e
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUMASK
    // PPU->PPUCTRL = 0b10001000
    // Enable vertical blank interrupt, select sprite pattern table 1
    lda #$88
    sta PPU
    lda #<1
    sta.z rand_state
    lda #>1
    sta.z rand_state+1
    sta.z i
  __b1:
    // for (i = 0; i < MAX_BALLS; i++)
    lda.z i
    cmp #$20
    bcs !__b2+
    jmp __b2
  !__b2:
    lda #0
    sta.z timer
    sta.z active_balls
    sta.z timer_2
  __b4:
    // timer_2++;
    inc.z timer_2
    // h_bar = sine_table[timer_2] + 0x60
    lda #$60
    ldy.z timer_2
    clc
    adc sine_table,y
    sta.z h_bar
    // h_bar ^ 0xFF
    lda #$ff
    eor.z h_bar
    // scroll_y = h_bar ^ 0xFF
    sta.z scroll_y
    // if (active_balls < MAX_BALLS)
    lda.z active_balls
    cmp #$20
    bcs __b5
    // if (timer++ == RELEASE_TIMER)
    ldx.z timer
    inx
    lda #9
    cmp.z timer
    beq !__b25+
    jmp __b25
  !__b25:
    // active_balls++;
    inc.z active_balls
    // balls[active_balls].x_position = 0
    lda.z active_balls
    asl
    asl
    asl
    tax
    lda #0
    sta balls,x
    sta balls+1,x
    // balls[active_balls].y_position = 0
    sta balls+2,x
    sta balls+2+1,x
    sta.z timer
  __b5:
    lda #0
    sta.z sprite_idx
    sta.z i_1
  __b6:
    // for (i = 0; i < active_balls; i++)
    lda.z i_1
    cmp.z active_balls
    bcc __b7
    // poke(0x2001) = 0x98
    lda #$98
    sta $2001
  __b13:
    // while (!vblank_hit)
    lda #0
    cmp.z vblank_hit
    beq __b13
    // vblank_hit = 0
    // wait for vblank
    sta.z vblank_hit
    // poke(0x2001) = 0x18
    lda #$18
    sta $2001
    jmp __b4
  __b7:
    // balls[i].x_position += balls[i].x_velocity
    lda.z i_1
    asl
    asl
    asl
    tay
    clc
    lda balls,y
    adc balls+4,y
    sta balls,y
    lda balls+1,y
    adc balls+4+1,y
    sta balls+1,y
    // balls[i].y_velocity += WEIGHT
    clc
    lda balls+6,y
    adc #$10
    sta balls+6,y
    lda balls+6+1,y
    adc #0
    sta balls+6+1,y
    // balls[i].y_position += (balls[i].y_velocity += WEIGHT)
    clc
    lda balls+2,y
    adc balls+6,y
    sta balls+2,y
    lda balls+2+1,y
    adc balls+6+1,y
    sta balls+2+1,y
    // balls[i].x_position >> 8
    lda #0
    sta.z __20+1
    lda balls+1,y
    sta.z __20
    // if ((balls[i].x_position >> 8) < 8)
    lda.z __20+1
    bne __b9
    lda.z __20
    cmp #8
    bcs __b9
  !:
    // balls[i].x_velocity ^= 0xFFFF
    lda.z i_1
    asl
    asl
    asl
    tay
    lda balls+4,y
    eor #<$ffff
    sta balls+4,y
    lda balls+4+1,y
    eor #>$ffff
    sta balls+4+1,y
  __b9:
    // balls[i].y_position >> 8
    lda.z i_1
    asl
    asl
    asl
    tay
    lda #0
    sta.z __23+1
    lda balls+2+1,y
    sta.z __23
    lda #0
    sta.z __25+1
    lda balls+2+1,y
    sta.z __25
    // h_bar + 8
    lax.z h_bar
    axs #-[8]
    stx.z __26
    // if (((balls[i].y_position >> 8) >= h_bar) && (balls[i].y_position >> 8) < h_bar + 8)
    lda.z __23+1
    bne !+
    lda.z __23
    cmp.z h_bar
    bcc __b10
  !:
    lda.z __25+1
    bne __b10
    lda.z __25
    cmp.z __26
    bcs __b10
  !:
    // balls[i].y_velocity ^= 0xFFFF
    lda.z i_1
    asl
    asl
    asl
    tay
    lda balls+6,y
    eor #<$ffff
    sta balls+6,y
    lda balls+6+1,y
    eor #>$ffff
    sta balls+6+1,y
    // h_bar - 2
    lda.z h_bar
    sec
    sbc #2
    // (unsigned short)(h_bar - 2) << 8
    sta.z __56
    lda #0
    sta.z __56+1
    lda.z __31
    sta.z __31+1
    lda #0
    sta.z __31
    // balls[i].y_position = ((unsigned short)(h_bar - 2) << 8)
    sta balls+2,y
    lda.z __31+1
    sta balls+2+1,y
  __b10:
    // balls[i].y_position >> 8
    lda.z i_1
    asl
    asl
    asl
    tay
    lda #0
    sta.z __32+1
    lda balls+2+1,y
    sta.z __32
    // SPRITE_BUFFER[sprite_idx].y = (unsigned char) (balls[i].y_position >> 8)
    lda.z sprite_idx
    asl
    asl
    tax
    lda.z __32
    sta SPRITE_BUFFER,x
    // SPRITE_BUFFER[sprite_idx].tile = 0x0a
    lda #$a
    sta SPRITE_BUFFER+OFFSET_STRUCT_SPRITEDATA_TILE,x
    // SPRITE_BUFFER[sprite_idx].attributes = 3
    lda #3
    sta SPRITE_BUFFER+OFFSET_STRUCT_SPRITEDATA_ATTRIBUTES,x
    // balls[i].x_position >> 8
    lda #0
    sta.z __33+1
    lda balls+1,y
    sta.z __33
    // SPRITE_BUFFER[sprite_idx].x = (unsigned char) (balls[i].x_position >> 8)
    sta SPRITE_BUFFER+OFFSET_STRUCT_SPRITEDATA_X,x
    // sprite_idx++;
    inc.z sprite_idx
    // for (i = 0; i < active_balls; i++)
    inc.z i_1
    jmp __b6
  __b25:
    stx.z timer
    jmp __b5
  __b2:
    // rand()
    jsr rand
    // rand()
    // rand() & 0x3FF
    lda.z __10
    and #<$3ff
    sta.z __10
    lda.z __10+1
    and #>$3ff
    sta.z __10+1
    // balls[i].x_velocity = rand() & 0x3FF
    lda.z i
    asl
    asl
    asl
    tay
    lda.z __10
    sta balls+4,y
    lda.z __10+1
    sta balls+4+1,y
    // rand()
    jsr rand
    // rand()
    // rand() & 0x0FF
    lda #$ff
    and.z __11
    tax
    // balls[i].y_velocity = rand() & 0x0FF
    lda.z i
    asl
    asl
    asl
    tay
    txa
    sta balls+6,y
    // for (i = 0; i < MAX_BALLS; i++)
    inc.z i
    jmp __b1
}
// Transfer a number of bytes from the CPU memory to the PPU memory
// - ppuData : Pointer in the PPU memory
// - cpuData : Pointer to the CPU memory (RAM of ROM)
// - size : The number of bytes to transfer
// ppuDataTransfer(void* zp($f) cpuData)
ppuDataTransfer: {
    .label ppuDataPrepare1_ppuData = $d
    .label cpuSrc = $f
    .label i = $11
    .label cpuData = $f
    // >ppuData
    lda.z ppuDataPrepare1_ppuData+1
    // PPU->PPUADDR = >ppuData
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    // <ppuData
    lda.z ppuDataPrepare1_ppuData
    // PPU->PPUADDR = <ppuData
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    // for(unsigned int i=0;i<size;i++)
    lda.z i+1
    bne !+
    lda.z i
    cmp #$20*SIZEOF_BYTE
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
// ppuDataFill(word zp($f) size)
ppuDataFill: {
    .label ppuDataPrepare1_ppuData = $d
    .label i = $11
    .label size = $f
    // >ppuData
    lda.z ppuDataPrepare1_ppuData+1
    // PPU->PPUADDR = >ppuData
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    // <ppuData
    lda.z ppuDataPrepare1_ppuData
    // PPU->PPUADDR = <ppuData
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
    lda #0
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUDATA
    // for(unsigned int i=0;i<size;i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
// Returns a pseudo-random number in the range of 0 to RAND_MAX (65535)
// Uses an xorshift pseudorandom number generator that hits all different values
// Information https://en.wikipedia.org/wiki/Xorshift
// Source http://www.retroprogramming.com/2017/07/xorshift-pseudorandom-numbers-in-z80.html
rand: {
    .label __0 = $1c
    .label __1 = $1e
    .label __2 = $20
    .label return = $1a
    // rand_state << 7
    lda.z rand_state+1
    lsr
    lda.z rand_state
    ror
    sta.z __0+1
    lda #0
    ror
    sta.z __0
    // rand_state ^= rand_state << 7
    lda.z rand_state
    eor.z __0
    sta.z rand_state
    lda.z rand_state+1
    eor.z __0+1
    sta.z rand_state+1
    // rand_state >> 9
    lsr
    sta.z __1
    lda #0
    sta.z __1+1
    // rand_state ^= rand_state >> 9
    lda.z rand_state
    eor.z __1
    sta.z rand_state
    lda.z rand_state+1
    eor.z __1+1
    sta.z rand_state+1
    // rand_state << 8
    lda.z rand_state
    sta.z __2+1
    lda #0
    sta.z __2
    // rand_state ^= rand_state << 8
    lda.z rand_state
    eor.z __2
    sta.z rand_state
    lda.z rand_state+1
    eor.z __2+1
    sta.z rand_state+1
    // return rand_state;
    lda.z rand_state
    sta.z return
    lda.z rand_state+1
    sta.z return+1
    // }
    rts
}
.segment GameRam
  // Moving balls (in GameRAM)
  balls: .fill 8*$40, 0
.segment Data
  sine_table: .byte $40, $42, $43, $45, $46, $48, $49, $4b, $4c, $4e, $50, $51, $53, $54, $56, $57, $58, $5a, $5b, $5d, $5e, $60, $61, $62, $64, $65, $66, $67, $69, $6a, $6b, $6c, $6d, $6e, $6f, $70, $71, $72, $73, $74, $75, $76, $77, $78, $78, $79, $7a, $7b, $7b, $7c, $7c, $7d, $7d, $7e, $7e, $7e, $7f, $7f, $7f, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $7f, $7f, $7f, $7e, $7e, $7e, $7d, $7d, $7c, $7c, $7b, $7b, $7a, $79, $78, $78, $77, $76, $75, $74, $73, $72, $71, $70, $6f, $6e, $6d, $6c, $6b, $6a, $69, $67, $66, $65, $64, $62, $61, $60, $5e, $5d, $5b, $5a, $58, $57, $56, $54, $53, $51, $50, $4e, $4c, $4b, $49, $48, $46, $45, $43, $42, $40, $3e, $3d, $3b, $3a, $38, $37, $35, $34, $32, $30, $2f, $2d, $2c, $2a, $29, $28, $26, $25, $23, $22, $20, $1f, $1e, $1c, $1b, $1a, $19, $17, $16, $15, $14, $13, $12, $11, $10, $f, $e, $d, $c, $b, $a, 9, 8, 8, 7, 6, 5, 5, 4, 4, 3, 3, 2, 2, 2, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 4, 4, 5, 5, 6, 7, 8, 8, 9, $a, $b, $c, $d, $e, $f, $10, $11, $12, $13, $14, $15, $16, $17, $19, $1a, $1b, $1c, $1e, $1f, $20, $22, $23, $25, $26, $28, $29, $2a, $2c, $2d, $2f, $30, $32, $34, $35, $37, $38, $3a, $3b, $3d, $3e
  palette: .byte $34, $24, $14, 4, $34, $24, $14, 4, $34, $24, $14, 4, $34, $24, $14, 4, $34, $24, $14, 4, $34, $24, $14, 4, $34, $24, $14, 4, $34, $24, $14, 4
  h_bar_tilemap: .byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
.segment Tiles
TILES:
.import binary "lazydata.chr"

.segment GameRam
  .align $100
  SPRITE_BUFFER: .fill 4*$100, 0
.segment Vectors
  VECTORS: .word vblank, main, 0
