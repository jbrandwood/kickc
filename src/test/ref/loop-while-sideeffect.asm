// Test a while()-loop where the condition has a side-effect
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // The condition-evaluation should increment i - even if when it is not met
    lda #'x'
    sta SCREEN+8
    rts
}
