/// @file
/// Simple binary multiplication implementation
  // Commodore 64 PRG executable file
.file [name="robozzle64-label-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_UNSIGNED_INT = 2
.segment Code
main: {
    .label z1 = 2
    .label screen = 7
    .label z2 = 2
    .label y = 6
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    lda #0
    sta.z y
  __b1:
    // word z1 = mul8u(y,40)
    ldx.z y
    jsr mul8u
    // word z1 = mul8u(y,40)
    // *screen++ = z1
    ldy #0
    lda.z z1
    sta (screen),y
    iny
    lda.z z1+1
    sta (screen),y
    // word z2 = mul8u(y,40)
    ldx.z y
    jsr mul8u
    // word z2 = mul8u(y,40)
    // *screen++ = z2
    ldy #SIZEOF_UNSIGNED_INT
    lda.z z2
    sta (screen),y
    iny
    lda.z z2+1
    sta (screen),y
    // *screen++ = z2;
    lda #SIZEOF_UNSIGNED_INT+SIZEOF_UNSIGNED_INT
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    // for( byte y: 0..5)
    inc.z y
    lda #6
    cmp.z y
    bne __b1
    // }
    rts
}
// Perform binary multiplication of two unsigned 8-bit chars into a 16-bit unsigned int
// __zp(2) unsigned int mul8u(__register(X) char a, char b)
mul8u: {
    .label mb = 4
    .label res = 2
    .label return = 2
    lda #<$28
    sta.z mb
    lda #>$28
    sta.z mb+1
    lda #<0
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
