// Test all types of pointers
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // A constant pointer
    .label SCREEN = $400
    lda #0
    ldx #2
  __b1:
    cpx #$a
    bcc __b2
    sta SCREEN+$3e7
    rts
  __b2:
    lda SCREEN,x
    inx
    jmp __b1
}
