// Find atan2(x, y) using the CORDIC method
// See http://bsvi.ru/uploads/CORDIC--_10EBA/cordic.pdf
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label D018 = $d018
  // Color Ram
  .label COLS = $d800
  // The number of iterations performed during 8-bit CORDIC atan2 calculation
  .const CORDIC_ITERATIONS_8 = 8
  .label CHARSET = $2000
  .label SCREEN = $2800
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>CHARSET)/4&$f
    .label screen = 3
    .label x = $a
    .label y = 5
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
    jsr atan2_8
    txa
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
// Finding the angle requires a binary search using CORDIC_ITERATIONS_8
// Returns the angle in hex-degrees (0=0, 0x80=PI, 0x100=2*PI)
// atan2_8(signed byte zeropage($a) x, signed byte zeropage(5) y)
atan2_8: {
    .label _7 = $b
    .label xi = $b
    .label xd = $c
    .label angle = 2
    .label i = $d
    .label x = $a
    .label y = 5
    lda y
    cmp #0
    beq !+
    bmi !b1+
    jmp b1
  !b1:
  !:
    lda y
    eor #$ff
    clc
    adc #1
    tax
  b3:
    lda x
    cmp #0
    beq !+
    bmi !b4+
    jmp b4
  !b4:
  !:
    lda x
    eor #$ff
    clc
    adc #1
    sta _7
  b6:
    lda #0
    sta angle
    sta i
  b10:
    txa
    cmp #0
    bne b11
  b12:
    lda angle
    lsr
    tax
    lda x
    cmp #0
    bpl b7
    txa
    eor #$ff
    clc
    adc #$80+1
    tax
  b7:
    lda y
    cmp #0
    bpl b8
    dex
    txa
    eor #$ff
    tax
  b8:
    rts
  b11:
    lda xi
    ldy i
    cpy #0
    beq !e+
  !l:
    cmp #$80
    ror
    dey
    bne !l-
  !e:
    sta xd
    ldy i
    txa
    cpy #0
    beq !e+
  !l:
    cmp #$80
    ror
    dey
    bne !l-
  !e:
    tay
    txa
    cmp #0
    beq !+
    bpl b13
  !:
    tya
    eor #$ff
    sec
    adc xi
    sta xi
    txa
    clc
    adc xd
    tax
    lda angle
    ldy i
    sec
    sbc CORDIC_ATAN2_ANGLES_8,y
    sta angle
  b14:
    inc i
    lda #CORDIC_ITERATIONS_8-1+1
    cmp i
    beq b12
    jmp b10
  b13:
    tya
    clc
    adc xi
    sta xi
    txa
    sec
    sbc xd
    tax
    lda angle
    ldy i
    clc
    adc CORDIC_ATAN2_ANGLES_8,y
    sta angle
    jmp b14
  b4:
    lda x
    sta xi
    jmp b6
  b1:
    ldx y
    jmp b3
}
// Make charset from proto chars
// init_font_hex(byte* zeropage(6) charset)
init_font_hex: {
    .label _0 = $d
    .label idx = $b
    .label proto_lo = 8
    .label charset = 6
    .label c1 = $a
    .label proto_hi = 3
    .label c = 5
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
CORDIC_ATAN2_ANGLES_8:
.fill CORDIC_ITERATIONS_8, 2*256*atan(1/pow(2,i))/PI/2

