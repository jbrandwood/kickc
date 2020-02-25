// Problem with eliminating unused blocks/vars after the infinite loop (symbol line#2 not removed from symbol table)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
  __b1:
    // (*SCREEN)++;
    inc SCREEN
    jmp __b1
}
