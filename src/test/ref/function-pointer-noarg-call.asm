// Tests creating, assigning and calling pointers to non-args no-return functions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // (*f)()
    jsr fn1
    // }
    rts
}
fn1: {
    .label BORDERCOL = $d020
    // (*BORDERCOL)++;
    inc BORDERCOL
    // }
    rts
}
