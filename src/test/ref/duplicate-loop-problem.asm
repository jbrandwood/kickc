// Duplicate Loop Problem from Richard-William Loerakker
// Resulted in infinite loop in loop depth analysis
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label DC00 = $dc00
main: {
  __b1:
    // key = *DC00
    ldx DC00
    // key & %00011111
    txa
    and #$1f
    // while(key == 0 && ((key & %00011111) == %00011111))
    cpx #0
    bne __b1
    cmp #$1f
    beq __b1
    jmp __b1
}
