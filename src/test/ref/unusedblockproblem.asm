.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .label SCREEN = $400
  b2:
    inc SCREEN
    jmp b2
}
