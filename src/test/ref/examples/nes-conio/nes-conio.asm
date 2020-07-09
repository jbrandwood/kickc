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
  // PPU Status Register for reading in ASM
  .label PPU_PPUSTATUS = $2002
  // PPU Data Register for reading in ASM
  .label PPU_PPUDATA = $2007
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
  // The current cursor x-position
  .label conio_cursor_x = $f
  // The current cursor y-position
  .label conio_cursor_y = $10
  // The current text cursor line start
  .label conio_line_text = $11
  .label x_scroll = $13
  .label y_scroll = $14
.segment Code
__start: {
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
    // x_scroll
    lda #0
    sta.z x_scroll
    // y_scroll
    sta.z y_scroll
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
// RESET Called when the NES is reset, including when it is turned on.
main: {
    .const screensizex1_return = $20
    .const screensizey1_return = $1e
    .const screensizey2_return = $1e
    .const screensizex2_return = $20
    .const screensizey3_return = $1e
    .label x = 2
    .label y = 3
    .label i = 4
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
    lda #<$20*SIZEOF_BYTE
    sta.z ppuDataTransfer.size
    lda #>$20*SIZEOF_BYTE
    sta.z ppuDataTransfer.size+1
    lda #<PALETTE
    sta.z ppuDataTransfer.cpuData
    lda #>PALETTE
    sta.z ppuDataTransfer.cpuData+1
    lda #<PPU_PALETTE
    sta.z ppuDataTransfer.ppuDataPrepare1_ppuData
    lda #>PPU_PALETTE
    sta.z ppuDataTransfer.ppuDataPrepare1_ppuData+1
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
    lda #1
    sta.z x
  __b7:
    // for(char x=1;x<screensizex()-1;x++)
    lda.z x
    cmp #screensizex1_return-1
    bcc __b1
    lda #1
    sta.z y
  __b9:
    // for(char y=1;y<screensizey()-3;y++)
    lda.z y
    cmp #screensizey2_return-3
    bcc __b2
    lda #0
    sta.z i
  __b11:
    // for(char i=0;i<screensizey();i++)
    lda.z i
    cmp #screensizey3_return
    bcc __b3
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
  __b4:
  // Infinite loop
    jmp __b4
  __b3:
    // uctoa(i&0xf, num_buffer, HEXADECIMAL)
    lda #$f
    and.z i
    tax
    jsr uctoa
    // cputsxy(i, i, num_buffer)
    ldx.z i
    txa
    jsr cputsxy
    // for(char i=0;i<screensizey();i++)
    inc.z i
    jmp __b11
  __b2:
    // cputcxy(1, y, 'i')
    lda.z y
    ldy #'i'
    ldx #1
    jsr cputcxy
    // cputcxy(screensizex()-2, y, 'i')
    lda.z y
    ldy #'i'
    ldx #screensizex2_return-2
    jsr cputcxy
    // for(char y=1;y<screensizey()-3;y++)
    inc.z y
    jmp __b9
  __b1:
    // cputcxy(x, 1, '-')
    ldx.z x
    ldy #'-'
    lda #1
    jsr cputcxy
    // cputcxy(x, screensizey()-4, '-')
    ldx.z x
    ldy #'-'
    lda #screensizey1_return-4
    jsr cputcxy
    // for(char x=1;x<screensizex()-1;x++)
    inc.z x
    jmp __b7
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
    .label __1 = $15
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
// ppuDataTransfer(void* zp($b) ppuData, void* zp($d) cpuData, word zp($1b) size)
ppuDataTransfer: {
    .label ppuDataPrepare1_ppuData = $b
    .label cpuSrc = $d
    .label i = 7
    .label ppuData = $b
    .label cpuData = $d
    .label size = $1b
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
    cmp.z size+1
    bcc __b2
    bne !+
    lda.z i
    cmp.z size
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
// ppuDataFill(byte register(X) val, word zp($d) size)
ppuDataFill: {
    .label ppuDataPrepare1_ppuData = $b
    .label i = $1b
    .label size = $d
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
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// uctoa(byte register(X) value, byte* zp(7) buffer)
uctoa: {
    .const max_digits = 2
    .label digit_value = $16
    .label buffer = 7
    .label digit = 5
    .label started = 6
    lda #<num_buffer
    sta.z buffer
    lda #>num_buffer
    sta.z buffer+1
    lda #0
    sta.z started
    sta.z digit
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    lda.z digit
    cmp #max_digits-1
    bcc __b2
    // *buffer++ = DIGITS[(char)value]
    lda DIGITS,x
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    lda #0
    tay
    sta (buffer),y
    // }
    rts
  __b2:
    // digit_value = digit_values[digit]
    ldy.z digit
    lda RADIX_HEXADECIMAL_VALUES_CHAR,y
    sta.z digit_value
    // if (started || value >= digit_value)
    lda #0
    cmp.z started
    bne __b5
    cpx.z digit_value
    bcs __b5
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    inc.z digit
    jmp __b1
  __b5:
    // uctoa_append(buffer++, value, digit_value)
    jsr uctoa_append
    // uctoa_append(buffer++, value, digit_value)
    // value = uctoa_append(buffer++, value, digit_value)
    // value = uctoa_append(buffer++, value, digit_value);
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    lda #1
    sta.z started
    jmp __b4
}
// Move cursor and output a NUL-terminated string
// Same as "gotoxy (x, y); puts (s);"
// cputsxy(byte register(X) x, byte register(A) y)
cputsxy: {
    // gotoxy(x, y)
    jsr gotoxy
    // cputs(s)
    jsr cputs
    // }
    rts
}
// Move cursor and output one character
// Same as "gotoxy (x, y); cputc (c);"
// cputcxy(byte register(X) x, byte register(A) y, byte register(Y) c)
cputcxy: {
    // gotoxy(x, y)
    jsr gotoxy
    // cputc(c)
    tya
    tax
    jsr cputc
    // }
    rts
}
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// uctoa_append(byte* zp(7) buffer, byte register(X) value, byte zp($16) sub)
uctoa_append: {
    .label buffer = 7
    .label sub = $16
    ldy #0
  __b1:
    // while (value >= sub)
    cpx.z sub
    bcs __b2
    // *buffer = DIGITS[digit]
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // }
    rts
  __b2:
    // digit++;
    iny
    // value -= sub
    txa
    sec
    sbc.z sub
    tax
    jmp __b1
}
// Set the cursor to the specified position
// gotoxy(byte register(X) x, byte register(A) y)
gotoxy: {
    .label __5 = $17
    .label __6 = $17
    .label line_offset = $17
    // if(y>CONIO_HEIGHT)
    cmp #$1e+1
    bcc __b1
    lda #0
  __b1:
    // if(x>=CONIO_WIDTH)
    cpx #$20
    bcc __b2
    ldx #0
  __b2:
    // conio_cursor_x = x
    stx.z conio_cursor_x
    // conio_cursor_y = y
    sta.z conio_cursor_y
    // (unsigned int)y*CONIO_WIDTH
    sta.z __6
    lda #0
    sta.z __6+1
    // line_offset = (unsigned int)y*CONIO_WIDTH
    asl.z line_offset
    rol.z line_offset+1
    asl.z line_offset
    rol.z line_offset+1
    asl.z line_offset
    rol.z line_offset+1
    asl.z line_offset
    rol.z line_offset+1
    asl.z line_offset
    rol.z line_offset+1
    // CONIO_SCREEN_TEXT + line_offset
    clc
    lda.z __5
    adc #<PPU_NAME_TABLE_0
    sta.z __5
    lda.z __5+1
    adc #>PPU_NAME_TABLE_0
    sta.z __5+1
    // conio_line_text = CONIO_SCREEN_TEXT + line_offset
    lda.z __5
    sta.z conio_line_text
    lda.z __5+1
    sta.z conio_line_text+1
    // }
    rts
}
// Output a NUL-terminated string at the current cursor position
// cputs(byte* zp($17) s)
cputs: {
    .label s = $17
    lda #<num_buffer
    sta.z s
    lda #>num_buffer
    sta.z s+1
  __b1:
    // while(c=*s++)
    ldy #0
    lda (s),y
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
    txa
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
// Set one byte in PPU memory
// - ppuData : Pointer in the PPU memory
// - val : The value to set
// ppuDataSet(byte* zp($19) ppuData, byte register(A) val)
ppuDataSet: {
    .label ppuData = $19
    // >ppuData
    ldx.z ppuData+1
    // PPU->PPUADDR = >ppuData
    stx PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    // <ppuData
    ldx.z ppuData
    // PPU->PPUADDR = <ppuData
    stx PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    // PPU->PPUDATA = val
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUDATA
    // }
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
    // Scroll lines up
    .label line1 = 9
    .label line2 = $19
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
    ldx #0
  __b1:
    // for(char y=0;y<CONIO_HEIGHT-1;y++)
    cpx #$1e-1
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
    // ppuDataFetch(conio_cscroll_buffer, line2, CONIO_WIDTH)
    lda.z line2
    sta.z ppuDataFetch.ppuData
    lda.z line2+1
    sta.z ppuDataFetch.ppuData+1
    jsr ppuDataFetch
    // ppuDataTransfer(line1, conio_cscroll_buffer, CONIO_WIDTH)
    lda.z line1
    sta.z ppuDataTransfer.ppuData
    lda.z line1+1
    sta.z ppuDataTransfer.ppuData+1
    lda #<$20
    sta.z ppuDataTransfer.size
    lda #>$20
    sta.z ppuDataTransfer.size+1
    lda #<conio_cscroll_buffer
    sta.z ppuDataTransfer.cpuData
    lda #>conio_cscroll_buffer
    sta.z ppuDataTransfer.cpuData+1
    jsr ppuDataTransfer
    // line1 += CONIO_WIDTH
    lda #$20
    clc
    adc.z line1
    sta.z line1
    bcc !+
    inc.z line1+1
  !:
    // line2 += CONIO_WIDTH
    lda #$20
    clc
    adc.z line2
    sta.z line2
    bcc !+
    inc.z line2+1
  !:
    // for(char y=0;y<CONIO_HEIGHT-1;y++)
    inx
    jmp __b1
}
// Transfer a number of bytes from the PPU memory to the CPU memory
// - cpuData : Pointer to the CPU memory (RAM of ROM)
// - ppuData : Pointer in the PPU memory
// - size : The number of bytes to transfer
// ppuDataFetch(void* zp($1b) ppuData)
ppuDataFetch: {
    .const size = $20
    .label cpuData = conio_cscroll_buffer
    // Fetch from PPU to CPU
    .label cpuDst = $d
    .label i = $b
    .label ppuData = $1b
    // >ppuData
    lda.z ppuData+1
    // PPU->PPUADDR = >ppuData
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    // <ppuData
    lda.z ppuData
    // PPU->PPUADDR = <ppuData
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    // asm
    // Perform a dummy-read to discard the current value in the data read buffer and update it with the first byte from the PPU address
    lda PPU_PPUDATA
    lda #<cpuData
    sta.z cpuDst
    lda #>cpuData
    sta.z cpuDst+1
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    // for(unsigned int i=0;i<size;i++)
    lda.z i+1
    cmp #>size
    bcc ppuDataRead1
    bne !+
    lda.z i
    cmp #<size
    bcc ppuDataRead1
  !:
    // }
    rts
  ppuDataRead1:
    // return PPU->PPUDATA;
    lda PPU+OFFSET_STRUCT_RICOH_2C02_PPUDATA
    // *cpuDst++ = ppuDataRead()
    ldy #0
    sta (cpuDst),y
    // *cpuDst++ = ppuDataRead();
    inc.z cpuDst
    bne !+
    inc.z cpuDst+1
  !:
    // for(unsigned int i=0;i<size;i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
.segment GameRam
  // Buffer used for scrolling the NES screen
  conio_cscroll_buffer: .fill $20, 0
.segment Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES_CHAR: .byte $10
.segment GameRam
  num_buffer: .fill $b, 0
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
