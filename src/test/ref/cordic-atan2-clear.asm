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
    sta.z clear_char
    lda #>CHARSET
    sta.z clear_char+1
  b2:
    lda #$ff
    cmp RASTER
    bne b2
    lda.z clear_char+1
    cmp #>CHARSET+$800
    bcc !+
    bne b2
    lda.z clear_char
    cmp #<CHARSET+$800
    bcs b2
  !:
    lda #0
    tay
    sta (clear_char),y
    inc.z clear_char
    bne !+
    inc.z clear_char+1
  !:
    jmp b2
}
// Populates 1000 bytes (a screen) with values representing the angle to the center.
// Utilizes symmetry around the  center
init_angle_screen: {
    .label _11 = 4
    .label xw = $13
    .label yw = $15
    .label angle_w = 4
    .label ang_w = $17
    .label x = $11
    .label xb = $12
    .label screen_topline = 2
    .label screen_bottomline = $a
    .label y = $c
    lda #<SCREEN+$28*$c
    sta.z screen_bottomline
    lda #>SCREEN+$28*$c
    sta.z screen_bottomline+1
    lda #<SCREEN+$28*$c
    sta.z screen_topline
    lda #>SCREEN+$28*$c
    sta.z screen_topline+1
    lda #0
    sta.z y
  b1:
    lda #$27
    sta.z xb
    lda #0
    sta.z x
  b2:
    lda.z x
    cmp #$13+1
    bcc b3
    lda.z screen_topline
    sec
    sbc #<$28
    sta.z screen_topline
    lda.z screen_topline+1
    sbc #>$28
    sta.z screen_topline+1
    lda #$28
    clc
    adc.z screen_bottomline
    sta.z screen_bottomline
    bcc !+
    inc.z screen_bottomline+1
  !:
    inc.z y
    lda #$d
    cmp.z y
    bne b1
    rts
  b3:
    lda.z x
    asl
    eor #$ff
    clc
    adc #$27+1
    ldy #0
    sta.z xw+1
    sty.z xw
    lda.z y
    asl
    sta.z yw+1
    sty.z yw
    jsr atan2_16
    lda #$80
    clc
    adc.z _11
    sta.z _11
    bcc !+
    inc.z _11+1
  !:
    lda.z _11+1
    sta.z ang_w
    lda #$80
    clc
    adc.z ang_w
    ldy.z x
    sta (screen_topline),y
    lda #$80
    sec
    sbc.z ang_w
    sta (screen_bottomline),y
    lda.z ang_w
    eor #$ff
    clc
    adc #1
    ldy.z xb
    sta (screen_topline),y
    lda.z ang_w
    sta (screen_bottomline),y
    inc.z x
    dec.z xb
    jmp b2
}
// Find the atan2(x, y) - which is the angle of the line from (0,0) to (x,y)
// Finding the angle requires a binary search using CORDIC_ITERATIONS_16
// Returns the angle in hex-degrees (0=0, 0x8000=PI, 0x10000=2*PI)
// atan2_16(signed word zeropage($13) x, signed word zeropage($15) y)
atan2_16: {
    .label _2 = $d
    .label _7 = $f
    .label yi = $d
    .label xi = $f
    .label angle = 4
    .label xd = 8
    .label yd = 6
    .label return = 4
    .label x = $13
    .label y = $15
    lda.z y+1
    bmi !b1+
    jmp b1
  !b1:
    sec
    lda #0
    sbc.z y
    sta.z _2
    lda #0
    sbc.z y+1
    sta.z _2+1
  b3:
    lda.z x+1
    bmi !b4+
    jmp b4
  !b4:
    sec
    lda #0
    sbc.z x
    sta.z _7
    lda #0
    sbc.z x+1
    sta.z _7+1
  b6:
    lda #<0
    sta.z angle
    sta.z angle+1
    tax
  b10:
    lda.z yi+1
    bne b11
    lda.z yi
    bne b11
  b12:
    lsr.z angle+1
    ror.z angle
    lda.z x+1
    bpl b7
    sec
    lda #<$8000
    sbc.z angle
    sta.z angle
    lda #>$8000
    sbc.z angle+1
    sta.z angle+1
  b7:
    lda.z y+1
    bpl b8
    sec
    lda #0
    sbc.z angle
    sta.z angle
    lda #0
    sbc.z angle+1
    sta.z angle+1
  b8:
    rts
  b11:
    txa
    tay
    lda.z xi
    sta.z xd
    lda.z xi+1
    sta.z xd+1
    lda.z yi
    sta.z yd
    lda.z yi+1
    sta.z yd+1
  b13:
    cpy #2
    bcs b14
    cpy #0
    beq b17
    lda.z xd+1
    cmp #$80
    ror.z xd+1
    ror.z xd
    lda.z yd+1
    cmp #$80
    ror.z yd+1
    ror.z yd
  b17:
    lda.z yi+1
    bpl b18
    lda.z xi
    sec
    sbc.z yd
    sta.z xi
    lda.z xi+1
    sbc.z yd+1
    sta.z xi+1
    lda.z yi
    clc
    adc.z xd
    sta.z yi
    lda.z yi+1
    adc.z xd+1
    sta.z yi+1
    txa
    asl
    tay
    sec
    lda.z angle
    sbc CORDIC_ATAN2_ANGLES_16,y
    sta.z angle
    lda.z angle+1
    sbc CORDIC_ATAN2_ANGLES_16+1,y
    sta.z angle+1
  b19:
    inx
    cpx #CORDIC_ITERATIONS_16-1+1
    bne !b12+
    jmp b12
  !b12:
    jmp b10
  b18:
    lda.z xi
    clc
    adc.z yd
    sta.z xi
    lda.z xi+1
    adc.z yd+1
    sta.z xi+1
    lda.z yi
    sec
    sbc.z xd
    sta.z yi
    lda.z yi+1
    sbc.z xd+1
    sta.z yi+1
    txa
    asl
    tay
    clc
    lda.z angle
    adc CORDIC_ATAN2_ANGLES_16,y
    sta.z angle
    lda.z angle+1
    adc CORDIC_ATAN2_ANGLES_16+1,y
    sta.z angle+1
    jmp b19
  b14:
    lda.z xd+1
    cmp #$80
    ror.z xd+1
    ror.z xd
    lda.z xd+1
    cmp #$80
    ror.z xd+1
    ror.z xd
    lda.z yd+1
    cmp #$80
    ror.z yd+1
    ror.z yd
    lda.z yd+1
    cmp #$80
    ror.z yd+1
    ror.z yd
    dey
    dey
    jmp b13
  b4:
    lda.z x
    sta.z xi
    lda.z x+1
    sta.z xi+1
    jmp b6
  b1:
    lda.z y
    sta.z yi
    lda.z y+1
    sta.z yi+1
    jmp b3
}
// Make charset from proto chars
// init_font_hex(byte* zeropage($d) charset)
init_font_hex: {
    .label _0 = $17
    .label idx = $12
    .label proto_lo = $f
    .label charset = $d
    .label c1 = $11
    .label proto_hi = $a
    .label c = $c
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
  b1:
    lda #0
    sta.z c1
    lda #<FONT_HEX_PROTO
    sta.z proto_lo
    lda #>FONT_HEX_PROTO
    sta.z proto_lo+1
  b2:
    lda #0
    tay
    sta (charset),y
    lda #1
    sta.z idx
    ldx #0
  b3:
    txa
    tay
    lda (proto_hi),y
    asl
    asl
    asl
    asl
    sta.z _0
    txa
    tay
    lda (proto_lo),y
    asl
    ora.z _0
    ldy.z idx
    sta (charset),y
    inc.z idx
    inx
    cpx #5
    bne b3
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
    bne b2
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
    bne b1
    rts
}
  // Bit patterns for symbols 0-f (3x5 pixels) used in font hex
  FONT_HEX_PROTO: .byte 2, 5, 5, 5, 2, 6, 2, 2, 2, 7, 6, 1, 2, 4, 7, 6, 1, 2, 1, 6, 5, 5, 7, 1, 1, 7, 4, 6, 1, 6, 3, 4, 6, 5, 2, 7, 1, 1, 1, 1, 2, 5, 2, 5, 2, 2, 5, 3, 1, 1, 2, 5, 7, 5, 5, 6, 5, 6, 5, 6, 2, 5, 4, 5, 2, 6, 5, 5, 5, 6, 7, 4, 6, 4, 7, 7, 4, 6, 4, 4
// Angles representing ATAN(0.5), ATAN(0.25), ATAN(0.125), ...
CORDIC_ATAN2_ANGLES_16:
.for (var i=0; i<CORDIC_ITERATIONS_16; i++)
        .word 256*2*256*atan(1/pow(2,i))/PI/2

