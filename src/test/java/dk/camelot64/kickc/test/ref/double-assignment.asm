.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .label screen = $400
    .const a = $c
    lda #a
    sta screen+0
    sta screen+1
    rts
}
