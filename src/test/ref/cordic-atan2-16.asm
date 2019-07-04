// Find atan2(x, y) using the CORDIC method
// See http://bsvi.ru/uploads/CORDIC--_10EBA/cordic.pdf
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // The number of iterations performed during 16-bit CORDIC atan2 calculation
  .const CORDIC_ITERATIONS_16 = $f
  .label D018 = $d018
  // Color Ram
  .label COLS = $d800
  .label CHARSET = $2000
  .label SCREEN = $2800
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>CHARSET)/4&$f
    .label _11 = $a
    .label xw = $19
    .label yw = $1b
    .label angle_w = $a
    .label screen = 4
    .label x = 3
    .label y = 2
    jsr init_font_hex
    lda #toD0181_return
    sta D018
    lda #<SCREEN
    sta screen
    lda #>SCREEN
    sta screen+1
    lda #-$c
    sta y
  b1:
    lda #-$13
    sta x
  b2:
    lda x
    ldy #0
    sta xw+1
    sty xw
    lda y
    sta yw+1
    sty yw
    jsr atan2_16
    lda #$80
    clc
    adc _11
    sta _11
    bcc !+
    inc _11+1
  !:
    lda _11+1
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inc x
    lda #$15
    cmp x
    bne b2
    inc y
    lda #$d
    cmp y
    bne b1
  b4:
    lda COLS+$c*$28+$13
    clc
    adc #1
    sta COLS+$c*$28+$13
    jmp b4
}
// Find the atan2(x, y) - which is the angle of the line from (0,0) to (x,y)
// Finding the angle requires a binary search using CORDIC_ITERATIONS_16
// Returns the angle in hex-degrees (0=0, 0x8000=PI, 0x10000=2*PI)
// atan2_16(signed word zeropage($19) x, signed word zeropage($1b) y)
atan2_16: {
    .label _2 = 6
    .label _7 = 8
    .label yi = 6
    .label xi = 8
    .label angle = $a
    .label xd = $e
    .label yd = $c
    .label return = $a
    .label x = $19
    .label y = $1b
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
    tax
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
    txa
    tay
    lda xi
    sta xd
    lda xi+1
    sta xd+1
    lda yi
    sta yd
    lda yi+1
    sta yd+1
  b13:
    cpy #1+1
    bcs b14
    cpy #0
    beq b17
    lda xd+1
    cmp #$80
    ror xd+1
    ror xd
    lda yd+1
    cmp #$80
    ror yd+1
    ror yd
  b17:
    lda yi+1
    bpl b18
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
    txa
    asl
    tay
    sec
    lda angle
    sbc CORDIC_ATAN2_ANGLES_16,y
    sta angle
    lda angle+1
    sbc CORDIC_ATAN2_ANGLES_16+1,y
    sta angle+1
  b19:
    inx
    cpx #CORDIC_ITERATIONS_16-1+1
    bne !b12+
    jmp b12
  !b12:
    jmp b10
  b18:
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
    txa
    asl
    tay
    clc
    lda angle
    adc CORDIC_ATAN2_ANGLES_16,y
    sta angle
    lda angle+1
    adc CORDIC_ATAN2_ANGLES_16+1,y
    sta angle+1
    jmp b19
  b14:
    lda xd+1
    cmp #$80
    ror xd+1
    ror xd
    lda xd+1
    cmp #$80
    ror xd+1
    ror xd
    lda yd+1
    cmp #$80
    ror yd+1
    ror yd
    lda yd+1
    cmp #$80
    ror yd+1
    ror yd
    dey
    dey
    jmp b13
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
// init_font_hex(byte* zeropage($13) charset)
init_font_hex: {
    .label _0 = $1d
    .label idx = $18
    .label proto_lo = $15
    .label charset = $13
    .label c1 = $17
    .label proto_hi = $10
    .label c = $12
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

