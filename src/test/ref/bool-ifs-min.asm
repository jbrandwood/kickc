// A test of boolean conditions using && || and !
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldx #0
  b1:
    txa
    and #1
    cpx #$a
    bcs b2
    cmp #0
    bne b2
    lda #'*'
    sta screen,x
  b2:
    inx
    cpx #$15
    bne b1
    rts
}
