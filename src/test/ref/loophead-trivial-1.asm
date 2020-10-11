// Test a trivial loop head constant
// For trivially constant loop heads for(;;) loops can be written to run body before comparison
// The simplest possible for-loop with a constant loop head.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    // for(char i=0;i<40;i++)
    cpx #$28
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i] = '*'
    lda #'*'
    sta SCREEN,x
    // for(char i=0;i<40;i++)
    inx
    jmp __b1
}
