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
    // while(i<10)
    cpx #$a
    bcc __b2
    // SCREEN[999] = b
    sta SCREEN+$3e7
    // }
    rts
  __b2:
    // b = SCREEN[i++]
    lda SCREEN,x
    // b = SCREEN[i++];
    inx
    jmp __b1
}
