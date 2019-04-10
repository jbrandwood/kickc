// Tests creating, assigning returning and calling pointers to non-args no-return functions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    lda #0
  b2:
    clc
    adc #1
    jsr getfn
    jsr fn1
    jmp b2
}
fn1: {
    .label BORDERCOL = $d020
    inc BORDERCOL
    rts
}
// getfn(byte register(A) b)
getfn: {
    rts
}
