// Tests creating and assigning pointers to non-args return with function value
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
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
    lda f
    sta SCREEN
    jmp b2
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
