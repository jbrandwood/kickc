// A minimal NES demo
// Based on: https://github.com/gregkrsak/first_nes written by Greg M. Krsak, 2018. 
  // Nintendo Entertainment System (NES) ROM
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
.segmentdef ProgramRom [ segments="Code, Data, Vectors" ]
.segmentdef CharacterRom [ segments="Tiles" ]
.segmentdef NesRom
//.segment NesRom
//.segmentout [ segments="Header" ]
//.segmentout [ segments="ProgramRom" ]
//.segmentout [ segments="CharacterRom" ]
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
  .const OFFSET_STRUCT_RICOH_2A03_JOY1 = $16
  .const OFFSET_STRUCT_RICOH_2C02_PPUADDR = 6
  .const OFFSET_STRUCT_RICOH_2C02_PPUDATA = 7
  .const SIZEOF_BYTE = 1
  // $3000-$3EFF	$0F00	Mirrors of $2000-$2EFF
  // $3F00-$3F1F	$0020	Palette RAM indexes
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
  // OAM (Object Attribute Memory) Buffer
  // Will be transfered to the PPU via DMA
  .label OAM_BUFFER = $200
  // PPU Status Register for reading in ASM
  .label PPU_PPUSTATUS = $2002
  // NES Picture Processing Unit (PPU)
  .label PPU = $2000
  // NES CPU and audion processing unit (APU)
  .label APU = $4000
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
  waitForVBlank1:
    // PPU->PPUSTATUS&0x80
    lda #$80
    and PPU+OFFSET_STRUCT_RICOH_2C02_PPUSTATUS
    // while(!(PPU->PPUSTATUS&0x80))
    cmp #0
    beq waitForVBlank1
    ldx #0
  __b1:
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
    bne __b1
  waitForVBlank2:
    // PPU->PPUSTATUS&0x80
    lda #$80
    and PPU+OFFSET_STRUCT_RICOH_2C02_PPUSTATUS
    // while(!(PPU->PPUSTATUS&0x80))
    cmp #0
    beq waitForVBlank2
    // initPaletteData()
    // Now the PPU is ready.
    jsr initPaletteData
    // initSpriteData()
    jsr initSpriteData
    // PPU->PPUCTRL = 0b10000000
    lda #$80
    sta PPU
    // PPU->PPUMASK = 0b00010000
    lda #$10
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUMASK
  __b2:
  // Infinite loop
    jmp __b2
}
// Initialize OAM (Object Attribute Memory) Buffer 
initSpriteData: {
    ldx #0
  __b1:
    // for(char i=0;i<sizeof(SPRITES);i++)
    cpx #$10*SIZEOF_BYTE
    bcc __b2
    // }
    rts
  __b2:
    // OAM_BUFFER[i] = SPRITES[i]
    lda SPRITES,x
    sta OAM_BUFFER,x
    // for(char i=0;i<sizeof(SPRITES);i++)
    inx
    jmp __b1
}
// Copy palette values to PPU
initPaletteData: {
    // asm
    // Reset the high/low latch to "high"
    lda PPU_PPUSTATUS
    // PPU->PPUADDR = >PPU_PALETTE
    // Write the high byte of PPU Palette address
    lda #>PPU_PALETTE
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    // PPU->PPUADDR = <PPU_PALETTE
    // Write the low byte of PPU Palette address
    lda #0
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUADDR
    tax
  // Write to PPU
  __b1:
    // for(char i=0;i<sizeof(PALETTE);i++)
    cpx #$20*SIZEOF_BYTE
    bcc __b2
    // }
    rts
  __b2:
    // PPU->PPUDATA = PALETTE[i]
    lda PALETTE,x
    sta PPU+OFFSET_STRUCT_RICOH_2C02_PPUDATA
    // for(char i=0;i<sizeof(PALETTE);i++)
    inx
    jmp __b1
}
// NMI Called when the PPU refreshes the screen (also known as the V-Blank period)
vblank: {
    pha
    txa
    pha
    tya
    pha
    // PPU->OAMADDR = 0
    // Refresh DRAM-stored sprite data before it decays.
    // Set OAM start address to sprite#0
    lda #0
    sta PPU+OFFSET_STRUCT_RICOH_2C02_OAMADDR
    // APU->OAMDMA = >OAM_BUFFER
    // Set the high byte (02) of the RAM address and start the DMA transfer to OAM memory
    lda #>OAM_BUFFER
    sta APU+OFFSET_STRUCT_RICOH_2A03_OAMDMA
    // APU->JOY1 = 1
    // Freeze the button positions.
    lda #1
    sta APU+OFFSET_STRUCT_RICOH_2A03_JOY1
    // APU->JOY1 = 0
    lda #0
    sta APU+OFFSET_STRUCT_RICOH_2A03_JOY1
    // APU->JOY1&0b00000001
    lda #1
    and APU+OFFSET_STRUCT_RICOH_2A03_JOY1
    // if(APU->JOY1&0b00000001)
    cmp #0
    beq __b1
    // moveLuigiRight()
    jsr moveLuigiRight
  __b1:
    // APU->JOY1&0b00000001
    lda #1
    and APU+OFFSET_STRUCT_RICOH_2A03_JOY1
    // if(APU->JOY1&0b00000001)
    cmp #0
    beq __breturn
    // moveLuigiLeft()
    jsr moveLuigiLeft
  __breturn:
    // }
    pla
    tay
    pla
    tax
    pla
    rti
}
// move the Luigi sprites left
moveLuigiLeft: {
    // OAM_BUFFER[0x03]--;
    dec OAM_BUFFER+3
    // OAM_BUFFER[0x07]--;
    dec OAM_BUFFER+7
    // OAM_BUFFER[0x0b]--;
    dec OAM_BUFFER+$b
    // OAM_BUFFER[0x0f]--;
    dec OAM_BUFFER+$f
    // }
    rts
}
// move the Luigi sprites right
moveLuigiRight: {
    // OAM_BUFFER[0x03]++;
    inc OAM_BUFFER+3
    // OAM_BUFFER[0x07]++;
    inc OAM_BUFFER+7
    // OAM_BUFFER[0x0b]++;
    inc OAM_BUFFER+$b
    // OAM_BUFFER[0x0f]++;
    inc OAM_BUFFER+$f
    // }
    rts
}
.segment Data
  PALETTE: .byte $f, $31, $32, $33, $f, $35, $36, $37, $f, $39, $3a, $3b, $f, $3d, $3e, $f, $f, $1c, $15, $14, $f, 2, $38, $3c, $f, $30, $37, $1a, $f, $f, $f, $f
  // Small Luigi Sprite Data
  SPRITES: .byte $80, $36, 2, $80, $80, $37, 2, $88, $88, $38, 2, $80, $88, $39, 2, $88
.segment Tiles
TILES:
.import binary "smb1_chr.bin"

.segment Vectors
  VECTORS: .word vblank, main, 0
.segment NesRom
NES_ROM:
.segmentout [ segments="Header" ]
.segmentout [ segments="ProgramRom" ]
.segmentout [ segments="CharacterRom" ]

