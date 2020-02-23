// Illustrates problem with > comparison of signed chars.
// Reported by Danny Spijksma
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #-$80
  __b1:
    // debug(dy)
    jsr debug
    // for(signed char dy:-128..127)
    inx
    cpx #-$80
    bne __b1
    // }
    rts
}
// debug(signed byte register(X) dy)
debug: {
    // if (dy > -120)
    txa
    sec
    sbc #-$78
    beq __breturn
    bvc !+
    eor #$80
  !:
    bmi __breturn
    // SCREEN[i] = 10
    lda #$a
    sta SCREEN,x
  __breturn:
    // }
    rts
}
