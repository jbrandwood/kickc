.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const DVAL = $20000
  .label SCREEN = $400
main: {
    lda #DVAL/$400
    sta SCREEN
    lda #0
    sta SCREEN+1
    rts
}
