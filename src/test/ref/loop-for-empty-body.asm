// Test a for-loop with an empty body
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  b1:
    lda str,x
    cmp #0
    bne b2
    txa
    axs #-['0']
    // Empty body
    stx SCREEN
    rts
  b2:
    inx
    jmp b1
}
  str: .text "Hello!"
  .byte 0
