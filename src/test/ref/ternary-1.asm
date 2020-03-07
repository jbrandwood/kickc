// Tests the ternary operator
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    // i<5?'a':'b'
    cpx #5
    bcc __b2
    lda #'b'
    jmp __b3
  __b2:
    // i<5?'a':'b'
    lda #'a'
  __b3:
    // SCREEN[i] = i<5?'a':'b'
    sta SCREEN,x
    // for( byte i: 0..9)
    inx
    cpx #$a
    bne __b1
    // }
    rts
}
