// Test effective live range and register allocation
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label y = 3
    .label x = 2
    lda #0
    sta.z x
  __b1:
    lda #0
    sta.z y
  __b2:
    ldy #0
  __b3:
    // val1 = a+x
    tya
    clc
    adc.z x
    // print(y, val1)
    ldx.z y
    jsr print
    // for( char a: 0..100 )
    iny
    cpy #$65
    bne __b3
    // for( char y: 0..100 )
    inc.z y
    lda #$65
    cmp.z y
    bne __b2
    // for(char x: 0..100 )
    inc.z x
    cmp.z x
    bne __b1
    // }
    rts
}
// print(byte register(X) idx, byte register(A) val)
print: {
    // SCREEN[idx] = val
    sta SCREEN,x
    // }
    rts
}
