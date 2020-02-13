// Duplicate Loop Problem from Richard-William Loerakker
// Resulted in infinite loop in loop depth analysis
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label DC00 = $dc00
main: {
    ldy #0
  __b1:
    iny
  __b2:
    ldx DC00
    txa
    and #$1f
    cpx #0
    bne __b1
    cmp #$1f
    beq __b2
    jmp __b1
}
