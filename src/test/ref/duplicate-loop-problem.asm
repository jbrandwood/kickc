// Duplicate Loop Problem from Richard-William Loerakker
// Resulted in infinite loop in loop depth analysis
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label DC00 = $dc00
main: {
  __b1:
    ldx DC00
    txa
    and #$1f
    cpx #0
    bne __b1
    cmp #$1f
    beq __b1
    jmp __b1
}
