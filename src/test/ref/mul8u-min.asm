// Minimal test of mul8u
  // Commodore 64 PRG executable file
.file [name="mul8u-min.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    .label __0 = 2
    .label i = 6
    .label a = 7
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
// Perform binary multiplication of two unsigned 8-bit chars into a 16-bit unsigned int
// __zp(2) unsigned int mul8u(__register(X) char a, __register(A) char b)
mul8u: {
    .label mb = 4
    .label res = 2
    .label return = 2
    // unsigned int mb = b
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
    clc
    lda.z res
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
