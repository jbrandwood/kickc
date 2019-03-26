// Rolling constants by a variable amount
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label b = 2
    lda #0
    sta b
  b1:
    lda #$55
    ldy b
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    ldy b
    sta screen,y
    inc b
    lda #8
    cmp b
    bne b1
    rts
}
