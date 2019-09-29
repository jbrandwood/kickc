// Tests creating and assigning pointers to non-args no-return functions - plus inline kickasm-based calling
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  ff:
    jmp (main.f)

main: {
    .label f = 2
    ldx #0
  __b2:
    inx
    txa
    and #1
    cmp #0
    beq __b3
    lda #<fn2
    sta.z f
    lda #>fn2
    sta.z f+1
    jmp __b4
  __b3:
    lda #<fn1
    sta.z f
    lda #>fn1
    sta.z f+1
  __b4:
    jsr ff
        
    jmp __b2
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
