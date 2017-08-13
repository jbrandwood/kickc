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
    bcc b4
    beq b4
    iny
    jmp b1
  b4:
    dey
    jmp b1
}
