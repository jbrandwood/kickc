// Illustrates introducing local scopes inside loops etc
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    // SCREEN[i] = 'a'
    lda #'a'
    sta SCREEN,x
    // for (byte i: 0..5)
    inx
    cpx #6
    bne __b1
    ldx #0
  __b2:
    // SCREEN[40+i] = 'b'
    lda #'b'
    sta SCREEN+$28,x
    // for (byte i: 0..5)
    inx
    cpx #6
    bne __b2
    // }
    rts
}
