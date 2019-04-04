// Tests creating, assigning and calling pointers to non-args no-return functions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label f = 2
    ldx #0
  b2:
    inx
    txa
    and #1
    cmp #0
    beq b1
    lda #<fn2
    sta f
    lda #>fn2
    sta f+1
    jmp b3
  b1:
    lda #<fn1
    sta f
    lda #>fn1
    sta f+1
  b3:
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
