// Test a for()-loop where the condition has a side-effect
// Currently not standard C compliant (since the condition is not evaluated before the body)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    lda #7
  b1:
    tax
    inx
    cmp #7
    bcc b2
    // The condition-evaluation should increment i - even if when it is not met - x should end up in 0x0408
    lda #'x'
    sta SCREEN,x
    rts
  b2:
    txa
    sta SCREEN,x
    txa
    jmp b1
}
