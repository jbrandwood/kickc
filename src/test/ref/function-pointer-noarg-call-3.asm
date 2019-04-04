// Tests creating, assigning returning and calling pointers to non-args no-return functions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label _1 = 2
    ldx #0
  b2:
    inx
    txa
    jsr getfn
    jsr bi__1
    jmp b2
  bi__1:
    jmp (_1)
}
// getfn(byte register(A) b)
getfn: {
    .label return = 2
    and #1
    cmp #0
    beq b1
    lda #<fn2
    sta return
    lda #>fn2
    sta return+1
    jmp breturn
  b1:
    lda #<fn1
    sta return
    lda #>fn1
    sta return+1
  breturn:
    rts
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
