.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label a = 2
    ldy #0
  __b1:
    ldx #0
  __b2:
    lda #0
    sta.z a
  __b3:
    // val1 = a+x
    tya
    clc
    adc.z a
    // print(y, val1)
    jsr print
    // for( byte a: 0..100 )
    inc.z a
    lda #$65
    cmp.z a
    bne __b3
    // for( byte y: 0..100 )
    inx
    cpx #$65
    bne __b2
    // for( register(Y) byte x: 0..100 )
    iny
    cpy #$65
    bne __b1
    // }
    rts
}
// print(byte register(X) idx, byte register(A) val)
print: {
    .label SCREEN = $400
    // SCREEN[idx] = val
    sta SCREEN,x
    // }
    rts
}
