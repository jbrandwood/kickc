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
  .label print_char_cursor = 9
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>CHARSET)/4&$f
    .label _12 = $10
    .label xw = $1b
    .label yw = $1d
    .label angle_w = $10
    .label ang_w = $1f
    .label diff_sum = 5
    .label screen = 7
    .label screen_ref = 3
    .label y = 2
    jsr init_font_hex
    lda #toD0181_return
    sta D018
    lda #<SCREEN
    sta screen
    lda #>SCREEN
    sta screen+1
    lda #0
    sta diff_sum
    sta diff_sum+1
    lda #<SCREEN_REF
    sta screen_ref
    lda #>SCREEN_REF
    sta screen_ref+1
    lda #-$c
    sta y
  b1:
    ldx #-$13
  b2:
    ldy #0
    txa
    sta xw+1
    sty xw
    lda y
    sta yw+1
    sty yw
    jsr atan2_16
    lda #$80
    clc
    adc _12
    sta _12
    bcc !+
    inc _12+1
  !:
    lda _12+1
    sta ang_w
    ldy #0
    lda (screen_ref),y
    jsr diff
    //*screen = (>angle_w)-angle_b;
    //*screen = >angle_w;
    clc
    adc diff_sum
    sta diff_sum
    bcc !+
    inc diff_sum+1
  !:
    lda ang_w
    sec
    ldy #0
    sbc (screen_ref),y
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inc screen_ref
    bne !+
    inc screen_ref+1
  !:
    inx
    cpx #$15
    bne b2
    inc y
    lda #$d
    cmp y
    bne b1
    jsr print_word
  b5:
    lda COLS+$c*$28+$13
    clc
    adc #1
    sta COLS+$c*$28+$13
    jmp b5
}
// Print a word as HEX
// print_word(word zeropage(5) w)
print_word: {
    .label w = 5
    lda w+1
    tax
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    jsr print_byte
    lda w
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
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    rts
}
// diff(byte zeropage($1f) bb1, byte register(A) bb2)
diff: {
    .label bb1 = $1f
    cmp bb1
    beq !+
    bcs b1
  !:
    eor #$ff
    sec
    adc bb1
    rts
  b1:
    sec
    sbc bb1
    rts
}
// Find the atan2(x, y) - which is the angle of the line from (0,0) to (x,y)
// Finding the angle requires a binary search using CORDIC_ITERATIONS_16
// Returns the angle in hex-degrees (0=0, 0x8000=PI, 0x10000=2*PI)
// atan2_16(signed word zeropage($1b) x, signed word zeropage($1d) y)
atan2_16: {
    .label _2 = $b
    .label _7 = $d
    .label yi = $b
    .label xi = $d
    .label xd = $20
    .label yd = $22
    .label angle = $10
    .label i = $f
    .label return = $10
    .label x = $1b
    .label y = $1d
    lda y+1
    bne !+
    lda y
    beq !e+
    lsr
  !:
    bmi !b1+
    jmp b1
  !b1:
  !e:
    sec
    lda #0
    sbc y
    sta _2
    lda #0
    sbc y+1
    sta _2+1
  b3:
    lda x+1
    bne !+
    lda x
    beq !e+
    lsr
  !:
    bmi !b4+
    jmp b4
  !b4:
  !e:
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
    bne !+
    lda yi
    beq !e+
    lsr
  !:
    bpl b13
  !e:
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
// init_font_hex(byte* zeropage($15) charset)
init_font_hex: {
    .label _0 = $24
    .label idx = $1a
    .label proto_lo = $17
    .label charset = $15
    .label c1 = $19
    .label proto_hi = $12
    .label c = $14
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

  print_hextab: .text "0123456789abcdef"
SCREEN_REF:
.for(var y=-12;y<=12;y++)
        .for(var x=-19;x<=20;x++)
            .byte round(256*atan2(y, x)/PI/2)

