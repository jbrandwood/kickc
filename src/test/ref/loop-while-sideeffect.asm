// Test a while()-loop where the condition has a side-effect
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    lda #7
  __b1:
    tax
    inx
    cmp #7
    bne __b2
    // The condition-evaluation should increment i - even if when it is not met
    lda #'x'
    sta SCREEN,x
    rts
  __b2:
    txa
    sta SCREEN,x
    txa
    jmp __b1
}
