  // Commodore 64 PRG executable file
.file [name="strcpy-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label dst1 = $400
  .label dst2 = $428
.segment Code
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
  .segment Data
    src: .text "hello"
    .byte 0
    src1: .text "world"
    .byte 0
}
.segment Code
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
