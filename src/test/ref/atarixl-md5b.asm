// 8 bit converted md5 calculator
  // Commodore 64 PRG executable file
.file [name="atarixl-md5b.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label line = 9
  .label idx = $b
.segment Code
__start: {
    // __ma char * line = 0x0400
    lda #<$400
    sta.z line
    lda #>$400
    sta.z line+1
    // __ma char idx = 0
    lda #0
    sta.z idx
    jsr main
    rts
}
main: {
    .label s = 2
    lda #<$400
    sta.z s
    lda #>$400
    sta.z s+1
  __b1:
    // for(char* s=0x0400;s<0x0800;s++)
    lda.z s+1
    cmp #>$800
    bcc __b2
    bne !+
    lda.z s
    cmp #<$800
    bcc __b2
  !:
    // md5()
    jsr md5
  __b4:
    jmp __b4
  __b2:
    // *s=' '
    lda #' '
    ldy #0
    sta (s),y
    // for(char* s=0x0400;s<0x0800;s++)
    inc.z s
    bne !+
    inc.z s+1
  !:
    jmp __b1
}
md5: {
    .const c = $98
    .label b = 7
    .label a = 5
    .label b_1 = 4
    lda #c
    sta.z a
    lda #$ef
    sta.z b_1
    ldy #$67
    ldx #0
  __b1:
    // for(char i = 0; i<4; i++)
    cpx #4
    bcc __b2
    // }
    rts
  __b2:
    // print(i, a, b, c)
    sty.z print.a
    lda.z b_1
    sta.z print.b
    lda.z a
    sta.z print.c
    jsr print
    // i&1
    txa
    and #1
    // if(i&1)
    cmp #0
    // b = b + 1
    ldy.z b_1
    iny
    sty.z b
    // print(i, a, b, c)
    lda.z a
    sta.z print.a
    lda.z b_1
    sta.z print.c
    jsr print
    // for(char i = 0; i<4; i++)
    inx
    ldy.z a
    lda.z b
    sta.z b_1
    sta.z a
    jmp __b1
}
// print(byte register(X) i, byte zp(6) a, byte zp(7) b, byte zp(8) c)
print: {
    .label a = 6
    .label b = 7
    .label c = 8
    // l/0x10
    txa
    lsr
    lsr
    lsr
    lsr
    // line[idx++] = HEX[l/0x10]
    tay
    lda HEX,y
    ldy.z idx
    sta (line),y
    // line[idx++] = HEX[l/0x10];
    inc.z idx
    // l&0x0f
    txa
    and #$f
    // line[idx++] = HEX[l&0x0f]
    tay
    lda HEX,y
    ldy.z idx
    sta (line),y
    // line[idx++] = HEX[l&0x0f];
    inc.z idx
    // line[idx++] = ' '
    lda #' '
    ldy.z idx
    sta (line),y
    // line[idx++] = ' ';
    inc.z idx
    // l/0x10
    lda.z a
    lsr
    lsr
    lsr
    lsr
    // line[idx++] = HEX[l/0x10]
    tay
    lda HEX,y
    ldy.z idx
    sta (line),y
    // line[idx++] = HEX[l/0x10];
    inc.z idx
    // l&0x0f
    lda #$f
    and.z a
    // line[idx++] = HEX[l&0x0f]
    tay
    lda HEX,y
    ldy.z idx
    sta (line),y
    // line[idx++] = HEX[l&0x0f];
    inc.z idx
    // line[idx++] = ' '
    lda #' '
    ldy.z idx
    sta (line),y
    // line[idx++] = ' ';
    inc.z idx
    // l/0x10
    lda.z b
    lsr
    lsr
    lsr
    lsr
    // line[idx++] = HEX[l/0x10]
    tay
    lda HEX,y
    ldy.z idx
    sta (line),y
    // line[idx++] = HEX[l/0x10];
    inc.z idx
    // l&0x0f
    lda #$f
    and.z b
    // line[idx++] = HEX[l&0x0f]
    tay
    lda HEX,y
    ldy.z idx
    sta (line),y
    // line[idx++] = HEX[l&0x0f];
    inc.z idx
    // line[idx++] = ' '
    lda #' '
    ldy.z idx
    sta (line),y
    // line[idx++] = ' ';
    inc.z idx
    // l/0x10
    lda.z c
    lsr
    lsr
    lsr
    lsr
    // line[idx++] = HEX[l/0x10]
    tay
    lda HEX,y
    ldy.z idx
    sta (line),y
    // line[idx++] = HEX[l/0x10];
    inc.z idx
    // l&0x0f
    lda #$f
    and.z c
    // line[idx++] = HEX[l&0x0f]
    tay
    lda HEX,y
    ldy.z idx
    sta (line),y
    // line[idx++] = HEX[l&0x0f];
    inc.z idx
    // line[idx++] = ' '
    lda #' '
    ldy.z idx
    sta (line),y
    // line[idx++] = ' ';
    inc.z idx
    // line += 40
    lda #$28
    clc
    adc.z line
    sta.z line
    bcc !+
    inc.z line+1
  !:
    // idx=0
    lda #0
    sta.z idx
    // }
    rts
}
.segment Data
  HEX: .text "0123456789abcdef"
  .byte 0
