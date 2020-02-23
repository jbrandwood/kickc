// Minimal test of mul8u
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label __0 = 4
    .label i = 3
    .label a = 2
    lda #0
    sta.z i
    sta.z a
  __b1:
    ldy #0
  __b2:
    // mul8u(a,b)
    ldx.z a
    tya
    jsr mul8u
    // screen[i++] = mul8u(a,b)
    lda.z i
    asl
    tax
    lda.z __0
    sta screen,x
    lda.z __0+1
    sta screen+1,x
    // screen[i++] = mul8u(a,b);
    inc.z i
    // for (byte b: 0..5)
    iny
    cpy #6
    bne __b2
    // for(byte a: 0..5)
    inc.z a
    lda #6
    cmp.z a
    bne __b1
    // }
    rts
}
// Perform binary multiplication of two unsigned 8-bit bytes into a 16-bit unsigned word
// mul8u(byte register(X) a, byte register(A) b)
mul8u: {
    .label mb = 6
    .label res = 4
    .label return = 4
    // mb = b
    sta.z mb
    lda #0
    sta.z mb+1
    sta.z res
    sta.z res+1
  __b1:
    // while(a!=0)
    cpx #0
    bne __b2
    // }
    rts
  __b2:
    // a&1
    txa
    and #1
    // if( (a&1) != 0)
    cmp #0
    beq __b3
    // res = res + mb
    lda.z res
    clc
    adc.z mb
    sta.z res
    lda.z res+1
    adc.z mb+1
    sta.z res+1
  __b3:
    // a = a>>1
    txa
    lsr
    tax
    // mb = mb<<1
    asl.z mb
    rol.z mb+1
    jmp __b1
}
