// Find atan2(x, y) using the CORDIC method
// See http://bsvi.ru/uploads/CORDIC--_10EBA/cordic.pdf
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // The number of iterations performed during 16-bit CORDIC atan2 calculation
  .const CORDIC_ITERATIONS_16 = $f
  .label RASTER = $d012
  .label D018 = $d018
  .label CHARSET = $2000
  .label SCREEN = $2800
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>CHARSET)/4&$f
    .label clear_char = 2
    jsr init_font_hex
    lda #toD0181_return
    sta D018
    jsr init_angle_screen
    lda #<CHARSET
    sta clear_char
    lda #>CHARSET
    sta clear_char+1
  b2:
    lda #$ff
    cmp RASTER
    bne b2
    lda clear_char+1
    cmp #>CHARSET+$800
    bcc !+
    bne b2
    lda clear_char
    cmp #<CHARSET+$800
    bcs b2
  !:
    lda #0
    tay
    sta (clear_char),y
    inc clear_char
    bne !+
    inc clear_char+1
  !:
    jmp b2
}
// Populates 1000 bytes (a screen) with values representing the angle to the center.
// Utilizes symmetry around the  center
init_angle_screen: {
    .label _10 = $f
    .label xw = $1a
    .label yw = $1c
    .label angle_w = $f
    .label ang_w = $1e
    .label xb = 9
    .label screen_topline = 5
    .label screen_bottomline = 7
    .label y = 4
    lda #<SCREEN+$28*$c
    sta screen_bottomline
    lda #>SCREEN+$28*$c
    sta screen_bottomline+1
    lda #<SCREEN+$28*$c
    sta screen_topline
    lda #>SCREEN+$28*$c
    sta screen_topline+1
    lda #0
    sta y
  b1:
    lda #$27
    sta xb
    ldx #0
  b2:
    txa
    asl
    eor #$ff
    clc
    adc #$27+1
    ldy #0
    sta xw+1
    sty xw
    lda y
    asl
    sta yw+1
    sty yw
    jsr atan2_16
    lda #$80
    clc
    adc _10
    sta _10
    bcc !+
    inc _10+1
  !:
    lda _10+1
    sta ang_w
    lda #$80
    clc
    adc ang_w
    stx $ff
    ldy $ff
    sta (screen_topline),y
    lda #$80
    sec
    sbc ang_w
    stx $ff
    ldy $ff
    sta (screen_bottomline),y
    lda ang_w
    eor #$ff
    clc
    adc #1
    ldy xb
    sta (screen_topline),y
    lda ang_w
    sta (screen_bottomline),y
    inx
    dec xb
    cpx #$13+1
    bcc b2
    lda screen_topline
    sec
    sbc #<$28
    sta screen_topline
    lda screen_topline+1
    sbc #>$28
    sta screen_topline+1
    lda #$28
    clc
    adc screen_bottomline
    sta screen_bottomline
    bcc !+
    inc screen_bottomline+1
  !:
    inc y
    lda #$d
    cmp y
    bne b1
    rts
}
// Find the atan2(x, y) - which is the angle of the line from (0,0) to (x,y)
// Finding the angle requires a binary search using CORDIC_ITERATIONS_16
// Returns the angle in hex-degrees (0=0, 0x8000=PI, 0x10000=2*PI)
// atan2_16(signed word zeropage($1a) x, signed word zeropage($1c) y)
atan2_16: {
    .label _2 = $a
    .label _7 = $c
    .label yi = $a
    .label xi = $c
    .label xd = $1f
    .label yd = $21
    .label angle = $f
    .label i = $e
    .label return = $f
    .label x = $1a
    .label y = $1c
    lda y+1
    bmi !b1+
    jmp b1
  !b1:
    sec
    lda #0
    sbc y
    sta _2
    lda #0
    sbc y+1
    sta _2+1
  b3:
    lda x+1
    bmi !b4+
    jmp b4
  !b4:
    sec
    lda #0
    sbc x
    sta _7
    lda #0
    sbc x+1
    sta _7+1
  b6:
    lda #0
    sta angle
    sta angle+1
    sta i
  b10:
    lda yi+1
    bne b11
    lda yi
    bne b11
  b12:
    lsr angle+1
    ror angle
    lda x+1
    bpl b7
    sec
    lda #<$8000
    sbc angle
    sta angle
    lda #>$8000
    sbc angle+1
    sta angle+1
  b7:
    lda y+1
    bpl b8
    sec
    lda #0
    sbc angle
    sta angle
    lda #0
    sbc angle+1
    sta angle+1
  b8:
    rts
  b11:
    ldy i
    lda xi
    sta xd
    lda xi+1
    sta xd+1
    cpy #0
    beq !e+
  !:
    lda xd+1
    cmp #$80
    ror xd+1
    ror xd
    dey
    bne !-
  !e:
    ldy i
    lda yi
    sta yd
    lda yi+1
    sta yd+1
    cpy #0
    beq !e+
  !:
    lda yd+1
    cmp #$80
    ror yd+1
    ror yd
    dey
    bne !-
  !e:
    lda yi+1
    bpl b13
    lda xi
    sec
    sbc yd
    sta xi
    lda xi+1
    sbc yd+1
    sta xi+1
    lda yi
    clc
    adc xd
    sta yi
    lda yi+1
    adc xd+1
    sta yi+1
    lda i
    asl
    tay
    sec
    lda angle
    sbc CORDIC_ATAN2_ANGLES_16,y
    sta angle
    lda angle+1
    sbc CORDIC_ATAN2_ANGLES_16+1,y
    sta angle+1
  b14:
    inc i
    lda #CORDIC_ITERATIONS_16-1+1
    cmp i
    bne !b12+
    jmp b12
  !b12:
    jmp b10
  b13:
    lda xi
    clc
    adc yd
    sta xi
    lda xi+1
    adc yd+1
    sta xi+1
    lda yi
    sec
    sbc xd
    sta yi
    lda yi+1
    sbc xd+1
    sta yi+1
    lda i
    asl
    tay
    clc
    lda angle
    adc CORDIC_ATAN2_ANGLES_16,y
    sta angle
    lda angle+1
    adc CORDIC_ATAN2_ANGLES_16+1,y
    sta angle+1
    jmp b14
  b4:
    lda x
    sta xi
    lda x+1
    sta xi+1
    jmp b6
  b1:
    lda y
    sta yi
    lda y+1
    sta yi+1
    jmp b3
}
// Make charset from proto chars
// init_font_hex(byte* zeropage($14) charset)
init_font_hex: {
    .label _0 = $23
    .label idx = $19
    .label proto_lo = $16
    .label charset = $14
    .label c1 = $18
    .label proto_hi = $11
    .label c = $13
    lda #0
    sta c
    lda #<FONT_HEX_PROTO
    sta proto_hi
    lda #>FONT_HEX_PROTO
    sta proto_hi+1
    lda #<CHARSET
    sta charset
    lda #>CHARSET
    sta charset+1
  b1:
    lda #0
    sta c1
    lda #<FONT_HEX_PROTO
    sta proto_lo
    lda #>FONT_HEX_PROTO
    sta proto_lo+1
  b2:
    lda #0
    tay
    sta (charset),y
    lda #1
    sta idx
    ldx #0
  b3:
    txa
    tay
    lda (proto_hi),y
    asl
    asl
    asl
    asl
    sta _0
    txa
    tay
    lda (proto_lo),y
    asl
    ora _0
    ldy idx
    sta (charset),y
    inc idx
    inx
    cpx #5
    bne b3
    lda #0
    ldy idx
    sta (charset),y
    iny
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
    inc c1
    lda #$10
    cmp c1
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
    rts
}
  // Bit patterns for symbols 0-f (3x5 pixels) used in font hex
  FONT_HEX_PROTO: .byte 2, 5, 5, 5, 2, 6, 2, 2, 2, 7, 6, 1, 2, 4, 7, 6, 1, 2, 1, 6, 5, 5, 7, 1, 1, 7, 4, 6, 1, 6, 3, 4, 6, 5, 2, 7, 1, 1, 1, 1, 2, 5, 2, 5, 2, 2, 5, 3, 1, 1, 2, 5, 7, 5, 5, 6, 5, 6, 5, 6, 2, 5, 4, 5, 2, 6, 5, 5, 5, 6, 7, 4, 6, 4, 7, 7, 4, 6, 4, 4
// Angles representing ATAN(0.5), ATAN(0.25), ATAN(0.125), ...
CORDIC_ATAN2_ANGLES_16:
.for (var i=0; i<CORDIC_ITERATIONS_16; i++)
        .word 256*2*256*atan(1/pow(2,i))/PI/2

