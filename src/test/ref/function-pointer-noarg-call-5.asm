// Tests calling into arrays of pointers to non-args no-return functions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label i = 2
    .label f = 3
    lda #0
    sta i
  b2:
    inc i
    lda #1
    and i
    asl
    tay
    lda fns,y
    sta f
    lda fns+1,y
    sta f+1
    jsr bi_f
    jmp b2
  bi_f:
    jmp (f)
}
fn2: {
    .label BGCOL = $d021
    inc BGCOL
    rts
}
fn1: {
    .label BORDERCOL = $d020
    inc BORDERCOL
    rts
}
  fns: .word fn1, fn2
