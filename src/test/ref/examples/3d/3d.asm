//  3D Rotation using a Rotation Matrix
//  Based on: 
//  - C= Hacking Magazine Issue 8. http://www.ffd2.com/fridge/chacking/c=hacking8.txt
//  - Codebase64 Article http://codebase64.org/doku.php?id=base:3d_rotation  
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label RASTER = $d012
  .label SPRITES_ENABLE = $d015
  .label BORDERCOL = $d020
  .label SPRITES_COLS = $d027
  .const GREEN = 5
  .const LIGHT_BLUE = $e
  .const LIGHT_GREY = $f
  .label print_line_cursor = $400
  .label xr = $f0
  .label yr = $f1
  .label zr = $f2
  .label pp = $f3
  .label xp = $f4
  .label yp = $f5
  .label psp1 = $f6
  .label psp2 = $f8
  .label SCREEN = $400
  .const sz = 0
  .label mulf_sqr1 = $2400
  .label mulf_sqr2 = $2600
  .label SPRITE = $3000
  .label PERSP_Z = $2800
  .label SINH = $2000
  .label SINQ = $2200
  .label SINH_LO = $4000
  .label SINH_HI = $4200
  .label SINQ_LO = $4400
  .label SINQ_HI = $4600
  .label COSH = SINH+$40
  .label COSQ = SINQ+$40
  .label sx = 2
  .label sy = 3
//  sin(x) = cos(x+PI/2)
//  sin(x) = cos(x+PI/2)
main: {
    sei
    jsr sprites_init
    // mulf_init();
    lda #<mulf_sqr1
    sta psp1
    lda #>mulf_sqr1
    sta psp1+1
    lda #<mulf_sqr2
    sta psp2
    lda #>mulf_sqr2
    sta psp2+1
    jsr debug_print_init
    jsr anim
    rts
}
anim: {
    .label i = 4
    lda #0
    sta sy
    sta sx
  // signed byte xmin = 0;
  // signed byte xmax = 0;
  b4:
    lda RASTER
    cmp #$ff
    bne b4
  b7:
    lda RASTER
    cmp #$fe
    bne b7
  b10:
    lda RASTER
    cmp #$fd
    bne b10
    inc BORDERCOL
    ldx sx
    jsr calculate_matrix
    jsr store_matrix
    lda #0
    sta i
  b13:
    inc BORDERCOL
    ldy i
    lda xs,y
    sta rotate_matrix.x
    ldx i
    ldy ys,x
    lda zs,x
    tax
    jsr rotate_matrix
    // if(*xr<xmin) xmin = *xr;
    // if(*xr>xmax) xmax = *xr;
    ldy i
    lda xr
    sta xrs,y
    lda yr
    sta yrs,y
    lda zr
    sta zrs,y
    lda pp
    sta pps,y
    lda xp
    sta xps,y
    lda yp
    sta yps,y
    tya
    asl
    tax
    lda #$80
    clc
    adc xp
    sta SPRITES_XPOS,x
    lda #$80
    clc
    adc yp
    sta SPRITES_YPOS,x
    inc i
    lda i
    cmp #8
    bne b13
    lda #LIGHT_GREY
    sta BORDERCOL
    jsr debug_print
    lda #LIGHT_BLUE
    sta BORDERCOL
    //  Increment angles        
    inc sx
    inc sx
    lda sy
    sec
    sbc #3
    sta sy
    jmp b4
}
debug_print: {
    .const print_sbyte_pos1_row = 0
    .const print_sbyte_pos1_col = $25
    .const print_sbyte_pos2_row = 1
    .const print_sbyte_pos2_col = $25
    .const print_sbyte_pos3_row = 2
    .const print_sbyte_pos3_col = $25
    .const print_sbyte_pos4_row = 4
    .const print_sbyte_pos4_col = $1d
    .const print_sbyte_pos5_row = 4
    .const print_sbyte_pos5_col = $21
    .const print_sbyte_pos6_row = 4
    .const print_sbyte_pos6_col = $25
    .const print_sbyte_pos7_row = 5
    .const print_sbyte_pos7_col = $1d
    .const print_sbyte_pos8_row = 5
    .const print_sbyte_pos8_col = $21
    .const print_sbyte_pos9_row = 5
    .const print_sbyte_pos9_col = $25
    .const print_sbyte_pos10_row = 6
    .const print_sbyte_pos10_col = $1d
    .const print_sbyte_pos11_row = 6
    .const print_sbyte_pos11_col = $21
    .const print_sbyte_pos12_row = 6
    .const print_sbyte_pos12_col = $25
    .label at_line = SCREEN+$13*$28
    .label c = 4
    .label i = 5
    ldx sx
    lda #<print_line_cursor+print_sbyte_pos1_row*$28+print_sbyte_pos1_col
    sta print_sbyte_at.at
    lda #>print_line_cursor+print_sbyte_pos1_row*$28+print_sbyte_pos1_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    lda sy
    tax
    lda #<print_line_cursor+print_sbyte_pos2_row*$28+print_sbyte_pos2_col
    sta print_sbyte_at.at
    lda #>print_line_cursor+print_sbyte_pos2_row*$28+print_sbyte_pos2_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    lda #<print_line_cursor+print_sbyte_pos3_row*$28+print_sbyte_pos3_col
    sta print_sbyte_at.at
    lda #>print_line_cursor+print_sbyte_pos3_row*$28+print_sbyte_pos3_col
    sta print_sbyte_at.at+1
    ldx #sz
    jsr print_sbyte_at
    lda rotation_matrix
    tax
    lda #<print_line_cursor+print_sbyte_pos4_row*$28+print_sbyte_pos4_col
    sta print_sbyte_at.at
    lda #>print_line_cursor+print_sbyte_pos4_row*$28+print_sbyte_pos4_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+1
    lda #<print_line_cursor+print_sbyte_pos5_row*$28+print_sbyte_pos5_col
    sta print_sbyte_at.at
    lda #>print_line_cursor+print_sbyte_pos5_row*$28+print_sbyte_pos5_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+2
    lda #<print_line_cursor+print_sbyte_pos6_row*$28+print_sbyte_pos6_col
    sta print_sbyte_at.at
    lda #>print_line_cursor+print_sbyte_pos6_row*$28+print_sbyte_pos6_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+3
    lda #<print_line_cursor+print_sbyte_pos7_row*$28+print_sbyte_pos7_col
    sta print_sbyte_at.at
    lda #>print_line_cursor+print_sbyte_pos7_row*$28+print_sbyte_pos7_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+4
    lda #<print_line_cursor+print_sbyte_pos8_row*$28+print_sbyte_pos8_col
    sta print_sbyte_at.at
    lda #>print_line_cursor+print_sbyte_pos8_row*$28+print_sbyte_pos8_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+5
    lda #<print_line_cursor+print_sbyte_pos9_row*$28+print_sbyte_pos9_col
    sta print_sbyte_at.at
    lda #>print_line_cursor+print_sbyte_pos9_row*$28+print_sbyte_pos9_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+6
    lda #<print_line_cursor+print_sbyte_pos10_row*$28+print_sbyte_pos10_col
    sta print_sbyte_at.at
    lda #>print_line_cursor+print_sbyte_pos10_row*$28+print_sbyte_pos10_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+7
    lda #<print_line_cursor+print_sbyte_pos11_row*$28+print_sbyte_pos11_col
    sta print_sbyte_at.at
    lda #>print_line_cursor+print_sbyte_pos11_row*$28+print_sbyte_pos11_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+8
    lda #<print_line_cursor+print_sbyte_pos12_row*$28+print_sbyte_pos12_col
    sta print_sbyte_at.at
    lda #>print_line_cursor+print_sbyte_pos12_row*$28+print_sbyte_pos12_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    lda #0
    sta i
    lda #4
    sta c
  b1:
    lda c
    clc
    adc #<at_line
    sta print_sbyte_at.at
    lda #>at_line
    adc #0
    sta print_sbyte_at.at+1
    ldx i
    lda xrs,x
    tax
    jsr print_sbyte_at
    lda c
    clc
    adc #<at_line+$28*1
    sta print_sbyte_at.at
    lda #>at_line+$28*1
    adc #0
    sta print_sbyte_at.at+1
    ldx i
    lda yrs,x
    tax
    jsr print_sbyte_at
    lda c
    clc
    adc #<at_line+$28*2
    sta print_sbyte_at.at
    lda #>at_line+$28*2
    adc #0
    sta print_sbyte_at.at+1
    ldx i
    lda zrs,x
    tax
    jsr print_sbyte_at
    lda c
    clc
    adc #<at_line+$28*3
    sta print_sbyte_at.at
    lda #>at_line+$28*3
    adc #0
    sta print_sbyte_at.at+1
    ldx i
    lda pps,x
    tax
    jsr print_sbyte_at
    lda c
    clc
    adc #<at_line+$28*4
    sta print_sbyte_at.at
    lda #>at_line+$28*4
    adc #0
    sta print_sbyte_at.at+1
    ldx i
    lda xps,x
    tax
    jsr print_sbyte_at
    lda c
    clc
    adc #<at_line+$28*5
    sta print_sbyte_at.at
    lda #>at_line+$28*5
    adc #0
    sta print_sbyte_at.at+1
    ldx i
    lda yps,x
    tax
    jsr print_sbyte_at
    lda #4
    clc
    adc c
    sta c
    inc i
    lda i
    cmp #8
    beq !b1+
    jmp b1
  !b1:
    rts
}
//  Print a signed byte as hex at a specific screen position
print_sbyte_at: {
    .label at = 6
    cpx #0
    bmi b1
    lda #' '
    sta print_char_at.ch
    jsr print_char_at
  b2:
    inc print_byte_at.at
    bne !+
    inc print_byte_at.at+1
  !:
    jsr print_byte_at
    rts
  b1:
    lda #'-'
    sta print_char_at.ch
    jsr print_char_at
    txa
    eor #$ff
    clc
    adc #1
    tax
    jmp b2
}
//  Print a single char
print_char_at: {
    .label at = 6
    .label ch = 8
    lda ch
    ldy #0
    sta (at),y
    rts
}
//  Print a byte as HEX at a specific position
print_byte_at: {
    .label at = 6
    txa
    lsr
    lsr
    lsr
    lsr
    tay
    lda print_hextab,y
    sta print_char_at.ch
    jsr print_char_at
    txa
    and #$f
    tax
    inc print_char_at.at
    bne !+
    inc print_char_at.at+1
  !:
    lda print_hextab,x
    sta print_char_at.ch
    jsr print_char_at
    rts
}
//  Rotate a 3D point (x,y,z) using the rotation matrix
//  The rotation matrix is prepared by calling prepare_matrix() 
//  The passed points must be in the interval [-$3f;$3f].
//  Implemented in assembler to utilize seriously fast multiplication 
rotate_matrix: {
    .label x = 5
    lda x
    sta xr
    tya
    sta yr
    txa
    sta zr
    tax
  C1:
    lda mulf_sqr1,x
    sec
  C2:
    sbc mulf_sqr2,x
    sta C3+1
  F1:
    lda mulf_sqr1,x
    sec
  F2:
    sbc mulf_sqr2,x
    sta F3+1
  I1:
    lda mulf_sqr1,x
    sec
  I2:
    sbc mulf_sqr2,x
    sta I3+1
    ldx xr
    ldy yr
  I3:
    lda #0
    clc
  G1:
    adc mulf_sqr1,x
    sec
  G2:
    sbc mulf_sqr2,x
    clc
  H1:
    adc mulf_sqr1,y
    sec
  H2:
    sbc mulf_sqr2,y
    sta zr
    sta PP+1
  PP:
    lda PERSP_Z
    sta pp
    sta psp1
    eor #$ff
    sta psp2
  C3:
    lda #0
    clc
  A1:
    adc mulf_sqr1,x
    sec
  A2:
    sbc mulf_sqr2,x
    clc
  B1:
    adc mulf_sqr1,y
    sec
  B2:
    sbc mulf_sqr2,y
    sta xr
    sta XX+1
    clc
  F3:
    lda #0
    clc
  D1:
    adc mulf_sqr1,x
    sec
  D2:
    sbc mulf_sqr2,x
    clc
  E1:
    adc mulf_sqr1,y
    sec
  E2:
    sbc mulf_sqr2,y
    sta yr
    tay
    lda (psp1),y
    sec
    sbc (psp2),y
    sta yp
  XX:
    ldy #0
    lda (psp1),y
    sec
    sbc (psp2),y
    sta xp
    rts
}
//  Store the rotation matrix into the rotation routine rotate()
//  After this each call to rotate() will rotate a point with the matrix
//  Implemented in assembler to utilize seriously fast multiplication 
store_matrix: {
    lda rotation_matrix+0
    sta rotate_matrix.A1+1
    eor #$ff
    sta rotate_matrix.A2+1
    lda rotation_matrix+1
    sta rotate_matrix.B1+1
    eor #$ff
    sta rotate_matrix.B2+1
    lda rotation_matrix+2
    sta rotate_matrix.C1+1
    eor #$ff
    sta rotate_matrix.C2+1
    lda rotation_matrix+3
    sta rotate_matrix.D1+1
    eor #$ff
    sta rotate_matrix.D2+1
    lda rotation_matrix+4
    sta rotate_matrix.E1+1
    eor #$ff
    sta rotate_matrix.E2+1
    lda rotation_matrix+5
    sta rotate_matrix.F1+1
    eor #$ff
    sta rotate_matrix.F2+1
    lda rotation_matrix+6
    sta rotate_matrix.G1+1
    eor #$ff
    sta rotate_matrix.G2+1
    lda rotation_matrix+7
    sta rotate_matrix.H1+1
    eor #$ff
    sta rotate_matrix.H2+1
    lda rotation_matrix+8
    sta rotate_matrix.I1+1
    eor #$ff
    sta rotate_matrix.I2+1
    rts
}
//  Prepare the 3x3 rotation matrix into rotation_matrix[]
//  Angles sx, sy, sz are based on 2*PI=$100 
//  Method described in C= Hacking Magazine Issue 8. http://www.ffd2.com/fridge/chacking/c=hacking8.txt
calculate_matrix: {
    .label sy = 3
    .label t1 = 4
    .label t3 = 5
    .label t4 = 8
    .label t5 = $b
    .label t6 = $c
    .label t7 = $d
    .label t8 = $e
    .label t9 = $f
    .label t10 = $10
    lda sy
    sec
    sbc #sz
    sta t1
    lda #sz
    clc
    adc sy
    tay
    txa
    clc
    adc #sz
    sta t3
    txa
    sec
    sbc #sz
    sta t4
    txa
    sty $ff
    clc
    adc $ff
    sta t5
    txa
    sec
    sbc t1
    sta t6
    txa
    clc
    adc t1
    sta t7
    tya
    stx $ff
    sec
    sbc $ff
    sta t8
    txa
    eor #$ff
    sec
    adc sy
    sta t9
    txa
    clc
    adc sy
    sta t10
    ldx t1
    clc
    lda COSH,x
    adc COSH,y
    sta rotation_matrix
    sec
    lda SINH,x
    sbc SINH,y
    sta rotation_matrix+1
    ldy sy
    clc
    lda SINH,y
    adc SINH,y
    sta rotation_matrix+2
    ldx t3
    ldy t4
    sec
    lda SINH,x
    sbc SINH,y
    ldy t6
    clc
    adc COSQ,y
    ldy t5
    sec
    sbc COSQ,y
    ldy t8
    clc
    adc COSQ,y
    ldy t7
    sec
    sbc COSQ,y
    sta rotation_matrix+3
    ldy t4
    clc
    lda COSH,x
    adc COSH,y
    ldy t5
    clc
    adc SINQ,y
    ldy t6
    sec
    sbc SINQ,y
    ldy t7
    sec
    sbc SINQ,y
    ldy t8
    sec
    sbc SINQ,y
    sta rotation_matrix+4
    ldx t9
    ldy t10
    sec
    lda SINH,x
    sbc SINH,y
    sta rotation_matrix+5
    ldx t4
    ldy t3
    sec
    lda COSH,x
    sbc COSH,y
    ldy t6
    clc
    adc SINQ,y
    ldy t5
    sec
    sbc SINQ,y
    ldy t8
    sec
    sbc SINQ,y
    ldy t7
    sec
    sbc SINQ,y
    sta rotation_matrix+6
    ldx t3
    ldy t4
    clc
    lda SINH,x
    adc SINH,y
    ldy t6
    clc
    adc COSQ,y
    ldy t5
    sec
    sbc COSQ,y
    ldy t7
    clc
    adc COSQ,y
    ldy t8
    sec
    sbc COSQ,y
    sta rotation_matrix+7
    ldx t9
    ldy t10
    clc
    lda COSH,x
    adc COSH,y
    sta rotation_matrix+8
    rts
}
debug_print_init: {
    .label COLS = $d800
    .label at_line = SCREEN+$10*$28
    .label at_cols = COLS+$10*$28
    .label _59 = 6
    .label _60 = 6
    .label _63 = 6
    .label _64 = 6
    .label _67 = 6
    .label _68 = 6
    .label _71 = 6
    .label _72 = 6
    .label _75 = 6
    .label _76 = 6
    .label _79 = 6
    .label _80 = 6
    .label _83 = 6
    .label _84 = 6
    .label _87 = 6
    .label _88 = 6
    .label _91 = 6
    .label _92 = 6
    .label col = 4
    .label c = 2
    .label i = 3
    jsr print_cls
    lda #<SCREEN+$22
    sta print_str_at.at
    lda #>SCREEN+$22
    sta print_str_at.at+1
    lda #<str
    sta print_str_at.str
    lda #>str
    sta print_str_at.str+1
    jsr print_str_at
    lda #<SCREEN+$28*1+$22
    sta print_str_at.at
    lda #>SCREEN+$28*1+$22
    sta print_str_at.at+1
    lda #<str1
    sta print_str_at.str
    lda #>str1
    sta print_str_at.str+1
    jsr print_str_at
    lda #<SCREEN+$28*2+$22
    sta print_str_at.at
    lda #>SCREEN+$28*2+$22
    sta print_str_at.at+1
    lda #<str2
    sta print_str_at.str
    lda #>str2
    sta print_str_at.str+1
    jsr print_str_at
    lda #<SCREEN+$28*$10
    sta print_str_at.at
    lda #>SCREEN+$28*$10
    sta print_str_at.at+1
    lda #<str3
    sta print_str_at.str
    lda #>str3
    sta print_str_at.str+1
    jsr print_str_at
    lda #<SCREEN+$28*$11
    sta print_str_at.at
    lda #>SCREEN+$28*$11
    sta print_str_at.at+1
    lda #<str4
    sta print_str_at.str
    lda #>str4
    sta print_str_at.str+1
    jsr print_str_at
    lda #<SCREEN+$28*$12
    sta print_str_at.at
    lda #>SCREEN+$28*$12
    sta print_str_at.at+1
    lda #<str5
    sta print_str_at.str
    lda #>str5
    sta print_str_at.str+1
    jsr print_str_at
    lda #<SCREEN+$28*$13
    sta print_str_at.at
    lda #>SCREEN+$28*$13
    sta print_str_at.at+1
    lda #<str6
    sta print_str_at.str
    lda #>str6
    sta print_str_at.str+1
    jsr print_str_at
    lda #<SCREEN+$28*$14
    sta print_str_at.at
    lda #>SCREEN+$28*$14
    sta print_str_at.at+1
    lda #<str7
    sta print_str_at.str
    lda #>str7
    sta print_str_at.str+1
    jsr print_str_at
    lda #<SCREEN+$28*$15
    sta print_str_at.at
    lda #>SCREEN+$28*$15
    sta print_str_at.at+1
    lda #<str8
    sta print_str_at.str
    lda #>str8
    sta print_str_at.str+1
    jsr print_str_at
    lda #<SCREEN+$28*$16
    sta print_str_at.at
    lda #>SCREEN+$28*$16
    sta print_str_at.at+1
    lda #<str9
    sta print_str_at.str
    lda #>str9
    sta print_str_at.str+1
    jsr print_str_at
    lda #<SCREEN+$28*$17
    sta print_str_at.at
    lda #>SCREEN+$28*$17
    sta print_str_at.at+1
    lda #<str10
    sta print_str_at.str
    lda #>str10
    sta print_str_at.str+1
    jsr print_str_at
    lda #<SCREEN+$28*$18
    sta print_str_at.at
    lda #>SCREEN+$28*$18
    sta print_str_at.at+1
    lda #<str11
    sta print_str_at.str
    lda #>str11
    sta print_str_at.str+1
    jsr print_str_at
    lda #0
    sta i
    lda #4
    sta c
  b1:
    lda c
    clc
    adc #<at_line
    sta print_sbyte_at.at
    lda #>at_line
    adc #0
    sta print_sbyte_at.at+1
    ldx i
    lda xs,x
    tax
    jsr print_sbyte_at
    lda c
    clc
    adc #<at_line+$28*1
    sta print_sbyte_at.at
    lda #>at_line+$28*1
    adc #0
    sta print_sbyte_at.at+1
    ldx i
    lda ys,x
    tax
    jsr print_sbyte_at
    lda c
    clc
    adc #<at_line+$28*2
    sta print_sbyte_at.at
    lda #>at_line+$28*2
    adc #0
    sta print_sbyte_at.at+1
    ldx i
    lda zs,x
    tax
    jsr print_sbyte_at
    ldx #0
  b2:
    lda #8
    clc
    adc i
    sta col
    lda c
    clc
    adc #<at_cols
    sta _59
    lda #>at_cols
    adc #0
    sta _59+1
    txa
    clc
    adc _60
    sta _60
    lda #0
    adc _60+1
    sta _60+1
    lda col
    ldy #0
    sta (_60),y
    lda c
    clc
    adc #<at_cols+$28*1
    sta _63
    lda #>at_cols+$28*1
    adc #0
    sta _63+1
    txa
    clc
    adc _64
    sta _64
    tya
    adc _64+1
    sta _64+1
    lda col
    sta (_64),y
    lda c
    clc
    adc #<at_cols+$28*2
    sta _67
    lda #>at_cols+$28*2
    adc #0
    sta _67+1
    txa
    clc
    adc _68
    sta _68
    tya
    adc _68+1
    sta _68+1
    lda col
    sta (_68),y
    lda c
    clc
    adc #<at_cols+$28*3
    sta _71
    lda #>at_cols+$28*3
    adc #0
    sta _71+1
    txa
    clc
    adc _72
    sta _72
    tya
    adc _72+1
    sta _72+1
    lda col
    sta (_72),y
    lda c
    clc
    adc #<at_cols+$28*4
    sta _75
    lda #>at_cols+$28*4
    adc #0
    sta _75+1
    txa
    clc
    adc _76
    sta _76
    tya
    adc _76+1
    sta _76+1
    lda col
    sta (_76),y
    lda c
    clc
    adc #<at_cols+$28*5
    sta _79
    lda #>at_cols+$28*5
    adc #0
    sta _79+1
    txa
    clc
    adc _80
    sta _80
    tya
    adc _80+1
    sta _80+1
    lda col
    sta (_80),y
    lda c
    clc
    adc #<at_cols+$28*6
    sta _83
    lda #>at_cols+$28*6
    adc #0
    sta _83+1
    txa
    clc
    adc _84
    sta _84
    tya
    adc _84+1
    sta _84+1
    lda col
    sta (_84),y
    lda c
    clc
    adc #<at_cols+$28*7
    sta _87
    lda #>at_cols+$28*7
    adc #0
    sta _87+1
    txa
    clc
    adc _88
    sta _88
    tya
    adc _88+1
    sta _88+1
    lda col
    sta (_88),y
    lda c
    clc
    adc #<at_cols+$28*8
    sta _91
    lda #>at_cols+$28*8
    adc #0
    sta _91+1
    txa
    clc
    adc _92
    sta _92
    tya
    adc _92+1
    sta _92+1
    lda col
    sta (_92),y
    inx
    cpx #4
    beq !b2+
    jmp b2
  !b2:
    lda #4
    clc
    adc c
    sta c
    inc i
    lda i
    cmp #8
    beq !b1+
    jmp b1
  !b1:
    rts
    str: .text "sx@"
    str1: .text "sy@"
    str2: .text "sz@"
    str3: .text "x@"
    str4: .text "y@"
    str5: .text "z@"
    str6: .text "xr@"
    str7: .text "yr@"
    str8: .text "zr@"
    str9: .text "pp@"
    str10: .text "xp@"
    str11: .text "yp@"
}
//  Print a string at a specific screen position
print_str_at: {
    .label at = 9
    .label str = 6
  b1:
    ldy #0
    lda (str),y
    cmp #'@'
    bne b2
    rts
  b2:
    ldy #0
    lda (str),y
    sta (at),y
    inc at
    bne !+
    inc at+1
  !:
    inc str
    bne !+
    inc str+1
  !:
    jmp b1
}
//  Clear the screen. Also resets current line/char cursor.
print_cls: {
    .label sc = 6
    lda #<print_line_cursor
    sta sc
    lda #>print_line_cursor
    sta sc+1
  b1:
    lda #' '
    ldy #0
    sta (sc),y
    inc sc
    bne !+
    inc sc+1
  !:
    lda sc+1
    cmp #>print_line_cursor+$3e8
    bne b1
    lda sc
    cmp #<print_line_cursor+$3e8
    bne b1
    rts
}
//  Initialize sprites
sprites_init: {
    .label SCREEN = $400
    .label sprites_ptr = SCREEN+$3f8
    lda #$ff
    sta SPRITES_ENABLE
    ldx #0
  b1:
    lda #$ff&SPRITE/$40
    sta sprites_ptr,x
    lda #GREEN
    sta SPRITES_COLS,x
    inx
    cpx #8
    bne b1
    rts
}
  print_hextab: .text "0123456789abcdef"
  zs: .byte $34, $34, $34, $34, $34, $34, $34, $34
  //  Rotated positions
  xrs: .fill 8, 0
  yrs: .fill 8, 0
  zrs: .fill 8, 0
  //  Persepctive factors (from zrs)
  pps: .fill 8, 0
  //  Rotated positions with persepctive
  xps: .fill 8, 0
  yps: .fill 8, 0
  //  The rotation matrix
  rotation_matrix: .fill 9, 0
  //  Positions to rotate
  xs: .byte -$34, -$34, -$34, 0, 0, $34, $34, $34
  ys: .byte -$34, 0, $34, -$34, $34, -$34, 0, $34
.pc = mulf_sqr1 "mulf_sqr1"
  .for(var i=0;i<$200;i++) {
    	.if(i<=159) { .byte round((i*i)/256) }
    	.if(i>159 && i<=351 ) { .byte round(((i-256)*(i-256))/256) }
    	.if(i>351) { .byte round(((512-i)*(512-i))/256) }
    }

.pc = mulf_sqr2 "mulf_sqr2"
  .for(var i=0;i<$200;i++) {
    	.if(i<=159) { .byte round((-i-1)*(-i-1)/256) }
    	.if(i>159 && i<=351 ) { .byte round(((255-i)*(255-i))/256) }
    	.if(i>351) { .byte round(((i-511)*(i-511))/256) }  
    }

.pc = SPRITE "SPRITE"
  .var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)

.pc = PERSP_Z "PERSP_Z"
  {
    .var d = 256.0	
    .var z0 = 6.0	
    // These values of d/z0 result in table values from $20 to $40 (effectively max is $3f)
    .for(var z=0;z<$100;z++) {
    	.if(z>127) {
    		.byte round(d / (z0 - ((z - 256) / 64.0)));
    	} else {
    		.byte round(d / (z0 - (z / 64.0)));
    	}
    }
	}

.pc = SINH "SINH"
  {
    .var min = -$2000
    .var max = $2000
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte round((min+(ampl/2)+(ampl/2)*sin(rad))/256)
    }
    }

.pc = SINQ "SINQ"
  {
    .var min = -$1000
    .var max = $1000
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte round((min+(ampl/2)+(ampl/2)*sin(rad))/256)
    }
    }

.pc = SINH_LO "SINH_LO"
  {
    .var min = -$2000
    .var max = $2000
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte <(min+(ampl/2)+(ampl/2)*sin(rad))
    }
    }

.pc = SINH_HI "SINH_HI"
  {
    .var min = -$2000
    .var max = $2000
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte >(min+(ampl/2)+(ampl/2)*sin(rad))
    }
    }

.pc = SINQ_LO "SINQ_LO"
  {
    .var min = -$1000
    .var max = $1000
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte <(min+(ampl/2)+(ampl/2)*sin(rad))
    }
    }

.pc = SINQ_HI "SINQ_HI"
  {
    .var min = -$1000
    .var max = $1000
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte >(min+(ampl/2)+(ampl/2)*sin(rad))
    }
    }

