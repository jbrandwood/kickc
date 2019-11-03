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
  .label print_char_cursor = 2
main: {
    .label col00 = COLS+$c*$28+$13
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>CHARSET)/4&$f
    .label __10 = 6
    .label xw = $15
    .label yw = $17
    .label angle_w = 6
    .label diff_sum = $c
    .label screen = $f
    .label screen_ref = 2
    .label x = $13
    .label y = $e
    jsr init_font_hex
    lda #toD0181_return
    sta D018
    lda #<SCREEN
    sta.z screen
    lda #>SCREEN
    sta.z screen+1
    lda #<0
    sta.z diff_sum
    sta.z diff_sum+1
    lda #<SCREEN_REF
    sta.z screen_ref
    lda #>SCREEN_REF
    sta.z screen_ref+1
    lda #-$c
    sta.z y
  __b1:
    lda #-$13
    sta.z x
  __b2:
    lda.z x
    ldy #0
    sta.z xw+1
    sty.z xw
    lda.z y
    sta.z yw+1
    sty.z yw
    jsr atan2_16
    lda #$80
    clc
    adc.z __10
    sta.z __10
    bcc !+
    inc.z __10+1
  !:
    lda.z __10+1
    tax
    ldy #0
    lda (screen_ref),y
    jsr diff
    //*screen = (>angle_w)-angle_b;
    //*screen = >angle_w;
    clc
    adc.z diff_sum
    sta.z diff_sum
    bcc !+
    inc.z diff_sum+1
  !:
    txa
    sec
    ldy #0
    sbc (screen_ref),y
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inc.z screen_ref
    bne !+
    inc.z screen_ref+1
  !:
    inc.z x
    lda #$15
    cmp.z x
    bne __b2
    inc.z y
    lda #$d
    cmp.z y
    bne __b1
    jsr print_word
  __b5:
    inc col00
    jmp __b5
}
// Print a word as HEX
// print_word(word zeropage($c) w)
print_word: {
    .label w = $c
    lda.z w+1
    tax
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    jsr print_byte
    lda.z w
    tax
    jsr print_byte
    rts
}
// Print a byte as HEX
// print_byte(byte register(X) b)
print_byte: {
    txa
    lsr
    lsr
    lsr
    lsr
    tay
    lda print_hextab,y
    jsr print_char
    lda #$f
    axs #0
    lda print_hextab,x
    jsr print_char
    rts
}
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    ldy #0
    sta (print_char_cursor),y
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    rts
}
// diff(byte register(X) bb1, byte register(A) bb2)
diff: {
    sta.z $ff
    cpx.z $ff
    bcc __b1
    sta.z $ff
    txa
    sec
    sbc.z $ff
    rts
  __b1:
    stx.z $ff
    sec
    sbc.z $ff
    rts
}
// Find the atan2(x, y) - which is the angle of the line from (0,0) to (x,y)
// Finding the angle requires a binary search using CORDIC_ITERATIONS_16
// Returns the angle in hex-degrees (0=0, 0x8000=PI, 0x10000=2*PI)
// atan2_16(signed word zeropage($15) x, signed word zeropage($17) y)
atan2_16: {
    .label __2 = $11
    .label __7 = 4
    .label yi = $11
    .label xi = 4
    .label angle = 6
    .label xd = $a
    .label yd = 8
    .label return = 6
    .label x = $15
    .label y = $17
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
    lda.z yi+1
    bne __b11
    lda.z yi
    bne __b11
  __b12:
    lsr.z angle+1
    ror.z angle
    lda.z x+1
    bpl __b7
    sec
    lda #<$8000
    sbc.z angle
    sta.z angle
    lda #>$8000
    sbc.z angle+1
    sta.z angle+1
  __b7:
    lda.z y+1
    bpl __b8
    sec
    lda #0
    sbc.z angle
    sta.z angle
    lda #0
    sbc.z angle+1
    sta.z angle+1
  __b8:
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
    cpy #2
    bcs __b14
    cpy #0
    beq __b17
    lda.z xd+1
    cmp #$80
    ror.z xd+1
    ror.z xd
    lda.z yd+1
    cmp #$80
    ror.z yd+1
    ror.z yd
  __b17:
    lda.z yi+1
    bpl __b18
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
  __b19:
    inx
    cpx #CORDIC_ITERATIONS_16-1+1
    bne !__b12+
    jmp __b12
  !__b12:
    jmp __b10
  __b18:
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
    jmp __b19
  __b14:
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
    jmp __b13
  __b4:
    lda.z x
    sta.z xi
    lda.z x+1
    sta.z xi+1
    jmp __b6
  __b1:
    lda.z y
    sta.z yi
    lda.z y+1
    sta.z yi+1
    jmp __b3
}
// Make charset from proto chars
// init_font_hex(byte* zeropage($f) charset)
init_font_hex: {
    .label __0 = $19
    .label idx = $14
    .label proto_lo = $11
    .label charset = $f
    .label c1 = $13
    .label proto_hi = $c
    .label c = $e
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
  print_hextab: .text "0123456789abcdef"
// Angles representing ATAN(0.5), ATAN(0.25), ATAN(0.125), ...
CORDIC_ATAN2_ANGLES_16:
.for (var i=0; i<CORDIC_ITERATIONS_16; i++)
        .word 256*2*256*atan(1/pow(2,i))/PI/2

SCREEN_REF:
.for(var y=-12;y<=12;y++)
        .for(var x=-19;x<=20;x++)
            .byte round(256*atan2(y, x)/PI/2)

