// Tests that mixing types can synthesize a fragment correctly
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label w = 2
    ldx #0
    txa
    sta.z w
    sta.z w+1
  b1:
    lda.z w
    sec
    sbc #$c
    sta.z w
    lda.z w+1
    sbc #>$c
    sta.z w+1
    lda.z w
    sta SCREEN,x
    inx
    cpx #$b
    bne b1
    rts
}
