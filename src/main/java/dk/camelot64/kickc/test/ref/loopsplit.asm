  jsr main
main: {
    ldy #$0
    ldx #$64
  b1:
    dex
    cpx #$0
    bne b2
    rts
  b2:
    cpx #$32
    beq !+
    bcs b4
  !:
    dey
    jmp b1
  b4:
    iny
    jmp b1
}
