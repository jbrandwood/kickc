// Tests creating, assigning returning and calling pointers to non-args no-return functions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    ldx #0
  b2:
    inx
    jsr getfn
    jsr fn1
    jmp b2
}
fn1: {
    .label BORDERCOL = $d020
    inc BORDERCOL
    rts
}
getfn: {
    rts
}
