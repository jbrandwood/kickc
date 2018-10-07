.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    jsr incw1
    jsr incw2
    jsr incw1
    jsr incw2
    rts
}
incw2: {
    rts
}
incw1: {
    rts
}
