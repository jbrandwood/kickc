// NES conio printing
// Nintendo Entertainment System (NES
// https://en.wikipedia.org/wiki/Nintendo_Entertainment_System_(Model_NES-101)
// https://github.com/gregkrsak/first_nes
// Ricoh 2C02 - NES Picture Processing Unit (PPU)
// Ricoh RP2C02 (NTSC version) / RP2C07 (PAL version),
// https://en.wikipedia.org/wiki/Picture_Processing_Unit
// https://wiki.nesdev.com/w/index.php/PPU_registers
// http://nesdev.com/2C02%20technical%20reference.TXT
// Based on: https://github.com/gregkrsak/first_nes written by Greg M. Krsak, 2018. 
  // Nintendo Entertainment System (NES) ROM
// https://sadistech.com/nesromtool/romdoc.html
// https://forums.nesdev.com/viewtopic.php?f=2&t=9896
// https://github.com/gregkrsak/first_nes
.file [name="nes-conio.nes", type="bin", segments="NesRom"]
.file [name="nes-conio.nes_hdr", type="bin", segments="Header"]
.file [name="nes-conio.nes_prg", type="bin", segments="ProgramRom"]
.file [name="nes-conio.nes_chr", type="bin", segments="CharacterRom"]
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

  // Standard Controller Right Button
  .const JOY_RIGHT = 1
  // Standard Controller Left Button
  .const JOY_LEFT = 2
  // Standard Controller Down Button
  .const JOY_DOWN = 4
  // Standard Controller Up Button
  .const JOY_UP = 8
  .const OFFSET_STRUCT_RICOH_2A03_DMC_FREQ = $10
  .const OFFSET_STRUCT_RICOH_2C02_PPUMASK = 1
  .const OFFSET_STRUCT_RICOH_2C02_PPUSTATUS = 2
  .const OFFSET_STRUCT_RICOH_2A03_JOY1 = $16
  .const OFFSET_STRUCT_RICOH_2C02_PPUADDR = 6
  .const OFFSET_STRUCT_RICOH_2C02_PPUDATA = 7
  .const OFFSET_STRUCT_RICOH_2C02_PPUSCROLL = 5
  .const SIZEOF_BYTE = 1
  // $2000-$23bf	$03c0	Name table 0
  .label PPU_NAME_TABLE_0 = $2000
  // $23c0-$23ff	$0040	Attribute table 0
  .label PPU_ATTRIBUTE_TABLE_0 = $23c0
  // $27c0-$27ff	$0040	Attribute table 1
  .label PPU_ATTRIBUTE_TABLE_1 = $27c0
  // $3000-$3eff	$0f00	Mirrors of $2000-$2eff
  // $3f00-$3f1f	$0020	Palette RAM indexes
  .label PPU_PALETTE = $3f00
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
  // PPU Status Register for reading in ASM
  .label PPU_PPUSTATUS = $2002
  // NES Picture Processing Unit (PPU)
  .label PPU = $2000
  // NES CPU and audion processing unit (APU)
  .label APU = $4000
  .label conio_cursor_x = $b
  .label conio_cursor_y = $c
  .label conio_line_text = $d
  .label x_scroll = $f
  .label y_scroll = $10
__bbegin:
  // conio_cursor_x = 0
  // The current cursor x-position
  lda #0
  sta.z conio_cursor_x
  // conio_cursor_y = 0
  // The current cursor y-position
  sta.z conio_cursor_y
  // conio_line_text = CONIO_SCREEN_TEXT
  // The current text cursor line start
  lda #<PPU_NAME_TABLE_0
  sta.z conio_line_text
  lda #>PPU_NAME_TABLE_0
  sta.z conio_line_text+1
  // x_scroll
  lda #0
  sta.z x_scroll
  // y_scroll
  sta.z y_scroll
  jsr main
  rts
.segment Code
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
    // ppuDataFill(PPU_ATTRIBUTE_TABLE_1, 0, 0x40)
    ldx #0
    lda #<$40
    sta.z ppuDataFill.size
    lda #>$40
    sta.z ppuDataFill.size+1
    lda #<PPU_ATTRIBUTE_TABLE_1
    sta.z ppuDataFill.ppuDataPrepare1_ppuData
    lda #>PPU_ATTRIBUTE_TABLE_1
    sta.z ppuDataFill.ppuDataPrepare1_ppuData+1
    jsr ppuDataFill
    // clrscr()
  // Print a string
    jsr clrscr
    // cputs("hello world!\ni am nes\n look at me \n\n")
    jsr cputs
    // x_scroll = 0
    lda #0
    sta.z x_scroll
    // y_scroll = -8
    lda #-8
    sta.z y_scroll
    // PPU->PPUCTRL = 0b10000000
    lda #$80
    sta PPU
    // PPU->PPUMASK = 0b00011110
    lda #$1e
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUMASK
  __b1:
  // Infinite loop
    jmp __b1
  .segment Data
    s: .text @"hello world!\ni am nes\n look at me \n\n"
    .byte 0
}
.segment Code
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp(7) s)
cputs: {
    .label s = 7
    lda #<main.s
    sta.z s
    lda #>main.s
    sta.z s+1
  __b1:
    // c=*s++
    ldy #0
    lda (s),y
    // while(c=*s++)
    inc.z s
    bne !+
    inc.z s+1
  !:
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // cputc(c)
    tax
    jsr cputc
    jmp __b1
}
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// cputc(byte register(X) c)
cputc: {
    // if(c=='\n')
    cpx #'\n'
    beq __b1
    // conio_line_text+conio_cursor_x
    lda.z conio_cursor_x
    clc
    adc.z conio_line_text
    sta.z ppuDataSet.ppuData
    lda #0
    adc.z conio_line_text+1
    sta.z ppuDataSet.ppuData+1
    // ppuDataSet(conio_line_text+conio_cursor_x, c)
    // ppuDataSet(conio_line_text+conio_cursor_x, c)
    jsr ppuDataSet
    // if(++conio_cursor_x==CONIO_WIDTH)
    inc.z conio_cursor_x
    lda #$20
    cmp.z conio_cursor_x
    bne __breturn
    // cputln()
    jsr cputln
  __breturn:
    // }
    rts
  __b1:
    // cputln()
    jsr cputln
    rts
}
// Print a newline
cputln: {
    // conio_line_text +=  CONIO_WIDTH
    lda #$20
    clc
    adc.z conio_line_text
    sta.z conio_line_text
    bcc !+
    inc.z conio_line_text+1
  !:
    // conio_cursor_x = 0
    lda #0
    sta.z conio_cursor_x
    // conio_cursor_y++;
    inc.z conio_cursor_y
    // cscroll()
    jsr cscroll
    // }
    rts
}
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    .label line2 = 9
    // Scroll lines up
    .label line1 = 3
    .label y = 2
    // if(conio_cursor_y==CONIO_HEIGHT)
    lda #$1e
    cmp.z conio_cursor_y
    bne __breturn
    lda #<PPU_NAME_TABLE_0
    sta.z line1
    lda #>PPU_NAME_TABLE_0
    sta.z line1+1
    lda #<PPU_NAME_TABLE_0+$20
    sta.z line2
    lda #>PPU_NAME_TABLE_0+$20
    sta.z line2+1
    lda #0
    sta.z y
  __b1:
    // for(char y=0;y<CONIO_HEIGHT-1;y++)
    lda.z y
    cmp #$1e-1
    bcc __b2
    // ppuDataFill(CONIO_SCREEN_TEXT+CONIO_BYTES-CONIO_WIDTH, ' ', CONIO_WIDTH)
  // Fill last line with space
    ldx #' '
    lda #<$20
    sta.z ppuDataFill.size
    lda #>$20
    sta.z ppuDataFill.size+1
    lda #<PPU_NAME_TABLE_0+$1e*$20-$20
    sta.z ppuDataFill.ppuDataPrepare1_ppuData
    lda #>PPU_NAME_TABLE_0+$1e*$20-$20
    sta.z ppuDataFill.ppuDataPrepare1_ppuData+1
    jsr ppuDataFill
    // conio_line_text -= CONIO_WIDTH
    sec
    lda.z conio_line_text
    sbc #$20
    sta.z conio_line_text
    lda.z conio_line_text+1
    sbc #0
    sta.z conio_line_text+1
    // conio_cursor_y--;
    dec.z conio_cursor_y
  __breturn:
    // }
    rts
  __b2:
    ldy #0
  __b3:
    // for(char x=0;x<CONIO_WIDTH;x++)
    cpy #$20
    bcc __b4
    // for(char y=0;y<CONIO_HEIGHT-1;y++)
    inc.z y
    jmp __b1
  __b4:
    // ppuDataGet(line2++)
    lda.z line2
    sta.z ppuDataGet.ppuData
    lda.z line2+1
    sta.z ppuDataGet.ppuData+1
    jsr ppuDataGet
    // ppuDataGet(line2++)
    // ch = ppuDataGet(line2++)
    tax
    inc.z line2
    bne !+
    inc.z line2+1
  !:
    // ppuDataSet(line1++, ch)
    lda.z line1
    sta.z ppuDataSet.ppuData
    lda.z line1+1
    sta.z ppuDataSet.ppuData+1
    jsr ppuDataSet
    // ppuDataSet(line1++, ch);
    inc.z line1
    bne !+
    inc.z line1+1
  !:
    // for(char x=0;x<CONIO_WIDTH;x++)
    iny
    jmp __b3
}
// Set one byte in PPU memory
// - ppuData : Pointer in the PPU memory
// - val : The value to set
// ppuDataSet(byte* zp(5) ppuData, byte register(X) val)
ppuDataSet: {
    .label ppuDataPrepare1_ppuData = 5
    .label ppuData = 5
    // >ppuData
    lda.z ppuDataPrepare1_ppuData+1
    // PPU->PPUADDR = >ppuData
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    // <ppuData
    lda.z ppuDataPrepare1_ppuData
    // PPU->PPUADDR = <ppuData
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    // PPU->PPUDATA = val
    stx PPU+OFFSET_STRUCT_RICOH_2C02_PPUDATA
    // }
    rts
}
// Get one byte from PPU memory
// - ppuData : Pointer in the PPU memory
// ppuDataGet(void* zp($11) ppuData)
ppuDataGet: {
    .label ppuData = $11
    // >ppuData
    lda.z ppuData+1
    // PPU->PPUADDR = >ppuData
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    // <ppuData
    lda.z ppuData
    // PPU->PPUADDR = <ppuData
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    // return PPU->PPUDATA;
    lda PPU+OFFSET_STRUCT_RICOH_2C02_PPUDATA
    // }
    rts
}
// Fill a number of bytes in the PPU memory
// - ppuData : Pointer in the PPU memory
// - size : The number of bytes to transfer
// ppuDataFill(byte register(X) val, word zp($11) size)
ppuDataFill: {
    .label ppuDataPrepare1_ppuData = 5
    .label i = 9
    .label size = $11
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
    stx PPU+OFFSET_STRUCT_RICOH_2C02_PPUDATA
    // for(unsigned int i=0;i<size;i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    // ppuDataFill(CONIO_SCREEN_TEXT, ' ', 0x3c0)
    ldx #' '
    lda #<$3c0
    sta.z ppuDataFill.size
    lda #>$3c0
    sta.z ppuDataFill.size+1
    lda #<PPU_NAME_TABLE_0
    sta.z ppuDataFill.ppuDataPrepare1_ppuData
    lda #>PPU_NAME_TABLE_0
    sta.z ppuDataFill.ppuDataPrepare1_ppuData+1
    jsr ppuDataFill
    // conio_cursor_x = 0
    lda #0
    sta.z conio_cursor_x
    // conio_cursor_y = 0
    sta.z conio_cursor_y
    // conio_line_text = CONIO_SCREEN_TEXT
    lda #<PPU_NAME_TABLE_0
    sta.z conio_line_text
    lda #>PPU_NAME_TABLE_0
    sta.z conio_line_text+1
    // }
    rts
}
// Transfer a number of bytes from the CPU memory to the PPU memory
// - cpuData : Pointer to the CPU memory (RAM of ROM)
// - ppuData : Pointer in the PPU memory
// - size : The number of bytes to transfer
ppuDataTransfer: {
    .const size = $20*SIZEOF_BYTE
    .label ppuData = PPU_PALETTE
    .label cpuData = PALETTE
    // Transfer to PPU
    .label cpuSrc = 9
    .label i = 7
    // PPU->PPUADDR = >ppuData
    lda #>ppuData
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    // PPU->PPUADDR = <ppuData
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
// NMI Called when the PPU refreshes the screen (also known as the V-Blank period)
vblank: {
    pha
    txa
    pha
    tya
    pha
    // readJoy1()
    jsr readJoy1
    // joy = readJoy1()
    tax
    // joy&JOY_DOWN
    txa
    and #JOY_DOWN
    // if(joy&JOY_DOWN)
    cmp #0
    beq __b1
    // if(++y_scroll==240)
    inc.z y_scroll
    lda #$f0
    cmp.z y_scroll
    bne __b1
    // y_scroll=0
    lda #0
    sta.z y_scroll
  __b1:
    // joy&JOY_UP
    txa
    and #JOY_UP
    // if(joy&JOY_UP)
    cmp #0
    beq __b2
    // if(--y_scroll==255)
    dec.z y_scroll
    lda #$ff
    cmp.z y_scroll
    bne __b2
    // y_scroll=239
    lda #$ef
    sta.z y_scroll
  __b2:
    // joy&JOY_LEFT
    txa
    and #JOY_LEFT
    // if(joy&JOY_LEFT)
    cmp #0
    beq __b3
    // x_scroll++;
    inc.z x_scroll
  __b3:
    // joy&JOY_RIGHT
    txa
    and #JOY_RIGHT
    // if(joy&JOY_RIGHT)
    cmp #0
    beq __b4
    // x_scroll--;
    dec.z x_scroll
  __b4:
    // PPU->PPUSCROLL = x_scroll
    lda.z x_scroll
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUSCROLL
    // PPU->PPUSCROLL = y_scroll
    lda.z y_scroll
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUSCROLL
    // }
    pla
    tay
    pla
    tax
    pla
    rti
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
    .label __1 = $13
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
.segment Data
  // Color Palette
  PALETTE: .byte 1, $21, $f, $30, 1, $21, $f, $30, 1, $21, $f, $30, 1, $21, $f, $30, 1, $f, $30, 8, 1, $f, $18, 8, 1, $30, $37, $1a, $f, $f, $f, $f
.segment Tiles
TILES:
.var filechargen = LoadBinary("characters.901225-01.bin")
     .for(var c=0; c<256; c++) {
        // Plane 0
        .fill 8, filechargen.get(c*8+i)
        // Plane 1
        .fill 8, 0
    }

.segment Vectors
  VECTORS: .word vblank, main, 0
