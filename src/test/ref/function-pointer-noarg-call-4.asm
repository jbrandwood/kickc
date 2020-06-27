// Tests creating, assigning returning and calling pointers to non-args no-return functions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
fn1: {
    .label BORDER_COLOR = $d020
    // (*BORDER_COLOR)++;
    inc BORDER_COLOR
    // }
    rts
}
main: {
    ldx #0
  __b2:
    // (*getfn(++i))();
    inx
    // (*getfn(++i))()
    jsr fn1
    jmp __b2
}
