// Tests creating, assigning returning and calling pointers to non-args no-return functions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    ldx #0
  __b2:
    // (*getfn(++i))();
    inx
    // getfn(++i)
    jsr getfn
    // (*getfn(++i))()
    jsr fn1
    jmp __b2
}
fn1: {
    .label BORDERCOL = $d020
    // (*BORDERCOL)++;
    inc BORDERCOL
    // }
    rts
}
getfn: {
    rts
}
