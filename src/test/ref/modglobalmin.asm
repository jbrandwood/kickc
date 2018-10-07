.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  jsr main
main: {
    ldx #0
    jsr inccnt
    stx SCREEN
    inx
    jsr inccnt
    inx
    stx SCREEN+1
    rts
}
inccnt: {
    inx
    rts
}
