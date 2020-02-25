// Tests creating and assigning pointers to non-args return with function value
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label f = 2
    ldx #0
  __b2:
    // ++i;
    inx
    // i&1
    txa
    and #1
    // if((i&1)==0)
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
    // (byte)f
    lda.z f
    // SCREEN[0] = (byte)f
    sta SCREEN
    jmp __b2
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
