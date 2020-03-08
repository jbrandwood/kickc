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
  .label print_screen = $400
  .label sx = 2
  .label sy = 3
  // kickasm
main: {
    // asm
    sei
    // sprites_init()
    jsr sprites_init
    // *psp1 = (word)mulf_sqr1
    //mulf_init();
    lda #<mulf_sqr1
    sta psp1
    lda #>mulf_sqr1
    sta psp1+1
    // *psp2 = (word)mulf_sqr2
    lda #<mulf_sqr2
    sta psp2
    lda #>mulf_sqr2
    sta psp2+1
    // debug_print_init()
    jsr debug_print_init
    // anim()
  //calculate_matrix(1,1,1);
    jsr anim
    // }
    rts
}
anim: {
    .label i = 4
    lda #0
    sta.z sy
    sta.z sx
  //signed byte xmin = 0;
  //signed byte xmax = 0;
  __b2:
    // while(*RASTER!=$ff)
    lda #$ff
    cmp RASTER
    bne __b2
  __b3:
    // while(*RASTER!=$fe)
    lda #$fe
    cmp RASTER
    bne __b3
  __b4:
    // while(*RASTER!=$fd)
    lda #$fd
    cmp RASTER
    bne __b4
    // (*BORDERCOL)++;
    inc BORDERCOL
    // calculate_matrix(sx,sy,sz)
    ldx.z sx
    //calculate_matrix_16(sx,sy,sz);
    jsr calculate_matrix
    // store_matrix()
    jsr store_matrix
    lda #0
    sta.z i
  __b6:
    // (*BORDERCOL)++;
    inc BORDERCOL
    // rotate_matrix(xs[i], ys[i], zs[i])
    ldy.z i
    ldx xs,y
    lda ys,y
    sta.z rotate_matrix.y
    lda zs,y
    sta.z rotate_matrix.z
    jsr rotate_matrix
    // xrs[i] = *xr
    //if(*xr<xmin) xmin = *xr;
    //if(*xr>xmax) xmax = *xr;
    lda xr
    ldy.z i
    sta xrs,y
    // yrs[i] = *yr
    lda yr
    sta yrs,y
    // zrs[i] = *zr
    lda zr
    sta zrs,y
    // pps[i] = *pp
    lda pp
    sta pps,y
    // xps[i] = *xp
    lda xp
    sta xps,y
    // yps[i] = *yp
    lda yp
    sta yps,y
    // i2 = i*2
    tya
    asl
    tax
    // $80+(byte)((*xp))
    lda #$80
    clc
    adc xp
    // SPRITES_XPOS[i2] = $80+(byte)((*xp))
    sta SPRITES_XPOS,x
    // $80+(byte)((*yp))
    lda #$80
    clc
    adc yp
    // SPRITES_YPOS[i2] = $80+(byte)((*yp))
    sta SPRITES_YPOS,x
    // for(byte i: 0..7)
    inc.z i
    lda #8
    cmp.z i
    bne __b6
    // *BORDERCOL = LIGHT_GREY
    lda #LIGHT_GREY
    sta BORDERCOL
    // debug_print()
    jsr debug_print
    // *BORDERCOL = LIGHT_BLUE
    lda #LIGHT_BLUE
    sta BORDERCOL
    // sx +=2
    // Increment angles        
    inc.z sx
    inc.z sx
    // sy -=3
    lax.z sy
    axs #3
    stx.z sy
    jmp __b2
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
    // print_sbyte_pos(sx, 0, 37)
    ldx.z sx
    // print_sbyte_at(sb, print_screen+row*40+col)
    lda #<print_screen+print_sbyte_pos1_col
    sta.z print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos1_col
    sta.z print_sbyte_at.at+1
    jsr print_sbyte_at
    // print_sbyte_pos(sy, 1, 37)
    ldx.z sy
    // print_sbyte_at(sb, print_screen+row*40+col)
    lda #<print_screen+print_sbyte_pos2_row*$28+print_sbyte_pos2_col
    sta.z print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos2_row*$28+print_sbyte_pos2_col
    sta.z print_sbyte_at.at+1
    jsr print_sbyte_at
    // print_sbyte_at(sb, print_screen+row*40+col)
    lda #<print_screen+print_sbyte_pos3_row*$28+print_sbyte_pos3_col
    sta.z print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos3_row*$28+print_sbyte_pos3_col
    sta.z print_sbyte_at.at+1
    ldx #sz
    jsr print_sbyte_at
    // print_sbyte_pos(rotation_matrix[0], 4, 29)
    ldx rotation_matrix
    // print_sbyte_at(sb, print_screen+row*40+col)
    lda #<print_screen+print_sbyte_pos4_row*$28+print_sbyte_pos4_col
    sta.z print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos4_row*$28+print_sbyte_pos4_col
    sta.z print_sbyte_at.at+1
    jsr print_sbyte_at
    // print_sbyte_pos(rotation_matrix[1], 4, 33)
    ldx rotation_matrix+1
    // print_sbyte_at(sb, print_screen+row*40+col)
    lda #<print_screen+print_sbyte_pos5_row*$28+print_sbyte_pos5_col
    sta.z print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos5_row*$28+print_sbyte_pos5_col
    sta.z print_sbyte_at.at+1
    jsr print_sbyte_at
    // print_sbyte_pos(rotation_matrix[2], 4, 37)
    ldx rotation_matrix+2
    // print_sbyte_at(sb, print_screen+row*40+col)
    lda #<print_screen+print_sbyte_pos6_row*$28+print_sbyte_pos6_col
    sta.z print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos6_row*$28+print_sbyte_pos6_col
    sta.z print_sbyte_at.at+1
    jsr print_sbyte_at
    // print_sbyte_pos(rotation_matrix[3], 5, 29)
    ldx rotation_matrix+3
    // print_sbyte_at(sb, print_screen+row*40+col)
    lda #<print_screen+print_sbyte_pos7_row*$28+print_sbyte_pos7_col
    sta.z print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos7_row*$28+print_sbyte_pos7_col
    sta.z print_sbyte_at.at+1
    jsr print_sbyte_at
    // print_sbyte_pos(rotation_matrix[4], 5, 33)
    ldx rotation_matrix+4
    // print_sbyte_at(sb, print_screen+row*40+col)
    lda #<print_screen+print_sbyte_pos8_row*$28+print_sbyte_pos8_col
    sta.z print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos8_row*$28+print_sbyte_pos8_col
    sta.z print_sbyte_at.at+1
    jsr print_sbyte_at
    // print_sbyte_pos(rotation_matrix[5], 5, 37)
    ldx rotation_matrix+5
    // print_sbyte_at(sb, print_screen+row*40+col)
    lda #<print_screen+print_sbyte_pos9_row*$28+print_sbyte_pos9_col
    sta.z print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos9_row*$28+print_sbyte_pos9_col
    sta.z print_sbyte_at.at+1
    jsr print_sbyte_at
    // print_sbyte_pos(rotation_matrix[6], 6, 29)
    ldx rotation_matrix+6
    // print_sbyte_at(sb, print_screen+row*40+col)
    lda #<print_screen+print_sbyte_pos10_row*$28+print_sbyte_pos10_col
    sta.z print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos10_row*$28+print_sbyte_pos10_col
    sta.z print_sbyte_at.at+1
    jsr print_sbyte_at
    // print_sbyte_pos(rotation_matrix[7], 6, 33)
    ldx rotation_matrix+7
    // print_sbyte_at(sb, print_screen+row*40+col)
    lda #<print_screen+print_sbyte_pos11_row*$28+print_sbyte_pos11_col
    sta.z print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos11_row*$28+print_sbyte_pos11_col
    sta.z print_sbyte_at.at+1
    jsr print_sbyte_at
    // print_sbyte_pos(rotation_matrix[8], 6, 37)
    ldx rotation_matrix+8
    // print_sbyte_at(sb, print_screen+row*40+col)
    lda #<print_screen+print_sbyte_pos12_row*$28+print_sbyte_pos12_col
    sta.z print_sbyte_at.at
    lda #>print_screen+print_sbyte_pos12_row*$28+print_sbyte_pos12_col
    sta.z print_sbyte_at.at+1
    jsr print_sbyte_at
    lda #0
    sta.z i
    lda #4
    sta.z c
  __b1:
    // print_sbyte_at(xrs[i], at_line+40*0+c)
    lda.z c
    clc
    adc #<at_line
    sta.z print_sbyte_at.at
    lda #>at_line
    adc #0
    sta.z print_sbyte_at.at+1
    ldy.z i
    ldx xrs,y
    jsr print_sbyte_at
    // print_sbyte_at(yrs[i], at_line+40*1+c)
    lda.z c
    clc
    adc #<at_line+$28*1
    sta.z print_sbyte_at.at
    lda #>at_line+$28*1
    adc #0
    sta.z print_sbyte_at.at+1
    ldy.z i
    ldx yrs,y
    jsr print_sbyte_at
    // print_sbyte_at(zrs[i], at_line+40*2+c)
    lda.z c
    clc
    adc #<at_line+$28*2
    sta.z print_sbyte_at.at
    lda #>at_line+$28*2
    adc #0
    sta.z print_sbyte_at.at+1
    ldy.z i
    ldx zrs,y
    jsr print_sbyte_at
    // print_sbyte_at(pps[i], at_line+40*3+c)
    lda.z c
    clc
    adc #<at_line+$28*3
    sta.z print_sbyte_at.at
    lda #>at_line+$28*3
    adc #0
    sta.z print_sbyte_at.at+1
    ldy.z i
    ldx pps,y
    jsr print_sbyte_at
    // print_sbyte_at(xps[i], at_line+40*4+c)
    lda.z c
    clc
    adc #<at_line+$28*4
    sta.z print_sbyte_at.at
    lda #>at_line+$28*4
    adc #0
    sta.z print_sbyte_at.at+1
    ldy.z i
    ldx xps,y
    jsr print_sbyte_at
    // print_sbyte_at(yps[i], at_line+40*5+c)
    lda.z c
    clc
    adc #<at_line+$28*5
    sta.z print_sbyte_at.at
    lda #>at_line+$28*5
    adc #0
    sta.z print_sbyte_at.at+1
    ldy.z i
    ldx yps,y
    jsr print_sbyte_at
    // c += 4
    lax.z c
    axs #-[4]
    stx.z c
    // for( byte i: 0..7)
    inc.z i
    lda #8
    cmp.z i
    beq !__b1+
    jmp __b1
  !__b1:
    // }
    rts
}
// Print a signed byte as hex at a specific screen position
// print_sbyte_at(signed byte register(X) b, byte* zp($e) at)
print_sbyte_at: {
    .label at = $e
    // if(b<0)
    cpx #0
    bmi __b1
    // print_char_at(' ', at)
    ldy #' '
    jsr print_char_at
  __b2:
    // print_byte_at((byte)b, at+1)
    inc.z print_byte_at.at
    bne !+
    inc.z print_byte_at.at+1
  !:
    jsr print_byte_at
    // }
    rts
  __b1:
    // print_char_at('-', at)
    ldy #'-'
    jsr print_char_at
    // b = -b
    txa
    eor #$ff
    clc
    adc #1
    tax
    jmp __b2
}
// Print a single char
// print_char_at(byte register(Y) ch, byte* zp($e) at)
print_char_at: {
    .label at = $e
    // *(at) = ch
    tya
    ldy #0
    sta (at),y
    // }
    rts
}
// Print a byte as HEX at a specific position
// print_byte_at(byte register(X) b, byte* zp($e) at)
print_byte_at: {
    .label at = $e
    // b>>4
    txa
    lsr
    lsr
    lsr
    lsr
    tay
    // print_char_at(print_hextab[b>>4], at)
    lda print_hextab,y
    tay
  // Table of hexadecimal digits
    jsr print_char_at
    // b&$f
    lda #$f
    axs #0
    // print_char_at(print_hextab[b&$f], at+1)
    inc.z print_char_at.at
    bne !+
    inc.z print_char_at.at+1
  !:
    ldy print_hextab,x
    jsr print_char_at
    // }
    rts
}
// Rotate a 3D point (x,y,z) using the rotation matrix
// The rotation matrix is prepared by calling prepare_matrix() 
// The passed points must be in the interval [-$3f;$3f].
// Implemented in assembler to utilize seriously fast multiplication 
// rotate_matrix(signed byte register(X) x, signed byte zp(6) y, signed byte zp(5) z)
rotate_matrix: {
    .label y = 6
    .label z = 5
    // *xr = x
    txa
    sta xr
    // *yr = y
    lda.z y
    sta yr
    // *zr = z
    lda.z z
    sta zr
    // asm
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
    // }
    rts
}
// Store the rotation matrix into the rotation routine rotate()
// After this each call to rotate() will rotate a point with the matrix
// Implemented in assembler to utilize seriously fast multiplication 
store_matrix: {
    // asm
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
    // }
    rts
}
// Prepare the 3x3 rotation matrix into rotation_matrix[]
// Angles sx, sy, sz are based on 2*PI=$100 
// Method described in C= Hacking Magazine Issue 8. http://www.ffd2.com/fridge/chacking/c=hacking8.txt
// calculate_matrix(signed byte register(X) sx, signed byte zp(3) sy)
calculate_matrix: {
    .label sy = 3
    .label t1 = 5
    .label t2 = 6
    .label t3 = 7
    .label t4 = 8
    .label t5 = 9
    .label t6 = $a
    .label t7 = $b
    .label t8 = $c
    .label t9 = $d
    // t1 = sy-sz
    lda.z sy
    sta.z t1
    // t2 = sy+sz
    lda.z sy
    sta.z t2
    // t3 = sx+sz
    stx.z t3
    // t4 = sx-sz
    stx.z t4
    // t5 = sx+t2
    txa
    clc
    adc.z t2
    sta.z t5
    // t6 = sx-t1
    txa
    sec
    sbc.z t1
    sta.z t6
    // t7 = sx+t1
    txa
    clc
    adc.z t1
    sta.z t7
    // t8 = t2-sx
    txa
    eor #$ff
    sec
    adc.z t2
    sta.z t8
    // t9 = sy-sx
    txa
    eor #$ff
    sec
    adc.z sy
    sta.z t9
    // t10 = sy+sx
    txa
    clc
    adc.z sy
    tax
    // COSH[t1]+COSH[t2]
    ldy.z t1
    lda COSH,y
    ldy.z t2
    clc
    adc COSH,y
    // rotation_matrix[0] = COSH[t1]+COSH[t2]
    sta rotation_matrix
    // SINH[t1]-SINH[t2]
    ldy.z t1
    lda SINH,y
    ldy.z t2
    sec
    sbc SINH,y
    // rotation_matrix[1] = SINH[t1]-SINH[t2]
    sta rotation_matrix+1
    // SINH[sy]+SINH[sy]
    ldy.z sy
    clc
    lda SINH,y
    adc SINH,y
    // rotation_matrix[2] = SINH[sy]+SINH[sy]
    sta rotation_matrix+2
    // SINH[t3]-SINH[t4]
    ldy.z t3
    lda SINH,y
    ldy.z t4
    sec
    sbc SINH,y
    // SINH[t3]-SINH[t4] + COSQ[t6]
    ldy.z t6
    clc
    adc COSQ,y
    // SINH[t3]-SINH[t4] + COSQ[t6]-COSQ[t5]
    ldy.z t5
    sec
    sbc COSQ,y
    // SINH[t3]-SINH[t4] + COSQ[t6]-COSQ[t5]+COSQ[t8]
    ldy.z t8
    clc
    adc COSQ,y
    // SINH[t3]-SINH[t4] + COSQ[t6]-COSQ[t5]+COSQ[t8]-COSQ[t7]
    ldy.z t7
    sec
    sbc COSQ,y
    // rotation_matrix[3] = SINH[t3]-SINH[t4] + COSQ[t6]-COSQ[t5]+COSQ[t8]-COSQ[t7]
    sta rotation_matrix+3
    // COSH[t3]+COSH[t4]
    ldy.z t3
    lda COSH,y
    ldy.z t4
    clc
    adc COSH,y
    // COSH[t3]+COSH[t4] + SINQ[t5]
    ldy.z t5
    clc
    adc SINQ,y
    // COSH[t3]+COSH[t4] + SINQ[t5]-SINQ[t6]
    ldy.z t6
    sec
    sbc SINQ,y
    // COSH[t3]+COSH[t4] + SINQ[t5]-SINQ[t6]-SINQ[t7]
    ldy.z t7
    sec
    sbc SINQ,y
    // COSH[t3]+COSH[t4] + SINQ[t5]-SINQ[t6]-SINQ[t7]-SINQ[t8]
    ldy.z t8
    sec
    sbc SINQ,y
    // rotation_matrix[4] = COSH[t3]+COSH[t4] + SINQ[t5]-SINQ[t6]-SINQ[t7]-SINQ[t8]
    sta rotation_matrix+4
    // SINH[t9]-SINH[t10]
    ldy.z t9
    lda SINH,y
    sec
    sbc SINH,x
    // rotation_matrix[5] = SINH[t9]-SINH[t10]
    sta rotation_matrix+5
    // COSH[t4]-COSH[t3]
    ldy.z t4
    lda COSH,y
    ldy.z t3
    sec
    sbc COSH,y
    // COSH[t4]-COSH[t3] + SINQ[t6]
    ldy.z t6
    clc
    adc SINQ,y
    // COSH[t4]-COSH[t3] + SINQ[t6]-SINQ[t5]
    ldy.z t5
    sec
    sbc SINQ,y
    // COSH[t4]-COSH[t3] + SINQ[t6]-SINQ[t5]-SINQ[t8]
    ldy.z t8
    sec
    sbc SINQ,y
    // COSH[t4]-COSH[t3] + SINQ[t6]-SINQ[t5]-SINQ[t8]-SINQ[t7]
    ldy.z t7
    sec
    sbc SINQ,y
    // rotation_matrix[6] = COSH[t4]-COSH[t3] + SINQ[t6]-SINQ[t5]-SINQ[t8]-SINQ[t7]
    sta rotation_matrix+6
    // SINH[t3]+SINH[t4]
    ldy.z t3
    lda SINH,y
    ldy.z t4
    clc
    adc SINH,y
    // SINH[t3]+SINH[t4] + COSQ[t6]
    ldy.z t6
    clc
    adc COSQ,y
    // SINH[t3]+SINH[t4] + COSQ[t6]-COSQ[t5]
    ldy.z t5
    sec
    sbc COSQ,y
    // SINH[t3]+SINH[t4] + COSQ[t6]-COSQ[t5]+COSQ[t7]
    ldy.z t7
    clc
    adc COSQ,y
    // SINH[t3]+SINH[t4] + COSQ[t6]-COSQ[t5]+COSQ[t7]-COSQ[t8]
    ldy.z t8
    sec
    sbc COSQ,y
    // rotation_matrix[7] = SINH[t3]+SINH[t4] + COSQ[t6]-COSQ[t5]+COSQ[t7]-COSQ[t8]
    sta rotation_matrix+7
    // COSH[t9]+COSH[t10]
    lda COSH,x
    ldy.z t9
    clc
    adc COSH,y
    // rotation_matrix[8] = COSH[t9]+COSH[t10]
    sta rotation_matrix+8
    // }
    rts
}
debug_print_init: {
    .label COLS = $d800
    .label at_line = SCREEN+$10*$28
    .label at_cols = COLS+$10*$28
    .label __41 = $e
    .label __44 = $10
    .label __47 = $12
    .label __50 = $14
    .label __53 = $16
    .label __56 = $18
    .label __59 = $1a
    .label __62 = $1c
    .label __65 = $1e
    .label c = 4
    .label i = 5
    // print_cls()
    jsr print_cls
    // print_str_at("sx", SCREEN+40*0+34)
    lda #<SCREEN+$22
    sta.z print_str_at.at
    lda #>SCREEN+$22
    sta.z print_str_at.at+1
    lda #<str
    sta.z print_str_at.str
    lda #>str
    sta.z print_str_at.str+1
    jsr print_str_at
    // print_str_at("sy", SCREEN+40*1+34)
    lda #<SCREEN+$28*1+$22
    sta.z print_str_at.at
    lda #>SCREEN+$28*1+$22
    sta.z print_str_at.at+1
    lda #<str1
    sta.z print_str_at.str
    lda #>str1
    sta.z print_str_at.str+1
    jsr print_str_at
    // print_str_at("sz", SCREEN+40*2+34)
    lda #<SCREEN+$28*2+$22
    sta.z print_str_at.at
    lda #>SCREEN+$28*2+$22
    sta.z print_str_at.at+1
    lda #<str2
    sta.z print_str_at.str
    lda #>str2
    sta.z print_str_at.str+1
    jsr print_str_at
    // print_str_at("x", SCREEN+40*16)
    lda #<SCREEN+$28*$10
    sta.z print_str_at.at
    lda #>SCREEN+$28*$10
    sta.z print_str_at.at+1
    lda #<str3
    sta.z print_str_at.str
    lda #>str3
    sta.z print_str_at.str+1
    jsr print_str_at
    // print_str_at("y", SCREEN+40*17)
    lda #<SCREEN+$28*$11
    sta.z print_str_at.at
    lda #>SCREEN+$28*$11
    sta.z print_str_at.at+1
    lda #<str4
    sta.z print_str_at.str
    lda #>str4
    sta.z print_str_at.str+1
    jsr print_str_at
    // print_str_at("z", SCREEN+40*18)
    lda #<SCREEN+$28*$12
    sta.z print_str_at.at
    lda #>SCREEN+$28*$12
    sta.z print_str_at.at+1
    lda #<str5
    sta.z print_str_at.str
    lda #>str5
    sta.z print_str_at.str+1
    jsr print_str_at
    // print_str_at("xr", SCREEN+40*19)
    lda #<SCREEN+$28*$13
    sta.z print_str_at.at
    lda #>SCREEN+$28*$13
    sta.z print_str_at.at+1
    lda #<str6
    sta.z print_str_at.str
    lda #>str6
    sta.z print_str_at.str+1
    jsr print_str_at
    // print_str_at("yr", SCREEN+40*20)
    lda #<SCREEN+$28*$14
    sta.z print_str_at.at
    lda #>SCREEN+$28*$14
    sta.z print_str_at.at+1
    lda #<str7
    sta.z print_str_at.str
    lda #>str7
    sta.z print_str_at.str+1
    jsr print_str_at
    // print_str_at("zr", SCREEN+40*21)
    lda #<SCREEN+$28*$15
    sta.z print_str_at.at
    lda #>SCREEN+$28*$15
    sta.z print_str_at.at+1
    lda #<str8
    sta.z print_str_at.str
    lda #>str8
    sta.z print_str_at.str+1
    jsr print_str_at
    // print_str_at("pp", SCREEN+40*22)
    lda #<SCREEN+$28*$16
    sta.z print_str_at.at
    lda #>SCREEN+$28*$16
    sta.z print_str_at.at+1
    lda #<str9
    sta.z print_str_at.str
    lda #>str9
    sta.z print_str_at.str+1
    jsr print_str_at
    // print_str_at("xp", SCREEN+40*23)
    lda #<SCREEN+$28*$17
    sta.z print_str_at.at
    lda #>SCREEN+$28*$17
    sta.z print_str_at.at+1
    lda #<str10
    sta.z print_str_at.str
    lda #>str10
    sta.z print_str_at.str+1
    jsr print_str_at
    // print_str_at("yp", SCREEN+40*24)
    lda #<SCREEN+$28*$18
    sta.z print_str_at.at
    lda #>SCREEN+$28*$18
    sta.z print_str_at.at+1
    lda #<str11
    sta.z print_str_at.str
    lda #>str11
    sta.z print_str_at.str+1
    jsr print_str_at
    lda #0
    sta.z i
    lda #4
    sta.z c
  __b1:
    // print_sbyte_at(xs[i], at_line+40*0+c)
    lda.z c
    clc
    adc #<at_line
    sta.z print_sbyte_at.at
    lda #>at_line
    adc #0
    sta.z print_sbyte_at.at+1
    ldy.z i
    ldx xs,y
    jsr print_sbyte_at
    // print_sbyte_at(ys[i], at_line+40*1+c)
    lda.z c
    clc
    adc #<at_line+$28*1
    sta.z print_sbyte_at.at
    lda #>at_line+$28*1
    adc #0
    sta.z print_sbyte_at.at+1
    ldy.z i
    ldx ys,y
    jsr print_sbyte_at
    // print_sbyte_at(zs[i], at_line+40*2+c)
    lda.z c
    clc
    adc #<at_line+$28*2
    sta.z print_sbyte_at.at
    lda #>at_line+$28*2
    adc #0
    sta.z print_sbyte_at.at+1
    ldy.z i
    ldx zs,y
    jsr print_sbyte_at
    ldy #0
  __b2:
    // col = 8+i
    lax.z i
    axs #-[8]
    // at_cols+40*0+c
    lda.z c
    clc
    adc #<at_cols
    sta.z __41
    lda #>at_cols
    adc #0
    sta.z __41+1
    // *(at_cols+40*0+c+j) = col
    txa
    sta (__41),y
    // at_cols+40*1+c
    lda.z c
    clc
    adc #<at_cols+$28*1
    sta.z __44
    lda #>at_cols+$28*1
    adc #0
    sta.z __44+1
    // *(at_cols+40*1+c+j) = col
    txa
    sta (__44),y
    // at_cols+40*2+c
    lda.z c
    clc
    adc #<at_cols+$28*2
    sta.z __47
    lda #>at_cols+$28*2
    adc #0
    sta.z __47+1
    // *(at_cols+40*2+c+j) = col
    txa
    sta (__47),y
    // at_cols+40*3+c
    lda.z c
    clc
    adc #<at_cols+$28*3
    sta.z __50
    lda #>at_cols+$28*3
    adc #0
    sta.z __50+1
    // *(at_cols+40*3+c+j) = col
    txa
    sta (__50),y
    // at_cols+40*4+c
    lda.z c
    clc
    adc #<at_cols+$28*4
    sta.z __53
    lda #>at_cols+$28*4
    adc #0
    sta.z __53+1
    // *(at_cols+40*4+c+j) = col
    txa
    sta (__53),y
    // at_cols+40*5+c
    lda.z c
    clc
    adc #<at_cols+$28*5
    sta.z __56
    lda #>at_cols+$28*5
    adc #0
    sta.z __56+1
    // *(at_cols+40*5+c+j) = col
    txa
    sta (__56),y
    // at_cols+40*6+c
    lda.z c
    clc
    adc #<at_cols+$28*6
    sta.z __59
    lda #>at_cols+$28*6
    adc #0
    sta.z __59+1
    // *(at_cols+40*6+c+j) = col
    txa
    sta (__59),y
    // at_cols+40*7+c
    lda.z c
    clc
    adc #<at_cols+$28*7
    sta.z __62
    lda #>at_cols+$28*7
    adc #0
    sta.z __62+1
    // *(at_cols+40*7+c+j) = col
    txa
    sta (__62),y
    // at_cols+40*8+c
    lda.z c
    clc
    adc #<at_cols+$28*8
    sta.z __65
    lda #>at_cols+$28*8
    adc #0
    sta.z __65+1
    // *(at_cols+40*8+c+j) = col
    txa
    sta (__65),y
    // for( byte j: 0..3)
    iny
    cpy #4
    beq !__b2+
    jmp __b2
  !__b2:
    // c += 4
    lax.z c
    axs #-[4]
    stx.z c
    // for( byte i: 0..7)
    inc.z i
    lda #8
    cmp.z i
    beq !__b1+
    jmp __b1
  !__b1:
    // }
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
// print_str_at(byte* zp($e) str, byte* zp($10) at)
print_str_at: {
    .label at = $10
    .label str = $e
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // *(at++) = *(str++)
    ldy #0
    lda (str),y
    sta (at),y
    // *(at++) = *(str++);
    inc.z at
    bne !+
    inc.z at+1
  !:
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    jsr memset
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = print_screen
    .label end = str+num
    .label dst = $10
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // }
    rts
  __b2:
    // *dst = c
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
// Initialize sprites
sprites_init: {
    .label SCREEN = $400
    .label sprites_ptr = SCREEN+$3f8
    // *SPRITES_ENABLE = %11111111
    lda #$ff
    sta SPRITES_ENABLE
    ldx #0
  __b1:
    // sprites_ptr[i] = (byte)(SPRITE/$40)
    lda #SPRITE/$40
    sta sprites_ptr,x
    // SPRITES_COLS[i] = GREEN
    lda #GREEN
    sta SPRITES_COLS,x
    // for(byte i: 0..7)
    inx
    cpx #8
    bne __b1
    // }
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

