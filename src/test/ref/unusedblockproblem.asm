//  Problem with eliminating unused blocks/vars after the infinite loop (symbol line#2 not removed from symbol table)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
  b2:
    inc SCREEN
    jmp b2
}
