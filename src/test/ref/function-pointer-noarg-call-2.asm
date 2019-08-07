// Tests creating, assigning and calling pointers to non-args no-return functions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label i = 2
    .label f = 3
    lda #0
    sta.z i
  b2:
    inc.z i
    lda #1
    and.z i
    cmp #0
    beq b3
    lda #<fn2
    sta.z f
    lda #>fn2
    sta.z f+1
    jmp b4
  b3:
    lda #<fn1
    sta.z f
    lda #>fn1
    sta.z f+1
  b4:
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
