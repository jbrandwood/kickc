// Test effective live range and register allocation
// Here out::b, print::b and main::b can have the same allocation
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label b = 3
    .label a = 2
    lda #0
    sta.z a
  __b1:
    lda #0
    sta.z b
  __b2:
    ldy #0
  __b3:
    // ca = c+a
    tya
    clc
    adc.z a
    // print(b, ca)
    ldx.z b
    jsr print
    // for( char c: 0..100 )
    iny
    cpy #$65
    bne __b3
    // for( char b: 0..100 )
    inc.z b
    lda #$65
    cmp.z b
    bne __b2
    // for(char a: 0..100 )
    inc.z a
    cmp.z a
    bne __b1
    // }
    rts
}
// print(byte register(X) b, byte register(A) ca)
print: {
    // out(b, ca)
    jsr out
    // }
    rts
}
// out(byte register(X) b, byte register(A) ca)
out: {
    // SCREEN[b] = ca
    sta SCREEN,x
    // }
    rts
}
