// Test a for-loop with an empty body
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    lda str,x
    cmp #0
    bne __b2
    txa
    axs #-['0']
    // Empty body
    stx SCREEN
    rts
  __b2:
    inx
    jmp __b1
}
  str: .text "Hello!"
  .byte 0
