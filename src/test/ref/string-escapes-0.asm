// Test using some simple supported string escapes \r \f \n \' \"
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    // while(MESSAGE[i])
    lda MESSAGE,x
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // SCREEN[i] = MESSAGE[i++]
    lda MESSAGE,x
    sta SCREEN,x
    // SCREEN[i] = MESSAGE[i++];
    inx
    jmp __b1
}
  MESSAGE: .text @"\r\f\n\"'\\"
  .byte 0
