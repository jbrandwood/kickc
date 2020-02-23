// Test a for()-loop where the condition has a side-effect
// Currently not standard C compliant (since the condition is not evaluated before the body)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    lda #7
  __b1:
    // for(i=7;i++<7;)
    tax
    inx
    cmp #7
    bcc __b2
    // (SCREEN)[i] = 'x'
    // The condition-evaluation should increment i - even if when it is not met - x should end up in 0x0408
    lda #'x'
    sta SCREEN,x
    // }
    rts
  __b2:
    // SCREEN[i] = i
    txa
    sta SCREEN,x
    txa
    jmp __b1
}
