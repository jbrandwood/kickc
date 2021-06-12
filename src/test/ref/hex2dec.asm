// Testing hex to decimal conversion
  // Commodore 64 PRG executable file
.file [name="hex2dec.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label control = $d011
  .label raster = $d012
  .label BORDER_COLOR = $d020
.segment Code
main: {
    .label __1 = 6
    .label time_start = 7
    // asm
    sei
    // cls()
    jsr cls
  __b1:
    // *control&0x80
    lda #$80
    and control
    sta.z __1
    // *raster>>1
    lda raster
    lsr
    // unsigned char rst = (*control&0x80)|(*raster>>1)
    ora.z __1
    // while (rst!=0x30)
    cmp #$30
    bne __b1
    // *BORDER_COLOR = 1
    lda #1
    sta BORDER_COLOR
    // unsigned char time_start = *raster
    lda raster
    sta.z time_start
    // utoa16w(00000, screen)
    lda #<$400
    sta.z utoa16w.dst
    lda #>$400
    sta.z utoa16w.dst+1
    lda #<0
    sta.z utoa16w.value
    sta.z utoa16w.value+1
    jsr utoa16w
    // (*BORDER_COLOR)++;
    inc BORDER_COLOR
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
    // (*BORDER_COLOR)++;
    inc BORDER_COLOR
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
    // (*BORDER_COLOR)++;
    inc BORDER_COLOR
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
    // (*BORDER_COLOR)++;
    inc BORDER_COLOR
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
    // unsigned char time_end = *raster
    ldx raster
    // *BORDER_COLOR = 0
    lda #0
    sta BORDER_COLOR
    // unsigned char time = time_end - time_start
    txa
    sec
    sbc.z time_start
    // utoa10w((unsigned int)time, screen+80)
    sta.z utoa10w.value
    lda #0
    sta.z utoa10w.value+1
    jsr utoa10w
    ldx #0
  __b3:
    // for( byte i=0; msg[i]!=0; i++ )
    lda msg,x
    cmp #0
    bne __b4
    jmp __b1
  __b4:
    // (screen+80+3)[i] = msg[i]
    lda msg,x
    sta $400+$28+$28+$28+$28+$50+3,x
    // for( byte i=0; msg[i]!=0; i++ )
    inx
    jmp __b3
  .segment Data
    msg: .text "raster lines"
    .byte 0
}
.segment Code
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
// utoa16w(word zp(2) value, byte* zp(8) dst)
utoa16w: {
    .label dst = 8
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
// Decimal utoa() without using multiply or divide
// utoa10w(word zp(2) value, byte* zp(4) dst)
utoa10w: {
    .label value = 2
    .label digit = 6
    .label dst = 4
    .label bStarted = 7
    lda #<$400+$28+$28+$28+$28+$50
    sta.z dst
    lda #>$400+$28+$28+$28+$28+$50
    sta.z dst+1
    lda #0
    sta.z bStarted
    sta.z digit
    tax
  __b1:
    // value>=UTOA10_SUB[i]
    txa
    asl
    tay
    // while(value>=UTOA10_SUB[i])
    lda UTOA10_SUB+1,y
    cmp.z value+1
    bne !+
    lda UTOA10_SUB,y
    cmp.z value
    beq __b2
  !:
    bcc __b2
    // i&1
    txa
    and #1
    // if((i&1)!=0)
    cmp #0
    beq __b6
    // if(bStarted!=0)
    lda.z bStarted
    beq __b7
    // *dst++ = DIGITS[digit]
    ldy.z digit
    lda DIGITS,y
    ldy #0
    sta (dst),y
    // *dst++ = DIGITS[digit];
    inc.z dst
    bne !+
    inc.z dst+1
  !:
  __b7:
    lda #0
    sta.z digit
  __b6:
    // for( unsigned char i: 0..7)
    inx
    cpx #8
    bne __b1
    // *dst++ = DIGITS[(unsigned char) value]
    ldx.z value
    lda DIGITS,x
    ldy #0
    sta (dst),y
    // *dst++ = DIGITS[(unsigned char) value];
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // *dst = 0
    lda #0
    tay
    sta (dst),y
    // }
    rts
  __b2:
    // digit += UTOA10_VAL[i]
    lda UTOA10_VAL,x
    clc
    adc.z digit
    sta.z digit
    // value -= UTOA10_SUB[i]
    sec
    lda.z value
    sbc UTOA10_SUB,y
    sta.z value
    lda.z value+1
    sbc UTOA10_SUB+1,y
    sta.z value+1
    lda #1
    sta.z bStarted
    jmp __b1
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
.segment Data
  // Digits used for utoa()
  DIGITS: .text "0123456789abcdef"
  .byte 0
  // Subtraction values used for decimal utoa()
  UTOA10_SUB: .word $7530, $2710, $bb8, $3e8, $12c, $64, $1e, $a
  // Digit addition values used for decimal utoa()
  UTOA10_VAL: .byte 3, 1, 3, 1, 3, 1, 3, 1
