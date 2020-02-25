// used vars
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // used vars
    .const col = 2
    .label COLS = $d800
    // s()
    jsr s
    ldx #0
  __b1:
    // COLS[i] = col
    lda #col
    sta COLS,x
    // SCREEN[i] = b
    lda #2/2+1+1
    sta SCREEN,x
    // for(byte i : 0..100)
    inx
    cpx #$65
    bne __b1
    // }
    rts
}
s: {
    rts
}
