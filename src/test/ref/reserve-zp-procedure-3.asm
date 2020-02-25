// Demonstrates a procedure reserving addresses on zeropage
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label i = 5
    // for( volatile byte i : 0..2)
    lda #0
    sta.z i
  __b1:
    // sub1(i)
    lda.z i
    jsr sub1
    // SCREEN[i] = sub1(i)
    ldy.z i
    sta SCREEN,y
    // for( volatile byte i : 0..2)
    inc.z i
    lda #3
    cmp.z i
    bne __b1
    // }
    rts
}
// sub1(byte register(A) i)
sub1: {
    // i+i
    asl
    // }
    rts
}
