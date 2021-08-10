// Testing binary to hex conversion using pointer to pointer
  // Commodore 64 PRG executable file
.file [name="hex2dec-ptrptr.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // cls()
    jsr cls
    // utoa16w(00000, screen)
    lda #<$400
    sta.z utoa16w.dst
    lda #>$400
    sta.z utoa16w.dst+1
    lda #<0
    sta.z utoa16w.value
    sta.z utoa16w.value+1
    jsr utoa16w
    // utoa16w(01234, screen)
    lda #<$400+$28
    sta.z utoa16w.dst
    lda #>$400+$28
    sta.z utoa16w.dst+1
    lda #<$4d2
    sta.z utoa16w.value
    lda #>$4d2
    sta.z utoa16w.value+1
    jsr utoa16w
    // utoa16w(05678, screen)
    lda #<$400+$28+$28
    sta.z utoa16w.dst
    lda #>$400+$28+$28
    sta.z utoa16w.dst+1
    lda #<$162e
    sta.z utoa16w.value
    lda #>$162e
    sta.z utoa16w.value+1
    jsr utoa16w
    // utoa16w(09999, screen)
    lda #<$400+$28+$28+$28
    sta.z utoa16w.dst
    lda #>$400+$28+$28+$28
    sta.z utoa16w.dst+1
    lda #<$270f
    sta.z utoa16w.value
    lda #>$270f
    sta.z utoa16w.value+1
    jsr utoa16w
    // utoa16w(58888, screen)
    lda #<$400+$28+$28+$28+$28
    sta.z utoa16w.dst
    lda #>$400+$28+$28+$28+$28
    sta.z utoa16w.dst+1
    lda #<$e608
    sta.z utoa16w.value
    lda #>$e608
    sta.z utoa16w.value+1
    jsr utoa16w
    // }
    rts
}
cls: {
    .label screen = $400
    .label sc = 2
    lda #<screen
    sta.z sc
    lda #>screen
    sta.z sc+1
  __b1:
    // *sc=' '
    lda #' '
    ldy #0
    sta (sc),y
    // for( unsigned char *sc: screen..screen+999)
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    lda.z sc+1
    cmp #>screen+$3e7+1
    bne __b1
    lda.z sc
    cmp #<screen+$3e7+1
    bne __b1
    // }
    rts
}
// Hexadecimal utoa() for an unsigned int (16bits)
// void utoa16w(__zp(2) unsigned int value, __zp(4) char * volatile dst)
utoa16w: {
    .label dst = 4
    .label value = 2
    // BYTE1(value)
    lda.z value+1
    // utoa16n(BYTE1(value)>>4, &dst, started)
    lsr
    lsr
    lsr
    lsr
    ldx #0
    jsr utoa16n
    // utoa16n(BYTE1(value)>>4, &dst, started)
    // started = utoa16n(BYTE1(value)>>4, &dst, started)
    // BYTE1(value)
    lda.z value+1
    // utoa16n(BYTE1(value)&0x0f, &dst, started)
    and #$f
    jsr utoa16n
    // utoa16n(BYTE1(value)&0x0f, &dst, started)
    // started = utoa16n(BYTE1(value)&0x0f, &dst, started)
    // BYTE0(value)
    lda.z value
    // utoa16n(BYTE0(value)>>4, &dst, started)
    lsr
    lsr
    lsr
    lsr
    jsr utoa16n
    // BYTE0(value)
    lda.z value
    // utoa16n(BYTE0(value)&0x0f, &dst, 1)
    and #$f
    ldx #1
    jsr utoa16n
    // *dst = 0
    lda #0
    tay
    sta (dst),y
    // }
    rts
}
// Hexadecimal utoa() for a single nybble
// __register(X) char utoa16n(__register(A) char nybble, unsigned int **dst, __register(X) char started)
utoa16n: {
    // if(nybble!=0)
    cmp #0
    beq __b1
    ldx #1
  __b1:
    // if(started!=0)
    cpx #0
    beq __breturn
    // *(*dst)++ = DIGITS[nybble]
    tay
    lda DIGITS,y
    ldy.z utoa16w.dst
    sty.z $fe
    ldy.z utoa16w.dst+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // *(*dst)++ = DIGITS[nybble];
    inc.z utoa16w.dst
    bne !+
    inc.z utoa16w.dst+1
  !:
  __breturn:
    // }
    rts
}
.segment Data
  // Digits used for utoa()
  DIGITS: .text "0123456789abcdef"
  .byte 0
