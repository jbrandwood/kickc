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
    // f = fns[++i&1]
    inc.z i
    // ++i&1
    lda #1
    and.z i
    // f = fns[++i&1]
    asl
    tay
    lda fns,y
    sta.z f
    lda fns+1,y
    sta.z f+1
    // (*f)()
    jsr bi_f
    jmp __b2
  bi_f:
    jmp (f)
}
fn2: {
    .label BGCOL = $d021
    // (*BGCOL)++;
    inc BGCOL
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
  fns: .word fn1, fn2
