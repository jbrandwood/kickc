// used vars
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // used vars
    .const col = 2
    .label COLS = $d800
    jsr s
    ldx #0
  b1:
    lda #col
    sta COLS,x
    lda #2/2+2
    sta SCREEN,x
    inx
    cpx #$65
    bne b1
    rts
}
s: {
    rts
}
