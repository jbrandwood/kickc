.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label RASTER = $d012
  .label SPRITES_ENABLE = $d015
  .label BORDERCOL = $d020
  .label SPRITES_COLS = $d027
  .const LIGHT_BLUE = $e
  .const LIGHT_GREY = $f
  .label print_screen = $400
  .label xr = $f0
  .label yr = $f1
  .label zr = $f2
  .label pp = $f3
  .label xp = $f4
  .label yp = $f5
  .label psp1 = $f6
  .label psp2 = $f8
  .label SCREEN = $400
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
  .label COSH_LO = SINH_LO+$40
  .label COSH_HI = SINH_HI+$40
  .label COSQ_HI = SINQ_HI+$40
  .label sx = 2
  .label sy = 3
  .label sz = 4
  jsr main
main: {
    sei
    jsr sprites_init
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
    .label i = 5
    lda #0
    sta sz
    sta sy
    sta sx
  b4:
    lda RASTER
    cmp #$ff
    bne b4
    inc BORDERCOL
    ldx sz
    jsr calculate_matrix_16
    jsr store_matrix
    lda #0
    sta i
  b7:
    inc BORDERCOL
    ldy i
    lda xs,y
    sta rotate_matrix.x
    ldx i
    ldy ys,x
    lda zs,x
    tax
    jsr rotate_matrix
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
    adc xr
    sta SPRITES_XPOS,x
    lda #$80
    clc
    adc yr
    sta SPRITES_YPOS,x
    inc i
    lda i
    cmp #8
    bne b7
    lda #LIGHT_GREY
    sta BORDERCOL
    jsr debug_print
    lda #LIGHT_BLUE
    sta BORDERCOL
    dec sx
    inc sy
    dec sz
    jmp b4
}
debug_print: {
    .label at_line = SCREEN+$13*$28
    .label c = 5
    .label i = 6
    ldx sx
    lda #<SCREEN+$25
    sta print_sbyte_at.at
    lda #>SCREEN+$25
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx sy
    lda #<SCREEN+$28*1+$25
    sta print_sbyte_at.at
    lda #>SCREEN+$28*1+$25
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx sz
    lda #<SCREEN+$28*2+$25
    sta print_sbyte_at.at
    lda #>SCREEN+$28*2+$25
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix
    lda #<SCREEN+$28*4+$1d
    sta print_sbyte_at.at
    lda #>SCREEN+$28*4+$1d
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+1
    lda #<SCREEN+$28*4+$21
    sta print_sbyte_at.at
    lda #>SCREEN+$28*4+$21
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+2
    lda #<SCREEN+$28*4+$25
    sta print_sbyte_at.at
    lda #>SCREEN+$28*4+$25
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+3
    lda #<SCREEN+$28*5+$1d
    sta print_sbyte_at.at
    lda #>SCREEN+$28*5+$1d
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+4
    lda #<SCREEN+$28*5+$21
    sta print_sbyte_at.at
    lda #>SCREEN+$28*5+$21
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+5
    lda #<SCREEN+$28*5+$25
    sta print_sbyte_at.at
    lda #>SCREEN+$28*5+$25
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+6
    lda #<SCREEN+$28*6+$1d
    sta print_sbyte_at.at
    lda #>SCREEN+$28*6+$1d
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+7
    lda #<SCREEN+$28*6+$21
    sta print_sbyte_at.at
    lda #>SCREEN+$28*6+$21
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+8
    lda #<SCREEN+$28*6+$25
    sta print_sbyte_at.at
    lda #>SCREEN+$28*6+$25
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
print_sbyte_at: {
    .label at = 7
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
print_char_at: {
    .label at = 7
    .label ch = 9
    lda ch
    ldy #0
    sta (at),y
    rts
}
print_byte_at: {
    .label at = 7
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
rotate_matrix: {
    .label x = 6
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
calculate_matrix_16: {
    .label _4 = 7
    .label _9 = 7
    .label _13 = 7
    .label _28 = $16
    .label _29 = $16
    .label _30 = $16
    .label _31 = $16
    .label _32 = $16
    .label _35 = 7
    .label _36 = $10
    .label _37 = $e
    .label _38 = $12
    .label _39 = $14
    .label _48 = $16
    .label _49 = $16
    .label _50 = $16
    .label _51 = $16
    .label _52 = $16
    .label _55 = 7
    .label _56 = $10
    .label _57 = $e
    .label _58 = $12
    .label _59 = $14
    .label _66 = 7
    .label _71 = 7
    .label sx = 2
    .label sy = 3
    .label t1 = 5
    .label t2 = 6
    .label t3 = 9
    .label t5 = $c
    .label t6 = $d
    .label t7 = 5
    .label t8 = 6
    .label _74 = 7
    .label _75 = $a
    .label _76 = 7
    .label _77 = $a
    .label _78 = 7
    .label _79 = 7
    .label _80 = $a
    .label _81 = $e
    .label _82 = $10
    .label _83 = $12
    .label _84 = $14
    .label _85 = 7
    .label _86 = $a
    .label _87 = $e
    .label _88 = $10
    .label _89 = $12
    .label _90 = $14
    .label _91 = 7
    .label _92 = $a
    .label _93 = 7
    .label _94 = $a
    txa
    eor #$ff
    sec
    adc sy
    sta t1
    txa
    clc
    adc sy
    sta t2
    ldy t1
    lda COSH_HI,y
    sta _74+1
    lda COSH_LO,y
    sta _74
    ldy t2
    lda COSH_HI,y
    sta _75+1
    lda COSH_LO,y
    sta _75
    lda _4
    clc
    adc _75
    sta _4
    lda _4+1
    adc _75+1
    sta _4+1
    sta rotation_matrix
    ldy t1
    lda SINH_HI,y
    sta _76+1
    lda SINH_LO,y
    sta _76
    ldy t2
    lda SINH_HI,y
    sta _77+1
    lda SINH_LO,y
    sta _77
    lda _9
    sec
    sbc _77
    sta _9
    lda _9+1
    sbc _77+1
    sta _9+1
    sta rotation_matrix+1
    ldy sy
    lda SINH_HI,y
    sta _78+1
    lda SINH_LO,y
    sta _78
    lda _13
    clc
    adc _13
    sta _13
    lda _13+1
    adc _13+1
    sta _13+1
    sta rotation_matrix+2
    txa
    clc
    adc sx
    sta t3
    txa
    eor #$ff
    sec
    adc sx
    tax
    lda sx
    clc
    adc t2
    sta t5
    lda sx
    sec
    sbc t1
    sta t6
    lda t7
    clc
    adc sx
    sta t7
    lda t8
    sec
    sbc sx
    sta t8
    ldy t3
    lda SINH_HI,y
    sta _79+1
    lda SINH_LO,y
    sta _79
    lda SINH_HI,x
    sta _80+1
    lda SINH_LO,x
    sta _80
    ldy t5
    lda COSQ_HI,y
    sta _81+1
    lda COSH_LO,y
    sta _81
    ldy t6
    lda COSQ_HI,y
    sta _82+1
    lda COSH_LO,y
    sta _82
    ldy t7
    lda COSQ_HI,y
    sta _83+1
    lda COSH_LO,y
    sta _83
    ldy t8
    lda COSQ_HI,y
    sta _84+1
    lda COSH_LO,y
    sta _84
    lda _79
    sec
    sbc _80
    sta _28
    lda _79+1
    sbc _80+1
    sta _28+1
    lda _29
    clc
    adc _82
    sta _29
    lda _29+1
    adc _82+1
    sta _29+1
    lda _30
    sec
    sbc _81
    sta _30
    lda _30+1
    sbc _81+1
    sta _30+1
    lda _31
    clc
    adc _84
    sta _31
    lda _31+1
    adc _84+1
    sta _31+1
    lda _32
    sec
    sbc _83
    sta _32
    lda _32+1
    sbc _83+1
    sta _32+1
    sta rotation_matrix+3
    lda _35
    clc
    adc _80
    sta _35
    lda _35+1
    adc _80+1
    sta _35+1
    lda _36
    clc
    adc _35
    sta _36
    lda _36+1
    adc _35+1
    sta _36+1
    lda _36
    sec
    sbc _37
    sta _37
    lda _36+1
    sbc _37+1
    sta _37+1
    lda _38
    clc
    adc _37
    sta _38
    lda _38+1
    adc _37+1
    sta _38+1
    lda _38
    sec
    sbc _39
    sta _39
    lda _38+1
    sbc _39+1
    sta _39+1
    sta rotation_matrix+7
    ldy t3
    lda COSH_HI,y
    sta _85+1
    lda COSH_LO,y
    sta _85
    lda COSH_HI,x
    sta _86+1
    lda COSH_LO,x
    sta _86
    ldy t5
    lda SINQ_HI,y
    sta _87+1
    lda SINH_LO,y
    sta _87
    ldy t6
    lda SINQ_HI,y
    sta _88+1
    lda SINH_LO,y
    sta _88
    ldy t7
    lda SINQ_HI,y
    sta _89+1
    lda SINH_LO,y
    sta _89
    ldy t8
    lda SINQ_HI,y
    sta _90+1
    lda SINH_LO,y
    sta _90
    lda _85
    clc
    adc _86
    sta _48
    lda _85+1
    adc _86+1
    sta _48+1
    lda _49
    clc
    adc _87
    sta _49
    lda _49+1
    adc _87+1
    sta _49+1
    lda _50
    sec
    sbc _88
    sta _50
    lda _50+1
    sbc _88+1
    sta _50+1
    lda _51
    sec
    sbc _89
    sta _51
    lda _51+1
    sbc _89+1
    sta _51+1
    lda _52
    sec
    sbc _90
    sta _52
    lda _52+1
    sbc _90+1
    sta _52+1
    sta rotation_matrix+4
    lda _86
    sec
    sbc _55
    sta _55
    lda _86+1
    sbc _55+1
    sta _55+1
    lda _56
    clc
    adc _55
    sta _56
    lda _56+1
    adc _55+1
    sta _56+1
    lda _56
    sec
    sbc _57
    sta _57
    lda _56+1
    sbc _57+1
    sta _57+1
    lda _57
    sec
    sbc _58
    sta _58
    lda _57+1
    sbc _58+1
    sta _58+1
    lda _58
    sec
    sbc _59
    sta _59
    lda _58+1
    sbc _59+1
    sta _59+1
    sta rotation_matrix+6
    lda sy
    sec
    sbc sx
    tax
    lda sy
    clc
    adc sx
    tay
    lda SINH_HI,x
    sta _91+1
    lda SINH_LO,x
    sta _91
    lda SINH_HI,y
    sta _92+1
    lda SINH_LO,y
    sta _92
    lda _66
    sec
    sbc _92
    sta _66
    lda _66+1
    sbc _92+1
    sta _66+1
    sta rotation_matrix+5
    lda COSH_HI,x
    sta _93+1
    lda COSH_LO,x
    sta _93
    lda COSH_HI,y
    sta _94+1
    lda COSH_LO,y
    sta _94
    lda _71
    clc
    adc _94
    sta _71
    lda _71+1
    adc _94+1
    sta _71+1
    sta rotation_matrix+8
    rts
}
debug_print_init: {
    .label COLS = $d800
    .label at_line = SCREEN+$10*$28
    .label at_cols = COLS+$10*$28
    .label _59 = 7
    .label _60 = 7
    .label _63 = 7
    .label _64 = 7
    .label _67 = 7
    .label _68 = 7
    .label _71 = 7
    .label _72 = 7
    .label _75 = 7
    .label _76 = 7
    .label _79 = 7
    .label _80 = 7
    .label _83 = 7
    .label _84 = 7
    .label _87 = 7
    .label _88 = 7
    .label _91 = 7
    .label _92 = 7
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
print_str_at: {
    .label at = $a
    .label str = 7
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
print_cls: {
    .label sc = 7
    lda #<print_screen
    sta sc
    lda #>print_screen
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
    cmp #>print_screen+$3e8
    bne b1
    lda sc
    cmp #<print_screen+$3e8
    bne b1
    rts
}
sprites_init: {
    .label SCREEN = $400
    .label sprites_ptr = SCREEN+$3f8
    lda #$ff
    sta SPRITES_ENABLE
    ldx #0
  b1:
    lda #$ff&SPRITE/$40
    sta sprites_ptr,x
    txa
    clc
    adc #8
    sta SPRITES_COLS,x
    inx
    cpx #8
    bne b1
    rts
}
  print_hextab: .text "0123456789abcdef"
  xrs: .fill 8, 0
  yrs: .fill 8, 0
  zrs: .fill 8, 0
  pps: .fill 8, 0
  xps: .fill 8, 0
  yps: .fill 8, 0
  rotation_matrix: .fill 9, 0
  xs: .byte -$5f, $5f, 0, 0, 0, 0, 0, $3f
  ys: .byte 0, 0, -$5f, $5f, 0, 0, 0, 0
  zs: .byte 0, 0, 0, 0, -$5f, $5f, -0, 0
.pc = mulf_sqr1 "Inline"
  .for(var i=0;i<$200;i++) {
    	.if(i<=159) { .byte round((i*i)/256) }
    	.if(i>159 && i<=351 ) { .byte round(((i-256)*(i-256))/256) }
    	.if(i>351) { .byte round(((512-i)*(512-i))/256) }
    }

.pc = mulf_sqr2 "Inline"
  .for(var i=0;i<$200;i++) {
    	.if(i<=159) { .byte round((-i-1)*(-i-1)/256) }
    	.if(i>159 && i<=351 ) { .byte round(((255-i)*(255-i))/256) }
    	.if(i>351) { .byte round(((i-511)*(i-511))/256) }  
    }

.pc = SPRITE "Inline"
  .var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)

.pc = PERSP_Z "Inline"
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

.pc = SINH "Inline"
  {
    .var min = -$2000
    .var max = $2000
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte round((min+(ampl/2)+(ampl/2)*sin(rad))/256)
    }
    }

.pc = SINQ "Inline"
  {
    .var min = -$1000
    .var max = $1000
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte round((min+(ampl/2)+(ampl/2)*sin(rad))/256)
    }
    }

.pc = SINH_LO "Inline"
  {
    .var min = -$2000
    .var max = $2000
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte <(min+(ampl/2)+(ampl/2)*sin(rad))
    }
    }

.pc = SINH_HI "Inline"
  {
    .var min = -$2000
    .var max = $2000
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte >(min+(ampl/2)+(ampl/2)*sin(rad))
    }
    }

.pc = SINQ_LO "Inline"
  {
    .var min = -$1000
    .var max = $1000
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte <(min+(ampl/2)+(ampl/2)*sin(rad))
    }
    }

.pc = SINQ_HI "Inline"
  {
    .var min = -$1000
    .var max = $1000
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte >(min+(ampl/2)+(ampl/2)*sin(rad))
    }
    }

