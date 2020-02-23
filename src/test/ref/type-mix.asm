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
  __b1:
    // w = w - 12
    lda.z w
    sec
    sbc #$c
    sta.z w
    lda.z w+1
    sbc #>$c
    sta.z w+1
    // <w
    lda.z w
    // SCREEN[i] = <w
    sta SCREEN,x
    // for (byte i: 0..10)
    inx
    cpx #$b
    bne __b1
    // }
    rts
}
