.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d021
  .const RED = 2
  jsr main
main: {
    lda #RED
    sta BGCOL
    rts
}