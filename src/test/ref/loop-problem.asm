// A simple loop results in NullPointerException during loop analysis
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // *SCREEN = '0'
    lda #'0'
    sta SCREEN
    // d()
    jsr d
    // b()
    jsr b
    // }
    rts
}
d: {
    // (*SCREEN)++;
    inc SCREEN
    // }
    rts
}
b: {
    ldx #0
  __b1:
    // d()
    jsr d
    // for( byte i: 0..3)
    inx
    cpx #4
    bne __b1
    // }
    rts
}
