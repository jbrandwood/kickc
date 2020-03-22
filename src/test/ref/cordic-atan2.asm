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
    .label col00 = COLS+$c*$28+$13
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>CHARSET)/4&$f
    .label screen = 4
    .label x = 3
    .label y = 2
    // init_font_hex(CHARSET)
    jsr init_font_hex
    // *D018 = toD018(SCREEN, CHARSET)
    lda #toD0181_return
    sta D018
    lda #<SCREEN
    sta.z screen
    lda #>SCREEN
    sta.z screen+1
    lda #-$c
    sta.z y
  __b1:
    lda #-$13
    sta.z x
  __b2:
    // atan2_8(x, y)
    lda.z x
    sta.z atan2_8.x
    lda.z y
    sta.z atan2_8.y
    jsr atan2_8
    txa
    // angle = atan2_8(x, y)
    // *screen++ = angle
    ldy #0
    sta (screen),y
    // *screen++ = angle;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // for(signed byte x: -19..20)
    inc.z x
    lda #$15
    cmp.z x
    bne __b2
    // for(signed byte y: -12..12)
    inc.z y
    lda #$d
    cmp.z y
    bne __b1
  __b4:
    // (*col00)++;
    inc col00
    jmp __b4
}
// Find the atan2(x, y) - which is the angle of the line from (0,0) to (x,y)
// Finding the angle requires a binary search using CORDIC_ITERATIONS_8
// Returns the angle in hex-degrees (0=0, 0x80=PI, 0x100=2*PI)
// atan2_8(signed byte zp($11) x, signed byte zp($f) y)
atan2_8: {
    .label __7 = 8
    .label xi = 8
    .label xd = $10
    .label angle = $e
    .label i = $d
    .label x = $11
    .label y = $f
    // (y>0)?y:-y
    lda.z y
    cmp #0
    beq !+
    bmi !__b1+
    jmp __b1
  !__b1:
  !:
    lda.z y
    eor #$ff
    clc
    adc #1
    tax
  __b3:
    // (x>0)?x:-x
    lda.z x
    cmp #0
    beq !+
    bmi !__b4+
    jmp __b4
  !__b4:
  !:
    lda.z x
    eor #$ff
    clc
    adc #1
    sta.z __7
  __b6:
    lda #0
    sta.z angle
    sta.z i
  __b10:
    // if(yi==0)
    txa
    cmp #0
    bne __b11
  __b12:
    // angle = angle/2
    lda.z angle
    lsr
    tax
    // if(x<0)
    lda.z x
    cmp #0
    bpl __b7
    // angle = 128-angle
    txa
    eor #$ff
    tax
    axs #-$80-1
  __b7:
    // if(y<0)
    lda.z y
    cmp #0
    bpl __b8
    // angle = -angle
    dex
    txa
    eor #$ff
    tax
  __b8:
    // }
    rts
  __b11:
    // xd = xi>>i
    lda.z xi
    ldy.z i
    cpy #0
    beq !e+
  !l:
    cmp #$80
    ror
    dey
    bne !l-
  !e:
    sta.z xd
    // yd = yi>>i
    ldy.z i
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
    // if(yi>0)
    txa
    cmp #0
    beq !+
    bpl __b13
  !:
    // xi -= yd
    tya
    eor #$ff
    sec
    adc.z xi
    sta.z xi
    // yi += xd
    txa
    clc
    adc.z xd
    tax
    // angle -= CORDIC_ATAN2_ANGLES_8[i]
    lda.z angle
    ldy.z i
    sec
    sbc CORDIC_ATAN2_ANGLES_8,y
    sta.z angle
  __b14:
    // for( byte i: 0..CORDIC_ITERATIONS_8-1)
    inc.z i
    lda #CORDIC_ITERATIONS_8-1+1
    cmp.z i
    beq __b12
    jmp __b10
  __b13:
    // xi += yd
    tya
    clc
    adc.z xi
    sta.z xi
    // yi -= xd
    txa
    sec
    sbc.z xd
    tax
    // angle += CORDIC_ATAN2_ANGLES_8[i]
    lda.z angle
    ldy.z i
    clc
    adc CORDIC_ATAN2_ANGLES_8,y
    sta.z angle
    jmp __b14
  __b4:
    // (x>0)?x:-x
    lda.z x
    sta.z xi
    jmp __b6
  __b1:
    // (y>0)?y:-y
    ldx.z y
    jmp __b3
}
// Make charset from proto chars
// init_font_hex(byte* zp(9) charset)
init_font_hex: {
    .label __0 = $11
    .label idx = $e
    .label proto_lo = $b
    .label charset = 9
    .label c1 = $d
    .label proto_hi = 6
    .label c = 8
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
    // charset[idx++] = 0
    lda #0
    tay
    sta (charset),y
    lda #1
    sta.z idx
    ldx #0
  __b3:
    // proto_hi[i]<<4
    txa
    tay
    lda (proto_hi),y
    asl
    asl
    asl
    asl
    sta.z __0
    // proto_lo[i]<<1
    txa
    tay
    lda (proto_lo),y
    asl
    // proto_hi[i]<<4 | proto_lo[i]<<1
    ora.z __0
    // charset[idx++] = proto_hi[i]<<4 | proto_lo[i]<<1
    ldy.z idx
    sta (charset),y
    // charset[idx++] = proto_hi[i]<<4 | proto_lo[i]<<1;
    inc.z idx
    // for( byte i: 0..4)
    inx
    cpx #5
    bne __b3
    // charset[idx++] = 0
    lda #0
    ldy.z idx
    sta (charset),y
    // charset[idx++] = 0;
    iny
    // charset[idx++] = 0
    sta (charset),y
    // proto_lo += 5
    lda #5
    clc
    adc.z proto_lo
    sta.z proto_lo
    bcc !+
    inc.z proto_lo+1
  !:
    // charset += 8
    lda #8
    clc
    adc.z charset
    sta.z charset
    bcc !+
    inc.z charset+1
  !:
    // for( byte c: 0..15 )
    inc.z c1
    lda #$10
    cmp.z c1
    bne __b2
    // proto_hi += 5
    lda #5
    clc
    adc.z proto_hi
    sta.z proto_hi
    bcc !+
    inc.z proto_hi+1
  !:
    // for( byte c: 0..15 )
    inc.z c
    lda #$10
    cmp.z c
    bne __b1
    // }
    rts
}
  // Bit patterns for symbols 0-f (3x5 pixels) used in font hex
  FONT_HEX_PROTO: .byte 2, 5, 5, 5, 2, 6, 2, 2, 2, 7, 6, 1, 2, 4, 7, 6, 1, 2, 1, 6, 5, 5, 7, 1, 1, 7, 4, 6, 1, 6, 3, 4, 6, 5, 2, 7, 1, 1, 1, 1, 2, 5, 2, 5, 2, 2, 5, 3, 1, 1, 2, 5, 7, 5, 5, 6, 5, 6, 5, 6, 2, 5, 4, 5, 2, 6, 5, 5, 5, 6, 7, 4, 6, 4, 7, 7, 4, 6, 4, 4
// Angles representing ATAN(0.5), ATAN(0.25), ATAN(0.125), ...
CORDIC_ATAN2_ANGLES_8:
.fill CORDIC_ITERATIONS_8, 2*256*atan(1/pow(2,i))/PI/2

