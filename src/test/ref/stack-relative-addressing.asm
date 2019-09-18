// Test stack-relative addressing (for passing parameters through the stack)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  /** The hardware stack. The offset 3 is to skip the return address and the fact that the pointer is to the next free position. */
  .label STACK = $103
  /** The screen. */
  .label SCREEN = $400
main: {
    // Push a few values to the stack
    lda #'1'
    pha
    lda #'2'
    pha
    lda #'3'
    pha
    jsr peek_stack
    // Clean up the stack
    pla
    pla
    pla
    rts
}
// Peek values from the stack using stack-relative addressing
peek_stack: {
    tsx
    lda STACK,x
    sta SCREEN
    lda STACK+1,x
    sta SCREEN+1
    lda STACK+2,x
    sta SCREEN+2
    rts
}
