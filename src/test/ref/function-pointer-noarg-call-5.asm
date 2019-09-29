// Tests calling into arrays of pointers to non-args no-return functions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label i = 2
    .label f = 3
    lda #0
    sta.z i
  __b2:
    inc.z i
    lda #1
    and.z i
    asl
    tay
    lda fns,y
    sta.z f
    lda fns+1,y
    sta.z f+1
    jsr bi_f
    jmp __b2
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
