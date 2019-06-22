// Creates a font where each char contains the number of the char (00-ff)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label D018 = $d018
  .label SCREEN = $400
  .label CHARSET = $2000
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>CHARSET)/4&$f
    .label proto_lo = 5
    .label charset = 7
    .label proto_hi = 2
    .label c = 4
    lda #toD0181_return
    sta D018
    lda #0
    sta c
    lda #<CHARSET
    sta charset
    lda #>CHARSET
    sta charset+1
    lda #<FONT_HEX_PROTO
    sta proto_hi
    lda #>FONT_HEX_PROTO
    sta proto_hi+1
  b1:
    ldx #0
    lda #<FONT_HEX_PROTO
    sta proto_lo
    lda #>FONT_HEX_PROTO
    sta proto_lo+1
  b2:
    ldy #0
  b3:
    lda (proto_hi),y
    asl
    asl
    asl
    ora (proto_lo),y
    sta (charset),y
    iny
    cpy #5
    bne b3
    lda #0
    ldy #5
    sta (charset),y
    ldy #6
    sta (charset),y
    ldy #7
    sta (charset),y
    lda #5
    clc
    adc proto_lo
    sta proto_lo
    bcc !+
    inc proto_lo+1
  !:
    lda #8
    clc
    adc charset
    sta charset
    bcc !+
    inc charset+1
  !:
    inx
    cpx #$10
    bne b2
    lda #5
    clc
    adc proto_hi
    sta proto_hi
    bcc !+
    inc proto_hi+1
  !:
    inc c
    lda #$10
    cmp c
    bne b1
    ldx #0
  // Show all chars on screen
  b6:
    txa
    sta SCREEN,x
    inx
    cpx #0
    bne b6
    rts
}
  // Bit patterns for symbols 0-f (3x5 pixels)
  FONT_HEX_PROTO: .byte 2, 5, 5, 5, 2, 6, 2, 2, 2, 7, 6, 1, 2, 4, 7, 6, 1, 2, 1, 6, 5, 5, 7, 1, 1, 7, 4, 6, 1, 6, 3, 4, 6, 5, 2, 7, 1, 1, 1, 1, 2, 5, 2, 5, 2, 2, 5, 3, 1, 1, 2, 5, 7, 5, 5, 6, 5, 6, 5, 6, 3, 4, 4, 4, 3, 6, 5, 5, 5, 6, 7, 4, 7, 4, 7, 7, 4, 7, 4, 4
