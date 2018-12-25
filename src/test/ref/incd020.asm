.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d020
main: {
  b1:
    inc BGCOL
    dec BGCOL
    jmp b1
}
