// Demonstrates a procedure reserving addresses on zeropage
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label i = 8
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
    // sub2(i)
    ldx.z i
    jsr sub2
    // (SCREEN+40)[i] = sub2(i)
    ldy.z i
    sta SCREEN+$28,y
    // for( volatile byte i : 0..2)
    inc.z i
    lda #3
    cmp.z i
    bne __b1
    // }
    rts
}
// sub2(byte register(X) i)
sub2: {
    // i+i
    txa
    asl
    // i+i+i
    stx.z $ff
    clc
    adc.z $ff
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
