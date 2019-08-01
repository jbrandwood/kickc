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
    sta SCREEN,x
    tax
    inx
    cmp #7
    bcc b3
    // The condition-evaluation should increment i - even if when it is not met - x should end up in 0x0408
    lda #'x'
    sta SCREEN,x
    rts
  b3:
    txa
    jmp b1
}