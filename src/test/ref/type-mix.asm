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
    lda #$c
    sta $fe
    ora #$7f
    bmi !+
    lda #0
  !:
    sta $ff
    sec
    lda w
    sbc $fe
    sta w
    lda w+1
    sbc $ff
    sta w+1
    lda w
    sta SCREEN,x
    inx
    cpx #$b
    bne b1
    rts
}
