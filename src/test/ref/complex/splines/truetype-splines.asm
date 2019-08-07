// Show a few simple splines using the splines library
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const MOVE_TO = 0
  .const SPLINE_TO = 1
  .const LINE_TO = 2
  .const SIZEOF_STRUCT_SPLINEVECTOR16 = 4
  .const OFFSET_STRUCT_SPLINEVECTOR16_Y = 2
  .const OFFSET_STRUCT_SEGMENT_TO = 1
  .const OFFSET_STRUCT_SEGMENT_VIA = 5
  .label RASTER = $d012
  .label D011 = $d011
  .const VIC_BMM = $20
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .label D018 = $d018
  // CIA#2 Port A: Serial bus, RS-232, VIC memory bank
  .label CIA2_PORT_A = $dd00
  // CIA #2 Port A data direction register.
  .label CIA2_PORT_A_DDR = $dd02
  .const WHITE = 1
  .label BITMAP_SCREEN = $5c00
  .label BITMAP_GRAPHICS = $6000
  .label COS = SIN+$40
main: {
    .const vicSelectGfxBank1_toDd001_return = 3^(>BITMAP_SCREEN)/$40
    .const toD0181_return = (>(BITMAP_SCREEN&$3fff)*4)|(>BITMAP_GRAPHICS)/4&$f
    .label angle = $12
    jsr mulf_init
    jsr bitmap_init
    jsr bitmap_clear
    lda #3
    sta CIA2_PORT_A_DDR
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2_PORT_A
    lda #toD0181_return
    sta D018
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta D011
    lda #0
    sta angle
  b2:
    jsr bitmap_clear
    jsr show_letter
    ldx #0
  b3:
    lda #$fe
    cmp RASTER
    bne b3
  b4:
    lda #$ff
    cmp RASTER
    bne b4
    inx
    cpx #$3d
    bne b3
    lax angle
    axs #-[9]
    stx angle
    jmp b2
}
// show_letter(byte zeropage($12) angle)
show_letter: {
    .label angle = $12
    .label to_x = 2
    .label to_y = 4
    .label to_x_2 = $20
    .label to_y_2 = $22
    .label via_x = 2
    .label via_y = 4
    .label via_x_2 = $20
    .label via_y_2 = $22
    .label segment_via_x = $20
    .label segment_via_y = $22
    .label i = $13
    .label current_x = $c
    .label current_y = $e
    .label current_x_10 = $14
    .label current_y_10 = $16
    lda #<0
    sta current_y
    sta current_y+1
    sta current_x
    sta current_x+1
    sta i
  b1:
    lda i
    asl
    asl
    asl
    clc
    adc i
    tax
    lda letter_c+OFFSET_STRUCT_SEGMENT_TO,x
    sta to_x
    lda letter_c+OFFSET_STRUCT_SEGMENT_TO+1,x
    sta to_x+1
    lda letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y,x
    sta to_y
    lda letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+1,x
    sta to_y+1
    lda to_x
    sec
    sbc #$32
    sta to_x
    lda to_x+1
    sbc #>$32
    sta to_x+1
    lda to_y
    sec
    sbc #<$96
    sta to_y
    lda to_y+1
    sbc #>$96
    sta to_y+1
    ldy angle
    jsr rotate
    lda to_x_2
    clc
    adc #<$64
    sta current_x_10
    lda to_x_2+1
    adc #>$64
    sta current_x_10+1
    lda to_y_2
    clc
    adc #<$64
    sta current_y_10
    lda to_y_2+1
    adc #>$64
    sta current_y_10+1
    lda i
    asl
    asl
    asl
    clc
    adc i
    tax
    lda letter_c+OFFSET_STRUCT_SEGMENT_VIA,x
    sta via_x
    lda letter_c+OFFSET_STRUCT_SEGMENT_VIA+1,x
    sta via_x+1
    lda letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y,x
    sta via_y
    lda letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+1,x
    sta via_y+1
    lda via_x
    sec
    sbc #$32
    sta via_x
    lda via_x+1
    sbc #>$32
    sta via_x+1
    lda via_y
    sec
    sbc #<$96
    sta via_y
    lda via_y+1
    sbc #>$96
    sta via_y+1
    ldy angle
    jsr rotate
    lda segment_via_x
    clc
    adc #<$64
    sta segment_via_x
    lda segment_via_x+1
    adc #>$64
    sta segment_via_x+1
    lda segment_via_y
    clc
    adc #<$64
    sta segment_via_y
    lda segment_via_y+1
    adc #>$64
    sta segment_via_y+1
    lda i
    asl
    asl
    asl
    clc
    adc i
    tay
    lda letter_c,y
    cmp #MOVE_TO
    beq b3
    cmp #SPLINE_TO
    beq b2
    lda current_x_10
    sta bitmap_line.x2
    lda current_x_10+1
    sta bitmap_line.x2+1
    lda current_y_10
    sta bitmap_line.y2
    lda current_y_10+1
    sta bitmap_line.y2+1
    jsr bitmap_line
  b3:
    inc i
    lda #$16
    cmp i
    bne b9
    rts
  b9:
    lda current_x_10
    sta current_x
    lda current_x_10+1
    sta current_x+1
    lda current_y_10
    sta current_y
    lda current_y_10+1
    sta current_y+1
    jmp b1
  b2:
    jsr spline_8segB
    jsr bitmap_plot_spline_8seg
    jmp b3
}
// Plot the spline in the SPLINE_8SEG array
bitmap_plot_spline_8seg: {
    .label current_x = $c
    .label current_y = $e
    .label n = $24
    lda SPLINE_8SEG
    sta current_x
    lda SPLINE_8SEG+1
    sta current_x+1
    lda SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y
    sta current_y
    lda SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y+1
    sta current_y+1
    lda #1
    sta n
  b1:
    lda n
    asl
    asl
    tax
    lda SPLINE_8SEG,x
    sta bitmap_line.x2
    lda SPLINE_8SEG+1,x
    sta bitmap_line.x2+1
    lda SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y,x
    sta bitmap_line.y2
    lda SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y+1,x
    sta bitmap_line.y2+1
    jsr bitmap_line
    lda n
    asl
    asl
    tax
    lda SPLINE_8SEG,x
    sta current_x
    lda SPLINE_8SEG+1,x
    sta current_x+1
    lda SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y,x
    sta current_y
    lda SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y+1,x
    sta current_y+1
    inc n
    lda #9
    cmp n
    bne b1
    rts
}
// Draw a line on the bitmap using bresenhams algorithm
// bitmap_line(word zeropage($c) x1, word zeropage($e) y1, word zeropage($20) x2, word zeropage($22) y2)
bitmap_line: {
    .label x = $c
    .label y = $e
    .label dx = $18
    .label dy = 6
    .label sx = $1a
    .label sy = 4
    .label e1 = 2
    .label e = $10
    .label x1 = $c
    .label y1 = $e
    .label x2 = $20
    .label y2 = $22
    lda x2
    sec
    sbc x
    sta abs_u16.w
    lda x2+1
    sbc x+1
    sta abs_u16.w+1
    jsr abs_u16
    lda abs_u16.return
    sta dx
    lda abs_u16.return+1
    sta dx+1
    lda y2
    sec
    sbc y
    sta abs_u16.w
    lda y2+1
    sbc y+1
    sta abs_u16.w+1
    jsr abs_u16
    lda dx
    bne b1
    lda dx+1
    bne b1
    lda dy
    bne !+
    lda dy+1
    bne !b4+
    jmp b4
  !b4:
  !:
  b1:
    lda x2
    sec
    sbc x
    sta sgn_u16.w
    lda x2+1
    sbc x+1
    sta sgn_u16.w+1
    jsr sgn_u16
    lda sgn_u16.return
    sta sx
    lda sgn_u16.return+1
    sta sx+1
    lda y2
    sec
    sbc y
    sta sgn_u16.w
    lda y2+1
    sbc y+1
    sta sgn_u16.w+1
    jsr sgn_u16
    lda dy+1
    cmp dx+1
    bcc b2
    bne !+
    lda dy
    cmp dx
    bcc b2
  !:
    lda dx+1
    lsr
    sta e+1
    lda dx
    ror
    sta e
  b6:
    lda y
    tax
    jsr bitmap_plot
    lda y
    clc
    adc sy
    sta y
    lda y+1
    adc sy+1
    sta y+1
    lda e
    clc
    adc dx
    sta e
    lda e+1
    adc dx+1
    sta e+1
    cmp dy+1
    bne !+
    lda e
    cmp dy
    beq b7
  !:
    bcc b7
    lda x
    clc
    adc sx
    sta x
    lda x+1
    adc sx+1
    sta x+1
    lda e
    sec
    sbc dy
    sta e
    lda e+1
    sbc dy+1
    sta e+1
  b7:
    lda y+1
    cmp y2+1
    bne b6
    lda y
    cmp y2
    bne b6
  b3:
    lda y
    tax
    jsr bitmap_plot
    rts
  b2:
    lda dy+1
    lsr
    sta e1+1
    lda dy
    ror
    sta e1
  b9:
    lda y
    tax
    jsr bitmap_plot
    lda x
    clc
    adc sx
    sta x
    lda x+1
    adc sx+1
    sta x+1
    lda e1
    clc
    adc dy
    sta e1
    lda e1+1
    adc dy+1
    sta e1+1
    cmp dx+1
    bne !+
    lda e1
    cmp dx
    beq b10
  !:
    bcc b10
    lda y
    clc
    adc sy
    sta y
    lda y+1
    adc sy+1
    sta y+1
    lda e1
    sec
    sbc dx
    sta e1
    lda e1+1
    sbc dx+1
    sta e1+1
  b10:
    lda x+1
    cmp x2+1
    bne b9
    lda x
    cmp x2
    bne b9
    jmp b3
  b4:
    lda y
    tax
    jsr bitmap_plot
    rts
}
// Plot a single dot in the bitmap
// bitmap_plot(word zeropage($c) x, byte register(X) y)
bitmap_plot: {
    .label _1 = $1e
    .label plotter = $1c
    .label x = $c
    lda bitmap_plot_yhi,x
    sta plotter+1
    lda bitmap_plot_ylo,x
    sta plotter
    lda x
    and #<$fff8
    sta _1
    lda x+1
    and #>$fff8
    sta _1+1
    lda plotter
    clc
    adc _1
    sta plotter
    lda plotter+1
    adc _1+1
    sta plotter+1
    lda x
    tay
    lda bitmap_plot_bit,y
    ldy #0
    ora (plotter),y
    sta (plotter),y
    rts
}
// Get the sign of a 16-bit unsigned number treated as a signed number.
// Returns unsigned -1 if the number is
// sgn_u16(word zeropage($10) w)
sgn_u16: {
    .label w = $10
    .label return = 4
    lda w+1
    and #$80
    cmp #0
    bne b1
    lda #<1
    sta return
    lda #>1
    sta return+1
    rts
  b1:
    lda #<-1
    sta return
    lda #>-1
    sta return+1
    rts
}
// Get the absolute value of a 16-bit unsigned number treated as a signed number.
// abs_u16(word zeropage(6) w)
abs_u16: {
    .label w = 6
    .label return = 6
    lda w+1
    and #$80
    cmp #0
    bne b1
    rts
  b1:
    sec
    lda #0
    sbc return
    sta return
    lda #0
    sbc return+1
    sta return+1
    rts
}
// Generate a 8-segment quadratic spline using 16-bit fixed point 1/64-format math (6 decimal bits).
// The resulting spline segment points are returned in SPLINE_8SEG[]
// Point values must be within [-200 ; 1ff] for the calculation to not overflow.
// A quadratic spline is a curve defined by 3 points: P0, P1 and P2.
// The curve connects P0 to P2 through a smooth curve that moves towards P1, but does usually not touch it.
// spline_8segB(signed word zeropage($c) p0_x, signed word zeropage($e) p0_y, signed word zeropage($20) p1_x, signed word zeropage($22) p1_y, signed word zeropage($14) p2_x, signed word zeropage($16) p2_y)
spline_8segB: {
    .label _0 = $1e
    .label _1 = $1e
    .label _3 = $18
    .label _4 = $18
    .label _6 = $20
    .label _8 = $22
    .label _10 = $20
    .label _12 = $22
    .label _18 = $c
    .label _19 = $c
    .label _20 = $e
    .label _21 = $e
    .label _22 = $1a
    .label _23 = $1a
    .label _24 = $1c
    .label _25 = $1c
    .label a_x = $1e
    .label a_y = $18
    .label b_x = $20
    .label b_y = $22
    .label i_x = $20
    .label i_y = $22
    .label j_x = $1e
    .label j_y = $18
    .label p_x = $c
    .label p_y = $e
    .label p0_x = $c
    .label p0_y = $e
    .label p1_x = $20
    .label p1_y = $22
    .label p2_x = $14
    .label p2_y = $16
    lda p1_x
    asl
    sta _0
    lda p1_x+1
    rol
    sta _0+1
    lda p2_x
    sec
    sbc _1
    sta _1
    lda p2_x+1
    sbc _1+1
    sta _1+1
    lda a_x
    clc
    adc p0_x
    sta a_x
    lda a_x+1
    adc p0_x+1
    sta a_x+1
    lda p1_y
    asl
    sta _3
    lda p1_y+1
    rol
    sta _3+1
    lda p2_y
    sec
    sbc _4
    sta _4
    lda p2_y+1
    sbc _4+1
    sta _4+1
    lda a_y
    clc
    adc p0_y
    sta a_y
    lda a_y+1
    adc p0_y+1
    sta a_y+1
    lda _6
    sec
    sbc p0_x
    sta _6
    lda _6+1
    sbc p0_x+1
    sta _6+1
    asl b_x
    rol b_x+1
    lda _8
    sec
    sbc p0_y
    sta _8
    lda _8+1
    sbc p0_y+1
    sta _8+1
    asl b_y
    rol b_y+1
    asl _10
    rol _10+1
    asl _10
    rol _10+1
    asl _10
    rol _10+1
    lda i_x
    clc
    adc a_x
    sta i_x
    lda i_x+1
    adc a_x+1
    sta i_x+1
    asl _12
    rol _12+1
    asl _12
    rol _12+1
    asl _12
    rol _12+1
    lda i_y
    clc
    adc a_y
    sta i_y
    lda i_y+1
    adc a_y+1
    sta i_y+1
    asl j_x
    rol j_x+1
    asl j_y
    rol j_y+1
    lda p_x+1
    sta $ff
    lda p_x
    sta p_x+1
    lda #0
    sta p_x
    lsr $ff
    ror p_x+1
    ror p_x
    lsr $ff
    ror p_x+1
    ror p_x
    lda p_y+1
    sta $ff
    lda p_y
    sta p_y+1
    lda #0
    sta p_y
    lsr $ff
    ror p_y+1
    ror p_y
    lsr $ff
    ror p_y+1
    ror p_y
    tay
  b1:
    lda p_x
    clc
    adc #<$20
    sta _22
    lda p_x+1
    adc #>$20
    sta _22+1
    lda _23
    sta $ff
    lda _23+1
    sta _23
    lda #0
    bit _23+1
    bpl !+
    lda #$ff
  !:
    sta _23+1
    rol $ff
    rol _23
    rol _23+1
    rol $ff
    rol _23
    rol _23+1
    lda p_y
    clc
    adc #<$20
    sta _24
    lda p_y+1
    adc #>$20
    sta _24+1
    lda _25
    sta $ff
    lda _25+1
    sta _25
    lda #0
    bit _25+1
    bpl !+
    lda #$ff
  !:
    sta _25+1
    rol $ff
    rol _25
    rol _25+1
    rol $ff
    rol _25
    rol _25+1
    tya
    asl
    asl
    tax
    lda _23
    sta SPLINE_8SEG,x
    lda _23+1
    sta SPLINE_8SEG+1,x
    lda _25
    sta SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y,x
    lda _25+1
    sta SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y+1,x
    lda p_x
    clc
    adc i_x
    sta p_x
    lda p_x+1
    adc i_x+1
    sta p_x+1
    lda p_y
    clc
    adc i_y
    sta p_y
    lda p_y+1
    adc i_y+1
    sta p_y+1
    lda i_x
    clc
    adc j_x
    sta i_x
    lda i_x+1
    adc j_x+1
    sta i_x+1
    lda i_y
    clc
    adc j_y
    sta i_y
    lda i_y+1
    adc j_y+1
    sta i_y+1
    iny
    cpy #8
    beq !b1+
    jmp b1
  !b1:
    lda _18
    clc
    adc #<$20
    sta _18
    lda _18+1
    adc #>$20
    sta _18+1
    lda _19
    sta $ff
    lda _19+1
    sta _19
    lda #0
    bit _19+1
    bpl !+
    lda #$ff
  !:
    sta _19+1
    rol $ff
    rol _19
    rol _19+1
    rol $ff
    rol _19
    rol _19+1
    lda _20
    clc
    adc #<$20
    sta _20
    lda _20+1
    adc #>$20
    sta _20+1
    lda _21
    sta $ff
    lda _21+1
    sta _21
    lda #0
    bit _21+1
    bpl !+
    lda #$ff
  !:
    sta _21+1
    rol $ff
    rol _21
    rol _21+1
    rol $ff
    rol _21
    rol _21+1
    lda _19
    sta SPLINE_8SEG+8*SIZEOF_STRUCT_SPLINEVECTOR16
    lda _19+1
    sta SPLINE_8SEG+8*SIZEOF_STRUCT_SPLINEVECTOR16+1
    lda _21
    sta SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y+8*SIZEOF_STRUCT_SPLINEVECTOR16
    lda _21+1
    sta SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y+8*SIZEOF_STRUCT_SPLINEVECTOR16+1
    rts
}
// 2D-rotate a vector by an angle
// rotate(signed word zeropage(2) vector_x, signed word zeropage(4) vector_y, byte register(Y) angle)
rotate: {
    .label _1 = 8
    .label _2 = $18
    .label _4 = 8
    .label _5 = $1a
    .label _8 = 8
    .label _9 = $1c
    .label _10 = $1c
    .label _11 = 8
    .label _12 = $1e
    .label _13 = $1e
    .label vector_x = 2
    .label vector_y = 4
    .label return_x = $20
    .label return_y = $22
    .label cos_a = 6
    .label xr = $18
    .label yr = $1a
    .label sin_a = 6
    lda COS,y
    sta cos_a
    ora #$7f
    bmi !+
    lda #0
  !:
    sta cos_a+1
    lda vector_x
    sta mulf16s.b
    lda vector_x+1
    sta mulf16s.b+1
    jsr mulf16s
    lda _1
    sta _2
    lda _1+1
    sta _2+1
    asl xr
    rol xr+1
    lda vector_y
    sta mulf16s.b
    lda vector_y+1
    sta mulf16s.b+1
    jsr mulf16s
    lda _4
    sta _5
    lda _4+1
    sta _5+1
    asl yr
    rol yr+1
    lda SIN,y
    sta sin_a
    ora #$7f
    bmi !+
    lda #0
  !:
    sta sin_a+1
    lda vector_y
    sta mulf16s.b
    lda vector_y+1
    sta mulf16s.b+1
    jsr mulf16s
    lda _8
    sta _9
    lda _8+1
    sta _9+1
    asl _10
    rol _10+1
    // signed fixed[0.7]
    lda xr
    sec
    sbc _10
    sta xr
    lda xr+1
    sbc _10+1
    sta xr+1
    lda vector_x
    sta mulf16s.b
    lda vector_x+1
    sta mulf16s.b+1
    jsr mulf16s
    lda _11
    sta _12
    lda _11+1
    sta _12+1
    asl _13
    rol _13+1
    // signed fixed[8.8]
    lda yr
    clc
    adc _13
    sta yr
    lda yr+1
    adc _13+1
    sta yr+1
    lda xr+1
    sta return_x
    ora #$7f
    bmi !+
    lda #0
  !:
    sta return_x+1
    lda yr+1
    sta return_y
    ora #$7f
    bmi !+
    lda #0
  !:
    sta return_y+1
    rts
}
// Fast multiply two signed words to a signed double word result
// Fixes offsets introduced by using unsigned multiplication
// mulf16s(signed word zeropage(6) a, signed word zeropage($10) b)
mulf16s: {
    .label _9 = $20
    .label _13 = $22
    .label _16 = $20
    .label _17 = $22
    .label m = 8
    .label return = 8
    .label a = 6
    .label b = $10
    lda a
    sta mulf16u.a
    lda a+1
    sta mulf16u.a+1
    lda b
    sta mulf16u.b
    lda b+1
    sta mulf16u.b+1
    jsr mulf16u
    lda a+1
    bpl b1
    lda m+2
    sta _9
    lda m+3
    sta _9+1
    lda _16
    sec
    sbc b
    sta _16
    lda _16+1
    sbc b+1
    sta _16+1
    lda _16
    sta m+2
    lda _16+1
    sta m+3
  b1:
    lda b+1
    bpl b2
    lda m+2
    sta _13
    lda m+3
    sta _13+1
    lda _17
    sec
    sbc a
    sta _17
    lda _17+1
    sbc a+1
    sta _17+1
    lda _17
    sta m+2
    lda _17+1
    sta m+3
  b2:
    rts
}
// Fast multiply two unsigned words to a double word result
// Done in assembler to utilize fast addition A+X
// mulf16u(word zeropage($1e) a, word zeropage($20) b)
mulf16u: {
    .label memA = $f8
    .label memB = $fa
    .label memR = $fc
    .label return = 8
    .label a = $1e
    .label b = $20
    lda a
    sta memA
    lda a+1
    sta memA+1
    lda b
    sta memB
    lda b+1
    sta memB+1
    lda memA
    sta sm1a+1
    sta sm3a+1
    sta sm5a+1
    sta sm7a+1
    eor #$ff
    sta sm2a+1
    sta sm4a+1
    sta sm6a+1
    sta sm8a+1
    lda memA+1
    sta sm1b+1
    sta sm3b+1
    sta sm5b+1
    sta sm7b+1
    eor #$ff
    sta sm2b+1
    sta sm4b+1
    sta sm6b+1
    sta sm8b+1
    ldx memB
    sec
  sm1a:
    lda mulf_sqr1_lo,x
  sm2a:
    sbc mulf_sqr2_lo,x
    sta memR+0
  sm3a:
    lda mulf_sqr1_hi,x
  sm4a:
    sbc mulf_sqr2_hi,x
    sta _AA+1
    sec
  sm1b:
    lda mulf_sqr1_lo,x
  sm2b:
    sbc mulf_sqr2_lo,x
    sta _cc+1
  sm3b:
    lda mulf_sqr1_hi,x
  sm4b:
    sbc mulf_sqr2_hi,x
    sta _CC+1
    ldx memB+1
    sec
  sm5a:
    lda mulf_sqr1_lo,x
  sm6a:
    sbc mulf_sqr2_lo,x
    sta _bb+1
  sm7a:
    lda mulf_sqr1_hi,x
  sm8a:
    sbc mulf_sqr2_hi,x
    sta _BB+1
    sec
  sm5b:
    lda mulf_sqr1_lo,x
  sm6b:
    sbc mulf_sqr2_lo,x
    sta _dd+1
  sm7b:
    lda mulf_sqr1_hi,x
  sm8b:
    sbc mulf_sqr2_hi,x
    sta memR+3
    clc
  _AA:
    lda #0
  _bb:
    adc #0
    sta memR+1
  _BB:
    lda #0
  _CC:
    adc #0
    sta memR+2
    bcc !+
    inc memR+3
    clc
  !:
  _cc:
    lda #0
    adc memR+1
    sta memR+1
  _dd:
    lda #0
    adc memR+2
    sta memR+2
    bcc !+
    inc memR+3
  !:
    lda memR
    sta return
    lda memR+1
    sta return+1
    lda memR+2
    sta return+2
    lda memR+3
    sta return+3
    rts
}
// Clear all graphics on the bitmap
// bgcol - the background color to fill the screen with
// fgcol - the foreground color to fill the screen with
bitmap_clear: {
    .const col = WHITE<<4
    ldx #col
    lda #<BITMAP_SCREEN
    sta memset.str
    lda #>BITMAP_SCREEN
    sta memset.str+1
    lda #<$3e8
    sta memset.num
    lda #>$3e8
    sta memset.num+1
    jsr memset
    ldx #0
    lda #<BITMAP_GRAPHICS
    sta memset.str
    lda #>BITMAP_GRAPHICS
    sta memset.str+1
    lda #<$1f40
    sta memset.num
    lda #>$1f40
    sta memset.num+1
    jsr memset
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage($e) str, byte register(X) c, word zeropage($c) num)
memset: {
    .label end = $c
    .label dst = $e
    .label num = $c
    .label str = $e
    lda num
    bne !+
    lda num+1
    beq breturn
  !:
    lda end
    clc
    adc str
    sta end
    lda end+1
    adc str+1
    sta end+1
  b2:
    lda dst+1
    cmp end+1
    bne b3
    lda dst
    cmp end
    bne b3
  breturn:
    rts
  b3:
    txa
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    jmp b2
}
// Initialize bitmap plotting tables
bitmap_init: {
    .label _7 = $24
    .label yoffs = $10
    ldx #0
    lda #$80
  b1:
    sta bitmap_plot_bit,x
    lsr
    cmp #0
    bne b2
    lda #$80
  b2:
    inx
    cpx #0
    bne b1
    lda #<BITMAP_GRAPHICS
    sta yoffs
    lda #>BITMAP_GRAPHICS
    sta yoffs+1
    ldx #0
  b3:
    lda #7
    sax _7
    lda yoffs
    ora _7
    sta bitmap_plot_ylo,x
    lda yoffs+1
    sta bitmap_plot_yhi,x
    lda #7
    cmp _7
    bne b4
    clc
    lda yoffs
    adc #<$28*8
    sta yoffs
    lda yoffs+1
    adc #>$28*8
    sta yoffs+1
  b4:
    inx
    cpx #0
    bne b3
    rts
}
// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x/4)
mulf_init: {
    .label c = $12
    .label sqr1_hi = $16
    .label sqr = $1c
    .label sqr1_lo = $14
    .label sqr2_hi = $1a
    .label sqr2_lo = $18
    .label dir = $13
    ldx #0
    lda #<mulf_sqr1_hi+1
    sta sqr1_hi
    lda #>mulf_sqr1_hi+1
    sta sqr1_hi+1
    txa
    sta sqr
    sta sqr+1
    sta c
    lda #<mulf_sqr1_lo+1
    sta sqr1_lo
    lda #>mulf_sqr1_lo+1
    sta sqr1_lo+1
  b1:
    lda sqr1_lo+1
    cmp #>mulf_sqr1_lo+$200
    bne b2
    lda sqr1_lo
    cmp #<mulf_sqr1_lo+$200
    bne b2
    lda #$ff
    sta dir
    lda #<mulf_sqr2_hi
    sta sqr2_hi
    lda #>mulf_sqr2_hi
    sta sqr2_hi+1
    ldx #-1
    lda #<mulf_sqr2_lo
    sta sqr2_lo
    lda #>mulf_sqr2_lo
    sta sqr2_lo+1
  b5:
    lda sqr2_lo+1
    cmp #>mulf_sqr2_lo+$1ff
    bne b6
    lda sqr2_lo
    cmp #<mulf_sqr2_lo+$1ff
    bne b6
    // Set the very last value g(511) = f(256)
    lda mulf_sqr1_lo+$100
    sta mulf_sqr2_lo+$1ff
    lda mulf_sqr1_hi+$100
    sta mulf_sqr2_hi+$1ff
    rts
  b6:
    lda mulf_sqr1_lo,x
    ldy #0
    sta (sqr2_lo),y
    lda mulf_sqr1_hi,x
    sta (sqr2_hi),y
    inc sqr2_hi
    bne !+
    inc sqr2_hi+1
  !:
    txa
    clc
    adc dir
    tax
    cpx #0
    bne b8
    lda #1
    sta dir
  b8:
    inc sqr2_lo
    bne !+
    inc sqr2_lo+1
  !:
    jmp b5
  b2:
    inc c
    lda #1
    and c
    cmp #0
    bne b3
    inx
    inc sqr
    bne !+
    inc sqr+1
  !:
  b3:
    lda sqr
    ldy #0
    sta (sqr1_lo),y
    lda sqr+1
    sta (sqr1_hi),y
    inc sqr1_hi
    bne !+
    inc sqr1_hi+1
  !:
    txa
    clc
    adc sqr
    sta sqr
    bcc !+
    inc sqr+1
  !:
    inc sqr1_lo
    bne !+
    inc sqr1_lo+1
  !:
    jmp b1
}
  // Array filled with spline segment points by splinePlot_8()
  SPLINE_8SEG: .fill 4*9, 0
  // Tables for the plotter - initialized by calling bitmap_init();
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
  // mulf_sqr tables will contain f(x)=int(x*x/4) and g(x) = f(x-255).
  // <f(x) = <(( x * x )/4)
  .align $100
  mulf_sqr1_lo: .fill $200, 0
  // >f(x) = >(( x * x )/4)
  .align $100
  mulf_sqr1_hi: .fill $200, 0
  // <g(x) =  <((( x - 255) * ( x - 255 ))/4)
  .align $100
  mulf_sqr2_lo: .fill $200, 0
  // >g(x) = >((( x - 255) * ( x - 255 ))/4)
  .align $100
  mulf_sqr2_hi: .fill $200, 0
  // True type letter c
letter_c:
  .byte MOVE_TO
  .word $6c, $92, 0, 0
  .byte SPLINE_TO
  .word $59, $b6, $67, $a9
  .byte SPLINE_TO
  .word $3b, $c3, $4b, $c3
  .byte SPLINE_TO
  .word $17, $b2, $26, $c3
  .byte SPLINE_TO
  .word 9, $84, 9, $a1
  .byte SPLINE_TO
  .word $19, $57, 9, $68
  .byte SPLINE_TO
  .word $41, $45, $2a, $45
  .byte SPLINE_TO
  .word $5d, $4f, $52, $45
  .byte SPLINE_TO
  .word $69, $62, $69, $58
  .byte SPLINE_TO
  .word $66, $6a, $69, $67
  .byte SPLINE_TO
  .word $5d, $6d, $62, $6d
  .byte SPLINE_TO
  .word $51, $68, $55, $6d
  .byte SPLINE_TO
  .word $4e, $5d, $4f, $65
  .byte SPLINE_TO
  .word $49, $52, $4e, $56
  .byte SPLINE_TO
  .word $3d, $4e, $45, $4e
  .byte SPLINE_TO
  .word $28, $58, $30, $4e
  .byte SPLINE_TO
  .word $1d, $79, $1d, $64
  .byte SPLINE_TO
  .word $28, $9e, $1d, $8e
  .byte SPLINE_TO
  .word $44, $ae, $32, $ae
  .byte SPLINE_TO
  .word $5b, $a6, $50, $ae
  .byte SPLINE_TO
  .word $68, $90, $62, $a0
  .byte LINE_TO
  .word $6c, $92, 0, 0
  // Sine and Cosine tables
  // Angles: $00=0, $80=PI,$100=2*PI
  // Sine/Cosine: signed fixed [-$7f,$7f]
  .align $40
SIN:
.for(var i=0;i<$140;i++)
        .byte >round($7fff*sin(i*2*PI/256))

