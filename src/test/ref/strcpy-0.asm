.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label dst1 = $400
  .label dst2 = $428
main: {
    // str_cpy(dst1, "hello")
    lda #<dst1
    sta.z str_cpy.dst
    lda #>dst1
    sta.z str_cpy.dst+1
    lda #<src
    sta.z str_cpy.src
    lda #>src
    sta.z str_cpy.src+1
    jsr str_cpy
    // str_cpy(dst2, "world")
    lda #<dst2
    sta.z str_cpy.dst
    lda #>dst2
    sta.z str_cpy.dst+1
    lda #<src1
    sta.z str_cpy.src
    lda #>src1
    sta.z str_cpy.src+1
    jsr str_cpy
    // }
    rts
    src: .text "hello"
    .byte 0
    src1: .text "world"
    .byte 0
}
// str_cpy(byte* zp(4) dst, byte* zp(2) src)
str_cpy: {
    .label dst = 4
    .label src = 2
  __b1:
    // *dst++ = *src++
    ldy #0
    lda (src),y
    sta (dst),y
    // while ( *dst++ = *src++ )
    lda (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    inc.z src
    bne !+
    inc.z src+1
  !:
    cmp #0
    bne __b1
    // }
    rts
}
