// Tests that inline ASM JSR clobbers all registers
  // Commodore 64 PRG executable file
.file [name="inline-asm-clobber-none.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    lda #0
  __b1:
    ldx #0
  __b2:
    ldy #0
  __b3:
    // asm
    pha
    txa
    pha
    tya
    pha
    jsr $e544
    pla
    tay
    pla
    tax
    pla
    // for( byte k:0..10)
    iny
    cpy #$b
    bne __b3
    // for( byte j:0..10)
    inx
    cpx #$b
    bne __b2
    // for( byte i:0..10)
    clc
    adc #1
    cmp #$b
    bne __b1
    // }
    rts
}
