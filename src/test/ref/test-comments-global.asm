// Tests that global variables with initializer gets their comments
.pc = $801 "Basic"
:BasicUpstart(__start)
.pc = $80d "Program"
  // The screen (should become a var-comment in ASM)
  .label screen = 2
__start: {
    // screen = 0x0400
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    jsr main
    rts
}
// The program entry point
main: {
    // *screen = 'a'
    // Put 'a' in screen
    lda #'a'
    ldy #0
    sta (screen),y
    // screen++;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // *screen = 'a'
    // Put another 'a' in screen
    lda #'a'
    ldy #0
    sta (screen),y
    // }
    rts
}
