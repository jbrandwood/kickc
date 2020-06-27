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
    .label col00 = COLS+$c*$28+$13
    .label __3 = 6
    .label xw = $13
    .label yw = $15
    .label angle_w = 6
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
    // xw = (signed word)(word){ (byte)x, 0 }
    lda.z x
    ldy #0
    sta.z xw+1
    sty.z xw
    // yw = (signed word)(word){ (byte)y, 0 }
    lda.z y
    sta.z yw+1
    sty.z yw
    // atan2_16(xw, yw)
    jsr atan2_16
    // angle_w = atan2_16(xw, yw)
    // angle_w+0x0080
    lda #$80
    clc
    adc.z __3
    sta.z __3
    bcc !+
    inc.z __3+1
  !:
    // ang_w = >(angle_w+0x0080)
    lda.z __3+1
    // *screen++ = ang_w
    ldy #0
    sta (screen),y
    // *screen++ = ang_w;
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
// Finding the angle requires a binary search using CORDIC_ITERATIONS_16
// Returns the angle in hex-degrees (0=0, 0x8000=PI, 0x10000=2*PI)
// atan2_16(signed word zp($13) x, signed word zp($15) y)
atan2_16: {
    .label __2 = $a
    .label __7 = $d
    .label yi = $a
    .label xi = $d
    .label angle = 6
    // Optimized shift of 2 values: xd=xi>>i; yd=yi>>i
    .label xd = 8
    .label yd = $f
    .label return = 6
    .label x = $13
    .label y = $15
    // (y>=0)?y:-y
    lda.z y+1
    bmi !__b1+
    jmp __b1
  !__b1:
    sec
    lda #0
    sbc.z y
    sta.z __2
    lda #0
    sbc.z y+1
    sta.z __2+1
  __b3:
    // (x>=0)?x:-x
    lda.z x+1
    bmi !__b4+
    jmp __b4
  !__b4:
    sec
    lda #0
    sbc.z x
    sta.z __7
    lda #0
    sbc.z x+1
    sta.z __7+1
  __b6:
    lda #<0
    sta.z angle
    sta.z angle+1
    tax
  __b10:
    // if(yi==0)
    lda.z yi+1
    bne __b11
    lda.z yi
    bne __b11
  __b12:
    // angle /=2
    lsr.z angle+1
    ror.z angle
    // if(x<0)
    lda.z x+1
    bpl __b7
    // angle = 0x8000-angle
    sec
    lda #<$8000
    sbc.z angle
    sta.z angle
    lda #>$8000
    sbc.z angle+1
    sta.z angle+1
  __b7:
    // if(y<0)
    lda.z y+1
    bpl __b8
    // angle = -angle
    sec
    lda #0
    sbc.z angle
    sta.z angle
    lda #0
    sbc.z angle+1
    sta.z angle+1
  __b8:
    // }
    rts
  __b11:
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
  __b13:
    // while(shift>=2)
    cpy #2
    bcs __b14
    // if(shift)
    cpy #0
    beq __b17
    // xd >>= 1
    lda.z xd+1
    cmp #$80
    ror.z xd+1
    ror.z xd
    // yd >>= 1
    lda.z yd+1
    cmp #$80
    ror.z yd+1
    ror.z yd
  __b17:
    // if(yi>=0)
    lda.z yi+1
    bpl __b18
    // xi -= yd
    lda.z xi
    sec
    sbc.z yd
    sta.z xi
    lda.z xi+1
    sbc.z yd+1
    sta.z xi+1
    // yi += xd
    lda.z yi
    clc
    adc.z xd
    sta.z yi
    lda.z yi+1
    adc.z xd+1
    sta.z yi+1
    // angle -= CORDIC_ATAN2_ANGLES_16[i]
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
  __b19:
    // for( char i: 0..CORDIC_ITERATIONS_16-1)
    inx
    cpx #CORDIC_ITERATIONS_16-1+1
    bne !__b12+
    jmp __b12
  !__b12:
    jmp __b10
  __b18:
    // xi += yd
    lda.z xi
    clc
    adc.z yd
    sta.z xi
    lda.z xi+1
    adc.z yd+1
    sta.z xi+1
    // yi -= xd
    lda.z yi
    sec
    sbc.z xd
    sta.z yi
    lda.z yi+1
    sbc.z xd+1
    sta.z yi+1
    // angle += CORDIC_ATAN2_ANGLES_16[i]
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
    jmp __b19
  __b14:
    // xd >>= 2
    lda.z xd+1
    cmp #$80
    ror.z xd+1
    ror.z xd
    lda.z xd+1
    cmp #$80
    ror.z xd+1
    ror.z xd
    // yd >>= 2
    lda.z yd+1
    cmp #$80
    ror.z yd+1
    ror.z yd
    lda.z yd+1
    cmp #$80
    ror.z yd+1
    ror.z yd
    // shift -=2
    dey
    dey
    jmp __b13
  __b4:
    // (x>=0)?x:-x
    lda.z x
    sta.z xi
    lda.z x+1
    sta.z xi+1
    jmp __b6
  __b1:
    // (y>=0)?y:-y
    lda.z y
    sta.z yi
    lda.z y+1
    sta.z yi+1
    jmp __b3
}
// Make charset from proto chars
// init_font_hex(byte* zp($d) charset)
init_font_hex: {
    .label __0 = $17
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
CORDIC_ATAN2_ANGLES_16:
.for (var i=0; i<CORDIC_ITERATIONS_16; i++)
        .word 256*2*256*atan(1/pow(2,i))/PI/2

