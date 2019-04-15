// Duplicate Loop Problem from Richard-William Loerakker
// Resulted in infinite loop in loop depth analysis
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label DC00 = $dc00
main: {
  b1:
    ldx DC00
    txa
    and #$1f
    cpx #0
    beq b3
    jmp b1
  b3:
    cmp #$1f
    beq b1
    jmp b1
}
