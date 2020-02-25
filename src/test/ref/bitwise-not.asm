.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    // *SCREEN = ~1ub
    lda #1^$ff
    sta SCREEN
    ldx #1
  __b1:
    // ~c
    txa
    eor #$ff
    // SCREEN[c] = ~c
    sta SCREEN,x
    // for(byte c : 1..26)
    inx
    cpx #$1b
    bne __b1
    // }
    rts
}
