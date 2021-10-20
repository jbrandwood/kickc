// Demonstrates a problem where temporary zp-variables are overwrites each other between different "threads"
/// @file
/// Commodore 64 Registers and Constants
/// @file
/// The MOS 6526 Complex Interface Adapter (CIA)
///
/// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
  // Commodore 64 PRG executable file
.file [name="tmp-zp-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  /// The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  /// $D021 Background Color 0
  .label BG_COLOR = $d021
  /// The VIC-II MOS 6567/6569
  .label VICII = $d000
  /// The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
.segment Code
// The Interrupt Handler
irq: {
    // *BG_COLOR = WHITE
    lda #WHITE
    sta BG_COLOR
    // (*ptr)++;
    ldy ptr
    sty.z $fe
    ldy ptr+1
    sty.z $ff
    ldy #0
    lda ($fe),y
    clc
    adc #1
    sta ($fe),y
    // *BG_COLOR = BLACK
    lda #BLACK
    sta BG_COLOR
    // }
    jmp $ea31
}
// Setup the IRQ routine
main: {
    // asm
    sei
    // *KERNEL_IRQ = &irq
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
    // asm
    cli
  __b4:
    ldx #0
  __b1:
    // for(char i=0;i<10;i++)
    cpx #$a
    bcc __b6
    jmp __b4
  __b6:
    ldy #0
  __b2:
    // for(char j=0;j<10;j++)
    cpy #$a
    bcc __b3
    // for(char i=0;i<10;i++)
    inx
    jmp __b1
  __b3:
    // char k = i+j
    txa
    sty.z $ff
    clc
    adc.z $ff
    // if(k>0x80)
    cmp #$80+1
    bcc __b5
    // VICII->BORDER_COLOR++;
    inc VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
  __b5:
    // for(char j=0;j<10;j++)
    iny
    jmp __b2
}
.segment Data
  ptr: .word $ff00
