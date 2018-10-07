.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d021
  .const RED = 2
  jsr main
main: {
    .label screen = $400
    lda #1
    sta screen
    lda #RED
    sta BGCOL
    rts
}
