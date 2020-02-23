.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    // asm
    lda #'a'
    sta SCREEN
    // for( byte i:0..3)
    inx
    cpx #4
    bne __b1
    // }
    rts
}
