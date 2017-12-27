.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SCREEN = $400
  jsr main
main: {
    lda #$40
    jsr ln
    jsr ln
    jsr ln
    sta SCREEN
    rts
}
ln: {
    clc
    adc #2
    rts
}
