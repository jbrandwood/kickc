.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const BGCOL = $d020
  jsr main
main: {
  b1:
    inc BGCOL
    dec BGCOL
    jmp b1
}
