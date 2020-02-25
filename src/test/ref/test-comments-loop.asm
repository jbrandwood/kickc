.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  // Do some sums
  __b1:
    // SCREEN[b] = 'a'
    lda #'a'
    sta SCREEN,x
    // for(byte b: 0..10 )
    inx
    cpx #$b
    bne __b1
    // }
    rts
}
