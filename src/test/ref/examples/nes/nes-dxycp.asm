// NES DXYCP using sprites
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
.file [name="nes-dxycp.nes", type="bin", segments="NesRom"]
.file [name="nes-dxycp.nes_hdr", type="bin", segments="Header"]
.file [name="nes-dxycp.nes_prg", type="bin", segments="ProgramRom"]
.file [name="nes-dxycp.nes_chr", type="bin", segments="CharacterRom"]
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
  .const OFFSET_STRUCT_SPRITEDATA_TILE = 1
  .const OFFSET_STRUCT_SPRITEDATA_ATTRIBUTES = 2
  .const OFFSET_STRUCT_SPRITEDATA_X = 3
  .const OFFSET_STRUCT_RICOH_2C02_OAMADDR = 3
  .const OFFSET_STRUCT_RICOH_2A03_OAMDMA = $14
  .const OFFSET_STRUCT_RICOH_2A03_DMC_FREQ = $10
  .const OFFSET_STRUCT_RICOH_2C02_PPUMASK = 1
  .const OFFSET_STRUCT_RICOH_2C02_PPUSTATUS = 2
  .const OFFSET_STRUCT_RICOH_2A03_JOY1 = $16
  .const OFFSET_STRUCT_RICOH_2C02_PPUADDR = 6
  .const OFFSET_STRUCT_RICOH_2C02_PPUDATA = 7
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
  // Index into the Y sine
  .label y_sin_idx = $e
  // Index into the X sine
  .label x_sin_idx = $f
  // Index into the small X sine
  .label x_sin_idx_2 = $10
.segment Code
__start: {
    // volatile char y_sin_idx = 0
    lda #0
    sta.z y_sin_idx
    // volatile char x_sin_idx = 73
    lda #$49
    sta.z x_sin_idx
    // volatile char x_sin_idx_2 = 82
    lda #$52
    sta.z x_sin_idx_2
    jsr main
    rts
}
// NMI Called when the PPU refreshes the screen (also known as the V-Blank period)
vblank: {
    .label __17 = $a
    .label __19 = $a
    .label __23 = 9
    .label __25 = 9
    .label __28 = $d
    .label y_idx = $c
    .label x_idx = $a
    .label x_idx_2 = 9
    .label s = $b
    pha
    txa
    pha
    tya
    pha
    // PPU->PPUSCROLL = 0
    // Set scroll
    lda #0
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUSCROLL
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUSCROLL
    // PPU->OAMADDR = 0
    sta PPU+OFFSET_STRUCT_RICOH_2C02_OAMADDR
    // APU->OAMDMA = BYTE1(spriteBuffer)
    lda #>SPRITE_BUFFER
    sta APU+OFFSET_STRUCT_RICOH_2A03_OAMDMA
    // char joy = readJoy1()
    // Read controller 1
    jsr readJoy1
    // if(joy)
    cmp #0
    beq __b1
  __breturn:
    // }
    pla
    tay
    pla
    tax
    pla
    rti
  __b1:
    // char y_idx = y_sin_idx++
    // Update sprite positions
    lda.z y_sin_idx
    sta.z y_idx
    inc.z y_sin_idx
    // (x_sin_idx==238) ? 0 : x_sin_idx+1
    lda #$ee
    cmp.z x_sin_idx
    beq __b2
    ldx.z x_sin_idx
    inx
    jmp __b3
  __b2:
    ldx #0
  __b3:
    // x_sin_idx = (x_sin_idx==238) ? 0 : x_sin_idx+1
    stx.z x_sin_idx
    // char x_idx = x_sin_idx
    txa
    sta.z x_idx
    // (x_sin_idx_2==88) ? 0 : x_sin_idx_2+1
    lda #$58
    cmp.z x_sin_idx_2
    beq __b4
    ldx.z x_sin_idx_2
    inx
    jmp __b5
  __b4:
    ldx #0
  __b5:
    // x_sin_idx_2 = (x_sin_idx_2==88) ? 0 : x_sin_idx_2+1
    stx.z x_sin_idx_2
    // char x_idx_2 = x_sin_idx_2
    txa
    sta.z x_idx_2
    lda #0
    sta.z s
  __b6:
    // for(char s=0;s<0x40;s++)
    lda.z s
    cmp #$40
    bcc __b7
    jmp __breturn
  __b7:
    // SPRITE_BUFFER[s].y = SINTABLE_240[y_idx]
    lda.z s
    asl
    asl
    sta.z __28
    ldy.z y_idx
    lda SINTABLE_240,y
    ldy.z __28
    sta SPRITE_BUFFER,y
    // y_idx -= 4
    lax.z y_idx
    axs #4
    stx.z y_idx
    // SINTABLE_184[x_idx] + SINTABLE_64[x_idx_2]
    ldy.z x_idx
    lda SINTABLE_184,y
    ldy.z x_idx_2
    clc
    adc SINTABLE_64,y
    // SPRITE_BUFFER[s].x = SINTABLE_184[x_idx] + SINTABLE_64[x_idx_2]
    ldy.z __28
    sta SPRITE_BUFFER+OFFSET_STRUCT_SPRITEDATA_X,y
    // (x_idx<3) ? x_idx+236 : x_idx-3
    lda.z x_idx
    cmp #3
    bcc __b8
    lax.z __17
    axs #3
    stx.z __17
  __b10:
    // (x_idx_2>=86) ? x_idx_2-86 : x_idx_2+3
    lda.z x_idx_2
    cmp #$56
    bcs __b11
    lax.z __23
    axs #-[3]
    stx.z __23
  __b13:
    // for(char s=0;s<0x40;s++)
    inc.z s
    jmp __b6
  __b11:
    // (x_idx_2>=86) ? x_idx_2-86 : x_idx_2+3
    lax.z __25
    axs #$56
    stx.z __25
    jmp __b13
  __b8:
    // (x_idx<3) ? x_idx+236 : x_idx-3
    lax.z __19
    axs #-[$ec]
    stx.z __19
    jmp __b10
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
    // ppuDataFill(PPU_NAME_TABLE_0, '*', 32*30)
  // Fill the PPU attribute table
    ldx #'*'
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
  // Initialize Sprite Buffer with the SPRITE data
  __b1:
    // for(char s=0;s<0x40;s++)
    cpx #$40
    bcc __b2
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
    // SPRITE_BUFFER[s] = { 0, MESSAGE[s], 0b00000010, 0 }
    txa
    asl
    asl
    tay
    lda #0
    sta SPRITE_BUFFER,y
    lda MESSAGE,x
    sta SPRITE_BUFFER+OFFSET_STRUCT_SPRITEDATA_TILE,y
    lda #2
    sta SPRITE_BUFFER+OFFSET_STRUCT_SPRITEDATA_ATTRIBUTES,y
    lda #0
    sta SPRITE_BUFFER+OFFSET_STRUCT_SPRITEDATA_X,y
    // for(char s=0;s<0x40;s++)
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
.segment Data
  // The DXYCP message  0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
  MESSAGE: .text "rex-of-camelot-presents-a-dxycp-on-nintendo-entertainment-system"
  // Color Palette
  PALETTE: .byte 1, $21, $f, $30, 1, $21, $f, $30, 1, $21, $f, $30, 1, $21, $f, $30, 1, $f, $30, 8, 1, $f, $18, 8, 1, $30, $37, $1a, $f, $f, $f, $f
  // Sine Table (0-239)
SINTABLE_240:
.fill $100, round(115.5+107.5*sin(2*PI*i/256))

  // Sine Table (0-63)
SINTABLE_64:
.fill 89, round(52.5+52.5*sin(2*PI*i/89))

  // Sine Table (0-183)
SINTABLE_184:
.fill 239, round(71.5+71.5*sin(2*PI*i/239))

.segment Tiles
TILES:
.var filechargen = LoadBinary("characters.901225-01.bin")
     .for(var c=0; c<256; c++) {
        // Plane 0
        .fill 8, filechargen.get(c*8+i)
        // Plane 1
        .fill 8, 0
    }

.segment GameRam
  .align $100
  SPRITE_BUFFER: .fill 4*$100, 0
.segment Vectors
  VECTORS: .word vblank, main, 0
