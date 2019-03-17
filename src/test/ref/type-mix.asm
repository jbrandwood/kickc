// Tests that mixing types can synthesize a fragment correctly
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label w = 2
    ldx #0
    txa
    sta w
    sta w+1
  b1:
    sec
    lda w
    sbc #$c
    sta w
    bcs !+
    dec w+1
  !:
    lda w
    sta SCREEN,x
    inx
    cpx #$b
    bne b1
    rts
}
