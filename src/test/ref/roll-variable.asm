// Rolling constants by a variable amount
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label b = 2
    lda #0
    sta.z b
  __b1:
    lda #$55
    ldy.z b
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    ldy.z b
    sta screen,y
    inc.z b
    lda #8
    cmp.z b
    bne __b1
    rts
}
