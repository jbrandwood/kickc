// 3D Rotation using a Rotation Matrix
// Based on: 
// - C= Hacking Magazine Issue 8. http://www.ffd2.com/fridge/chacking/c=hacking8.txt
// - Codebase64 Article http://codebase64.org/doku.php?id=base:3d_rotation  
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
  .label print_screen = $400
  // The rotated point - updated by calling rotate_matrix()
  .label xr = $f0
  .label yr = $f1
  .label zr = $f2
  // The rotated point with perspective
  .label pp = $f3
  .label xp = $f4
  .label yp = $f5
  // Pointers used to multiply perspective (d/z0-z) onto x- & y-coordinates. Points into mulf_sqr1 / mulf_sqr2  
  .label psp1 = $f6
  .label psp2 = $f8
  .label SCREEN = $400
  .const sz = 0
  // A single sprite
  .label SPRITE = $3000
  .label COSH = SINH+$40
  .label COSQ = SINQ+$40
  .label sx = 2
  .label sy = 3
main: {
    sei
    jsr sprites_init
    //mulf_init();
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
    sta sy
    sta sx
  //signed byte xmin = 0;
  //signed byte xmax = 0;
  b2:
    lda #$ff
    cmp RASTER
    bne b2
  b3:
    lda #$fe
    cmp RASTER
    bne b3
  b4:
    lda #$fd
    cmp RASTER
    bne b4
    inc BORDERCOL
    ldx sx
    jsr calculate_matrix
    jsr store_matrix
    lda #0
    sta i
  b6:
    inc BORDERCOL
    ldy i
    ldx xs,y
    lda ys,y
    sta rotate_matrix.y
    lda zs,y
    sta rotate_matrix.z
    jsr rotate_matrix
    //if(*xr<xmin) xmin = *xr;
    //if(*xr>xmax) xmax = *xr;
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
    lda #8
    cmp i
    bne b6
    lda #LIGHT_GREY
    sta BORDERCOL
    jsr debug_print
    lda #LIGHT_BLUE
    sta BORDERCOL
    // Increment angles        
    inc sx
    inc sx
    lax sy
    axs #3
    stx sy
    jmp b2
}
debug_print: {
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
    .label c = 5
    .label i = 6
    ldx sx
    lda #<print_screen+print_sbyte_pos1_col
    sta print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos1_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx sy
    lda #<print_screen+print_sbyte_pos2_row*$28+print_sbyte_pos2_col
    sta print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos2_row*$28+print_sbyte_pos2_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    lda #<print_screen+print_sbyte_pos3_row*$28+print_sbyte_pos3_col
    sta print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos3_row*$28+print_sbyte_pos3_col
    sta print_sbyte_at.at+1
    ldx #sz
    jsr print_sbyte_at
    ldx rotation_matrix
    lda #<print_screen+print_sbyte_pos4_row*$28+print_sbyte_pos4_col
    sta print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos4_row*$28+print_sbyte_pos4_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+1
    lda #<print_screen+print_sbyte_pos5_row*$28+print_sbyte_pos5_col
    sta print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos5_row*$28+print_sbyte_pos5_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+2
    lda #<print_screen+print_sbyte_pos6_row*$28+print_sbyte_pos6_col
    sta print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos6_row*$28+print_sbyte_pos6_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+3
    lda #<print_screen+print_sbyte_pos7_row*$28+print_sbyte_pos7_col
    sta print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos7_row*$28+print_sbyte_pos7_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+4
    lda #<print_screen+print_sbyte_pos8_row*$28+print_sbyte_pos8_col
    sta print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos8_row*$28+print_sbyte_pos8_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+5
    lda #<print_screen+print_sbyte_pos9_row*$28+print_sbyte_pos9_col
    sta print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos9_row*$28+print_sbyte_pos9_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+6
    lda #<print_screen+print_sbyte_pos10_row*$28+print_sbyte_pos10_col
    sta print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos10_row*$28+print_sbyte_pos10_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+7
    lda #<print_screen+print_sbyte_pos11_row*$28+print_sbyte_pos11_col
    sta print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos11_row*$28+print_sbyte_pos11_col
    sta print_sbyte_at.at+1
    jsr print_sbyte_at
    ldx rotation_matrix+8
    lda #<print_screen+print_sbyte_pos12_row*$28+print_sbyte_pos12_col
    sta print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos12_row*$28+print_sbyte_pos12_col
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
    ldy i
    ldx xrs,y
    jsr print_sbyte_at
    lda c
    clc
    adc #<at_line+$28*1
    sta print_sbyte_at.at
    lda #>at_line+$28*1
    adc #0
    sta print_sbyte_at.at+1
    ldy i
    ldx yrs,y
    jsr print_sbyte_at
    lda c
    clc
    adc #<at_line+$28*2
    sta print_sbyte_at.at
    lda #>at_line+$28*2
    adc #0
    sta print_sbyte_at.at+1
    ldy i
    ldx zrs,y
    jsr print_sbyte_at
    lda c
    clc
    adc #<at_line+$28*3
    sta print_sbyte_at.at
    lda #>at_line+$28*3
    adc #0
    sta print_sbyte_at.at+1
    ldy i
    ldx pps,y
    jsr print_sbyte_at
    lda c
    clc
    adc #<at_line+$28*4
    sta print_sbyte_at.at
    lda #>at_line+$28*4
    adc #0
    sta print_sbyte_at.at+1
    ldy i
    ldx xps,y
    jsr print_sbyte_at
    lda c
    clc
    adc #<at_line+$28*5
    sta print_sbyte_at.at
    lda #>at_line+$28*5
    adc #0
    sta print_sbyte_at.at+1
    ldy i
    ldx yps,y
    jsr print_sbyte_at
    lax c
    axs #-[4]
    stx c
    inc i
    lda #8
    cmp i
    beq !b1+
    jmp b1
  !b1:
    rts
}
// Print a signed byte as hex at a specific screen position
// print_sbyte_at(signed byte register(X) b, byte* zeropage($d) at)
print_sbyte_at: {
    .label at = $d
    cpx #0
    bmi b1
    ldy #' '
    jsr print_char_at
  b2:
    inc print_byte_at.at
    bne !+
    inc print_byte_at.at+1
  !:
    jsr print_byte_at
    rts
  b1:
    ldy #'-'
    jsr print_char_at
    txa
    eor #$ff
    clc
    adc #1
    tax
    jmp b2
}
// Print a single char
// print_char_at(byte register(Y) ch, byte* zeropage($d) at)
print_char_at: {
    .label at = $d
    tya
    ldy #0
    sta (at),y
    rts
}
// Print a byte as HEX at a specific position
// print_byte_at(byte register(X) b, byte* zeropage($d) at)
print_byte_at: {
    .label at = $d
    txa
    lsr
    lsr
    lsr
    lsr
    tay
    lda print_hextab,y
    tay
    jsr print_char_at
    lda #$f
    axs #0
    inc print_char_at.at
    bne !+
    inc print_char_at.at+1
  !:
    ldy print_hextab,x
    jsr print_char_at
    rts
}
// Rotate a 3D point (x,y,z) using the rotation matrix
// The rotation matrix is prepared by calling prepare_matrix() 
// The passed points must be in the interval [-$3f;$3f].
// Implemented in assembler to utilize seriously fast multiplication 
// rotate_matrix(signed byte register(X) x, signed byte zeropage(6) y, signed byte zeropage(4) z)
rotate_matrix: {
    .label y = 6
    .label z = 4
    txa
    sta xr
    lda y
    sta yr
    lda z
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
// Store the rotation matrix into the rotation routine rotate()
// After this each call to rotate() will rotate a point with the matrix
// Implemented in assembler to utilize seriously fast multiplication 
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
// Prepare the 3x3 rotation matrix into rotation_matrix[]
// Angles sx, sy, sz are based on 2*PI=$100 
// Method described in C= Hacking Magazine Issue 8. http://www.ffd2.com/fridge/chacking/c=hacking8.txt
// calculate_matrix(signed byte register(X) sx, signed byte zeropage(3) sy)
calculate_matrix: {
    .label sy = 3
    .label t1 = 4
    .label t2 = 5
    .label t3 = 6
    .label t4 = 7
    .label t5 = 8
    .label t6 = 9
    .label t7 = $a
    .label t8 = $b
    .label t9 = $c
    lda sy
    sta t1
    lda sy
    sta t2
    stx t3
    stx t4
    txa
    clc
    adc t2
    sta t5
    txa
    sec
    sbc t1
    sta t6
    txa
    clc
    adc t1
    sta t7
    txa
    eor #$ff
    sec
    adc t2
    sta t8
    txa
    eor #$ff
    sec
    adc sy
    sta t9
    txa
    clc
    adc sy
    tax
    ldy t1
    lda COSH,y
    ldy t2
    clc
    adc COSH,y
    sta rotation_matrix
    ldy t1
    lda SINH,y
    ldy t2
    sec
    sbc SINH,y
    sta rotation_matrix+1
    ldy sy
    clc
    lda SINH,y
    adc SINH,y
    sta rotation_matrix+2
    ldy t3
    lda SINH,y
    ldy t4
    sec
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
    ldy t3
    lda COSH,y
    ldy t4
    clc
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
    ldy t9
    lda SINH,y
    sec
    sbc SINH,x
    sta rotation_matrix+5
    ldy t4
    lda COSH,y
    ldy t3
    sec
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
    ldy t3
    lda SINH,y
    ldy t4
    clc
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
    lda COSH,x
    ldy t9
    clc
    adc COSH,y
    sta rotation_matrix+8
    rts
}
debug_print_init: {
    .label COLS = $d800
    .label at_line = SCREEN+$10*$28
    .label at_cols = COLS+$10*$28
    .label _41 = $d
    .label _44 = $f
    .label _47 = $11
    .label _50 = $13
    .label _53 = $15
    .label _56 = $17
    .label _59 = $19
    .label _62 = $1b
    .label _65 = $1d
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
    ldy i
    ldx xs,y
    jsr print_sbyte_at
    lda c
    clc
    adc #<at_line+$28*1
    sta print_sbyte_at.at
    lda #>at_line+$28*1
    adc #0
    sta print_sbyte_at.at+1
    ldy i
    ldx ys,y
    jsr print_sbyte_at
    lda c
    clc
    adc #<at_line+$28*2
    sta print_sbyte_at.at
    lda #>at_line+$28*2
    adc #0
    sta print_sbyte_at.at+1
    ldy i
    ldx zs,y
    jsr print_sbyte_at
    ldy #0
  b2:
    lax i
    axs #-[8]
    lda c
    clc
    adc #<at_cols
    sta _41
    lda #>at_cols
    adc #0
    sta _41+1
    txa
    sta (_41),y
    lda c
    clc
    adc #<at_cols+$28*1
    sta _44
    lda #>at_cols+$28*1
    adc #0
    sta _44+1
    txa
    sta (_44),y
    lda c
    clc
    adc #<at_cols+$28*2
    sta _47
    lda #>at_cols+$28*2
    adc #0
    sta _47+1
    txa
    sta (_47),y
    lda c
    clc
    adc #<at_cols+$28*3
    sta _50
    lda #>at_cols+$28*3
    adc #0
    sta _50+1
    txa
    sta (_50),y
    lda c
    clc
    adc #<at_cols+$28*4
    sta _53
    lda #>at_cols+$28*4
    adc #0
    sta _53+1
    txa
    sta (_53),y
    lda c
    clc
    adc #<at_cols+$28*5
    sta _56
    lda #>at_cols+$28*5
    adc #0
    sta _56+1
    txa
    sta (_56),y
    lda c
    clc
    adc #<at_cols+$28*6
    sta _59
    lda #>at_cols+$28*6
    adc #0
    sta _59+1
    txa
    sta (_59),y
    lda c
    clc
    adc #<at_cols+$28*7
    sta _62
    lda #>at_cols+$28*7
    adc #0
    sta _62+1
    txa
    sta (_62),y
    lda c
    clc
    adc #<at_cols+$28*8
    sta _65
    lda #>at_cols+$28*8
    adc #0
    sta _65+1
    txa
    sta (_65),y
    iny
    cpy #4
    beq !b2+
    jmp b2
  !b2:
    lax c
    axs #-[4]
    stx c
    inc i
    lda #8
    cmp i
    beq !b1+
    jmp b1
  !b1:
    rts
    str: .text "sx"
    .byte 0
    str1: .text "sy"
    .byte 0
    str2: .text "sz"
    .byte 0
    str3: .text "x"
    .byte 0
    str4: .text "y"
    .byte 0
    str5: .text "z"
    .byte 0
    str6: .text "xr"
    .byte 0
    str7: .text "yr"
    .byte 0
    str8: .text "zr"
    .byte 0
    str9: .text "pp"
    .byte 0
    str10: .text "xp"
    .byte 0
    str11: .text "yp"
    .byte 0
}
// Print a string at a specific screen position
// print_str_at(byte* zeropage($d) str, byte* zeropage($f) at)
print_str_at: {
    .label at = $f
    .label str = $d
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
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    jsr memset
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = print_screen
    .label end = str+num
    .label dst = $f
    lda #<str
    sta dst
    lda #>str
    sta dst+1
  b2:
    lda #c
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    lda dst+1
    cmp #>end
    bne b2
    lda dst
    cmp #<end
    bne b2
    rts
}
// Initialize sprites
sprites_init: {
    .label SCREEN = $400
    .label sprites_ptr = SCREEN+$3f8
    lda #$ff
    sta SPRITES_ENABLE
    ldx #0
  b1:
    lda #SPRITE/$40
    sta sprites_ptr,x
    lda #GREEN
    sta SPRITES_COLS,x
    inx
    cpx #8
    bne b1
    rts
}
  print_hextab: .text "0123456789abcdef"
  // Positions to rotate
  xs: .byte -$34, -$34, -$34, 0, 0, $34, $34, $34
  ys: .byte -$34, 0, $34, -$34, $34, -$34, 0, $34
  zs: .byte $34, $34, $34, $34, $34, $34, $34, $34
  // Rotated positions
  xrs: .fill 8, 0
  yrs: .fill 8, 0
  zrs: .fill 8, 0
  // Persepctive factors (from zrs)
  pps: .fill 8, 0
  // Rotated positions with persepctive
  xps: .fill 8, 0
  yps: .fill 8, 0
  // The rotation matrix
  rotation_matrix: .fill 9, 0
  // mulf_sqr tables will contain f(x)=int(x*x) and g(x) = f(1-x).
  // f(x) = >(( x * x ))
  .align $100
mulf_sqr1:
.for(var i=0;i<$200;i++) {
    	.if(i<=159) { .byte round((i*i)/256) }
    	.if(i>159 && i<=351 ) { .byte round(((i-256)*(i-256))/256) }
    	.if(i>351) { .byte round(((512-i)*(512-i))/256) }
    }

  // g(x) =  >((( 1 - x ) * ( 1 - x )))
  .align $100
mulf_sqr2:
.for(var i=0;i<$200;i++) {
    	.if(i<=159) { .byte round((-i-1)*(-i-1)/256) }
    	.if(i>159 && i<=351 ) { .byte round(((255-i)*(255-i))/256) }
    	.if(i>351) { .byte round(((i-511)*(i-511))/256) }  
    }

  // Perspective multiplication table containing (d/(z0-z)[z] for each z-value   
  .align $100
PERSP_Z:
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

  // Sine and Cosine Tables   
  // Angles: $00=0, $80=PI,$100=2*PI
  // Half Sine/Cosine: signed fixed [-$20;20]
  .align $40
SINH:
{
    .var min = -$2000
    .var max = $2000
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte round((min+(ampl/2)+(ampl/2)*sin(rad))/256)
    }
    }

  // Quarter Sine/Cosine: signed fixed [-$10,$10]
  .align $40
SINQ:
{
    .var min = -$1000
    .var max = $1000
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte round((min+(ampl/2)+(ampl/2)*sin(rad))/256)
    }
    }

.pc = SPRITE "SPRITE"
  .var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)

