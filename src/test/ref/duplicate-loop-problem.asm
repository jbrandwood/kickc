// Duplicate Loop Problem from Richard-William Loerakker
// Resulted in infinite loop in loop depth analysis
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label DC00 = $dc00
main: {
    ldy #0
  b1:
    iny
  b2:
    ldx DC00
    txa
    and #$1f
    cpx #0
    beq b5
    jmp b1
  b5:
    cmp #$1f
    beq b2
    jmp b1
}
