// Shows a font where each char contains the number of the char (00-ff)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label D018 = $d018
  .label SCREEN = $400
  .label CHARSET = $2000
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>CHARSET)/4&$f
    lda #toD0181_return
    sta D018
    jsr init_font_hex
    ldx #0
  // Show all chars on screen
  __b1:
    txa
    sta SCREEN,x
    inx
    cpx #0
    bne __b1
    rts
}
// Make charset from proto chars
// init_font_hex(byte* zeropage(5) charset)
init_font_hex: {
    .label __0 = $b
    .label idx = $a
    .label proto_lo = 7
    .label charset = 5
    .label c1 = 9
    .label proto_hi = 2
    .label c = 4
    lda #0
    sta.z c
    lda #<FONT_HEX_PROTO
    sta.z proto_hi
    lda #>FONT_HEX_PROTO
    sta.z proto_hi+1
    lda #<CHARSET
    sta.z charset
    lda #>CHARSET
    sta.z charset+1
  __b1:
    lda #0
    sta.z c1
    lda #<FONT_HEX_PROTO
    sta.z proto_lo
    lda #>FONT_HEX_PROTO
    sta.z proto_lo+1
  __b2:
    lda #0
    tay
    sta (charset),y
    lda #1
    sta.z idx
    ldx #0
  __b3:
    txa
    tay
    lda (proto_hi),y
    asl
    asl
    asl
    asl
    sta.z __0
    txa
    tay
    lda (proto_lo),y
    asl
    ora.z __0
    ldy.z idx
    sta (charset),y
    inc.z idx
    inx
    cpx #5
    bne __b3
    lda #0
    ldy.z idx
    sta (charset),y
    iny
    sta (charset),y
    lda #5
    clc
    adc.z proto_lo
    sta.z proto_lo
    bcc !+
    inc.z proto_lo+1
  !:
    lda #8
    clc
    adc.z charset
    sta.z charset
    bcc !+
    inc.z charset+1
  !:
    inc.z c1
    lda #$10
    cmp.z c1
    bne __b2
    lda #5
    clc
    adc.z proto_hi
    sta.z proto_hi
    bcc !+
    inc.z proto_hi+1
  !:
    inc.z c
    lda #$10
    cmp.z c
    bne __b1
    rts
}
  // Bit patterns for symbols 0-f (3x5 pixels) used in font hex
  FONT_HEX_PROTO: .byte 2, 5, 5, 5, 2, 6, 2, 2, 2, 7, 6, 1, 2, 4, 7, 6, 1, 2, 1, 6, 5, 5, 7, 1, 1, 7, 4, 6, 1, 6, 3, 4, 6, 5, 2, 7, 1, 1, 1, 1, 2, 5, 2, 5, 2, 2, 5, 3, 1, 1, 2, 5, 7, 5, 5, 6, 5, 6, 5, 6, 2, 5, 4, 5, 2, 6, 5, 5, 5, 6, 7, 4, 6, 4, 7, 7, 4, 6, 4, 4
