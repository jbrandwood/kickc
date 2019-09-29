// Tests that inline ASM JSR clobbers all registers
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    lda #0
  __b1:
    ldx #0
  __b2:
    ldy #0
  __b3:
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
    iny
    cpy #$b
    bne __b3
    inx
    cpx #$b
    bne __b2
    clc
    adc #1
    cmp #$b
    bne __b1
    rts
}
