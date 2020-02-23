// Tests that array-indexing by a word variable that is a sum of a constant word and a byte is turned back into derefidx
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldx #0
  __b1:
    // screen[40*10+i] = 'a'
    lda #'a'
    sta screen+$28*$a,x
    // for( byte i : 0..39)
    inx
    cpx #$28
    bne __b1
    // }
    rts
}
