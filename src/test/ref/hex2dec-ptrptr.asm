// Testing binary to hex conversion using pointer to pointer
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
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
// utoa16w(word zp(2) value, byte* zp(4) dst)
utoa16w: {
    .label dst = 4
    .label value = 2
    // >value
    lda.z value+1
    // utoa16n((>value)>>4, &dst, started)
    lsr
    lsr
    lsr
    lsr
    ldx #0
    jsr utoa16n
    // utoa16n((>value)>>4, &dst, started)
    // started = utoa16n((>value)>>4, &dst, started)
    // >value
    lda.z value+1
    // utoa16n((>value)&0x0f, &dst, started)
    and #$f
    jsr utoa16n
    // utoa16n((>value)&0x0f, &dst, started)
    // started = utoa16n((>value)&0x0f, &dst, started)
    // <value
    lda.z value
    // utoa16n((<value)>>4, &dst, started)
    lsr
    lsr
    lsr
    lsr
    jsr utoa16n
    // <value
    lda.z value
    // utoa16n((<value)&0x0f, &dst, 1)
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
// utoa16n(byte register(A) nybble, byte register(X) started)
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
  // Digits used for utoa()
  DIGITS: .text "0123456789abcdef"
  .byte 0
