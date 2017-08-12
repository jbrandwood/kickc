bbegin:
  jsr main
bend:
main: {
  b1_from_main:
    ldy #$0
    ldx #$64
  b1:
    dex
    cpx #$0
    bne b2
  breturn:
    rts
  b2:
    cpx #$32
    beq !+
    bcs b4
  !:
  b5:
    dey
  b1_from_b5:
    jmp b1
  b4:
    iny
  b1_from_b4:
    jmp b1
}
