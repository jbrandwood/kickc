// Test the boolean NOT operator
// Bool not operator used on char in ternary operator
// Fails due to "Number integer type not resolved to fixed size integer type"
// https://gitlab.com/camelot/kickc/issues/199
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldx #0
  __b1:
    // b = i&1
    txa
    and #1
    // !b ? 1 : 0
    cmp #0
    beq __b2
    lda #0
    jmp __b3
  __b2:
    // !b ? 1 : 0
    lda #1
  __b3:
    // screen[i] = c
    sta screen,x
    // for(char i: 0..7)
    inx
    cpx #8
    bne __b1
    // }
    rts
}
