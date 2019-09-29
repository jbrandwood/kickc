// Test a function taking boolean parameter and returning boolean result
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldx #0
  __b1:
    txa
    and #1
    eor #0
    beq !+
    lda #1
  !:
    eor #1
    sta.z isSet.b
    jsr isSet
    cmp #0
    bne __b2
    lda #' '
    sta screen,x
  __b3:
    inx
    cpx #$65
    bne __b1
    rts
  __b2:
    lda #'*'
    sta screen,x
    jmp __b3
}
// Determine whether to set a char to '*.
// Returns true if i&8!=0 or b=true
// isSet(byte register(X) i, bool zeropage(2) b)
isSet: {
    .label b = 2
    txa
    and #8
    eor #0
    beq !+
    lda #1
  !:
    ora.z b
    rts
}
