// A test of boolean conditions using && || and !
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldx #0
  __b1:
    txa
    and #1
    cpx #$a
    bcs __b2
    cmp #0
    bne __b2
    lda #'*'
    sta screen,x
  __b2:
    inx
    cpx #$15
    bne __b1
    rts
}
