// 3D Rotation using a Rotation Matrix
// Based on: 
// - C= Hacking Magazine Issue 8. http://www.ffd2.com/fridge/chacking/c=hacking8.txt
// - Codebase64 Article http://codebase64.org/doku.php?id=base:3d_rotation  
/// @file
/// Commodore 64 Registers and Constants
/// @file
/// The MOS 6526 Complex Interface Adapter (CIA)
///
/// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
  // Commodore 64 PRG executable file
.file [name="3d.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const GREEN = 5
  .const LIGHT_BLUE = $e
  .const LIGHT_GREY = $f
  .const OFFSET_STRUCT_MOS6569_VICII_RASTER = $12
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITES_ENABLE = $15
  .const sz = 0
  /// Sprite X position register for sprite #0
  .label SPRITES_XPOS = $d000
  /// Sprite Y position register for sprite #0
  .label SPRITES_YPOS = $d001
  /// Sprite colors register for sprite #0
  .label SPRITES_COLOR = $d027
  /// The VIC-II MOS 6567/6569
  .label VICII = $d000
  .label SCREEN = $400
  .label COSH = SINH+$40
  .label COSQ = SINQ+$40
  .label print_screen = $400
  // The rotated point - updated by calling rotate_matrix()
  .label xr = 5
  .label yr = 6
  .label zr = 7
  // The rotated point with perspective
  .label pp = 8
  .label xp = 9
  .label yp = $a
  // Pointers used to multiply perspective (d/z0-z) onto x- & y-coordinates. Points into mulf_sqr1 / mulf_sqr2  
  .label psp1 = $b
  .label psp2 = $d
  .label sx = 2
  .label sy = 3
.segment Code
__start: {
    // signed char xr
    lda #0
    sta.z xr
    // signed char yr
    sta.z yr
    // signed char zr
    sta.z zr
    // signed char pp
    sta.z pp
    // signed char xp
    sta.z xp
    // signed char yp
    sta.z yp
    // unsigned int psp1
    sta.z psp1
    sta.z psp1+1
    // unsigned int psp2
    sta.z psp2
    sta.z psp2+1
    jsr main
    rts
}
main: {
    // asm
    sei
    // sprites_init()
    jsr sprites_init
    // psp1 = (unsigned int)mulf_sqr1
    //mulf_init();
    lda #<mulf_sqr1
    sta.z psp1
    lda #>mulf_sqr1
    sta.z psp1+1
    // psp2 = (unsigned int)mulf_sqr2
    lda #<mulf_sqr2
    sta.z psp2
    lda #>mulf_sqr2
    sta.z psp2+1
    // debug_print_init()
    jsr debug_print_init
    // anim()
  //calculate_matrix(1,1,1);
    jsr anim
    // }
    rts
}
// Initialize sprites
sprites_init: {
    .label SCREEN = $400
    .label sprites_ptr = SCREEN+$3f8
    // VICII->SPRITES_ENABLE = %11111111
    lda #$ff
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_ENABLE
    ldx #0
  __b1:
    // sprites_ptr[i] = (char)(SPRITE/$40)
    lda #$ff&SPRITE/$40
    sta sprites_ptr,x
    // SPRITES_COLOR[i] = GREEN
    lda #GREEN
    sta SPRITES_COLOR,x
    // for(char i: 0..7)
    inx
    cpx #8
    bne __b1
    // }
    rts
}
debug_print_init: {
    .label COLS = $d800
    .label at_line = SCREEN+$10*$28
    .label at_cols = COLS+$10*$28
    .label __41 = $f
    .label __44 = $11
    .label __47 = $13
    .label __50 = $15
    .label __53 = $17
    .label __56 = $19
    .label __59 = $1b
    .label __62 = $1d
    .label __65 = $1f
    .label c = 2
    .label i = 3
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
    // print_schar_at(xs[i], at_line+40*0+c)
    lda.z c
    clc
    adc #<at_line
    sta.z print_schar_at.at
    lda #>at_line
    adc #0
    sta.z print_schar_at.at+1
    ldy.z i
    lda xs,y
    sta.z print_schar_at.b
    jsr print_schar_at
    // print_schar_at(ys[i], at_line+40*1+c)
    lda.z c
    clc
    adc #<at_line+$28*1
    sta.z print_schar_at.at
    lda #>at_line+$28*1
    adc #0
    sta.z print_schar_at.at+1
    ldy.z i
    lda ys,y
    sta.z print_schar_at.b
    jsr print_schar_at
    // print_schar_at(zs[i], at_line+40*2+c)
    lda.z c
    clc
    adc #<at_line+$28*2
    sta.z print_schar_at.at
    lda #>at_line+$28*2
    adc #0
    sta.z print_schar_at.at+1
    ldy.z i
    lda zs,y
    sta.z print_schar_at.b
    jsr print_schar_at
    ldy #0
  __b2:
    // char col = 8+i
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
    // for( char j: 0..3)
    iny
    cpy #4
    beq !__b2+
    jmp __b2
  !__b2:
    // c += 4
    lax.z c
    axs #-[4]
    stx.z c
    // for( char i: 0..7)
    inc.z i
    lda #8
    cmp.z i
    beq !__b1+
    jmp __b1
  !__b1:
    // }
    rts
  .segment Data
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
.segment Code
anim: {
    .label i = 4
    lda #0
    sta.z sy
    sta.z sx
  __b2:
    // while(VICII->RASTER!=$ff)
    lda #$ff
    cmp VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    bne __b2
  __b3:
    // while(VICII->RASTER!=$fe)
    lda #$fe
    cmp VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    bne __b3
  __b4:
    // while(VICII->RASTER!=$fd)
    lda #$fd
    cmp VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    bne __b4
    // (VICII->BORDER_COLOR)++;
    inc VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // calculate_matrix(sx,sy,sz)
    ldx.z sx
    //calculate_matrix_16(sx,sy,sz);
    jsr calculate_matrix
    // store_matrix()
    jsr store_matrix
    lda #0
    sta.z i
  __b6:
    // (VICII->BORDER_COLOR)++;
    inc VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // rotate_matrix(xs[i], ys[i], zs[i])
    ldy.z i
    ldx xs,y
    lda ys,y
    sta.z rotate_matrix.y
    lda zs,y
    sta.z rotate_matrix.z
    jsr rotate_matrix
    // xrs[i] = xr
    lda.z xr
    ldy.z i
    sta xrs,y
    // yrs[i] = yr
    lda.z yr
    sta yrs,y
    // zrs[i] = zr
    lda.z zr
    sta zrs,y
    // pps[i] = pp
    lda.z pp
    sta pps,y
    // xps[i] = xp
    lda.z xp
    sta xps,y
    // yps[i] = yp
    lda.z yp
    sta yps,y
    // char i2 = i*2
    tya
    asl
    tax
    // $80+(char)(xp)
    lda.z xp
    clc
    adc #$80
    // SPRITES_XPOS[i2] = $80+(char)(xp)
    sta SPRITES_XPOS,x
    // $80+(char)(yp)
    lda.z yp
    clc
    adc #$80
    // SPRITES_YPOS[i2] = $80+(char)(yp)
    sta SPRITES_YPOS,x
    // for(char i: 0..7)
    inc.z i
    lda #8
    cmp.z i
    bne __b6
    // VICII->BORDER_COLOR = LIGHT_GREY
    lda #LIGHT_GREY
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // debug_print()
    jsr debug_print
    // VICII->BORDER_COLOR = LIGHT_BLUE
    lda #LIGHT_BLUE
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
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
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    jsr memset
    // }
    rts
}
// Print a string at a specific screen position
// print_str_at(byte* zp($f) str, byte* zp($11) at)
print_str_at: {
    .label at = $11
    .label str = $f
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
// Print a signed char as hex at a specific screen position
// print_schar_at(signed byte zp($22) b, byte* zp($f) at)
print_schar_at: {
    .label b = $22
    .label at = $f
    // if(b<0)
    lda.z b
    bmi __b1
    // print_char_at(' ', at)
    ldx #' '
    jsr print_char_at
  __b2:
    // print_uchar_at((char)b, at+1)
    inc.z print_uchar_at.at
    bne !+
    inc.z print_uchar_at.at+1
  !:
    jsr print_uchar_at
    // }
    rts
  __b1:
    // print_char_at('-', at)
    ldx #'-'
    jsr print_char_at
    // b = -b
    lda.z b
    eor #$ff
    clc
    adc #1
    sta.z b
    jmp __b2
}
// Prepare the 3x3 rotation matrix into rotation_matrix[]
// Angles sx, sy, sz are based on 2*PI=$100 
// Method described in C= Hacking Magazine Issue 8. http://www.ffd2.com/fridge/chacking/c=hacking8.txt
// calculate_matrix(signed byte register(X) sx, signed byte zp(3) sy)
calculate_matrix: {
    .label sy = 3
    .label t1 = $21
    .label t2 = $22
    .label t3 = $23
    .label t4 = $24
    .label t5 = $25
    .label t6 = $26
    .label t7 = $27
    .label t8 = $28
    .label t9 = $29
    // signed char t1 = sy-sz
    lda.z sy
    sta.z t1
    // signed char t2 = sy+sz
    lda.z sy
    sta.z t2
    // signed char t3 = sx+sz
    stx.z t3
    // signed char t4 = sx-sz
    stx.z t4
    // signed char t5 = sx+t2
    txa
    clc
    adc.z t2
    sta.z t5
    // signed char t6 = sx-t1
    // = sx+sy+sz
    txa
    sec
    sbc.z t1
    sta.z t6
    // signed char t7 = sx+t1
    // = sx-sy+sz
    txa
    clc
    adc.z t1
    sta.z t7
    // signed char t8 = t2-sx
    // = sx+sy-sz
    txa
    eor #$ff
    sec
    adc.z t2
    sta.z t8
    // signed char t9 = sy-sx
    // = sy+sz-sx
    txa
    eor #$ff
    sec
    adc.z sy
    sta.z t9
    // signed char t10 = sy+sx
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
    lda SINH,y
    clc
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
// Rotate a 3D point (x,y,z) using the rotation matrix
// The rotation matrix is prepared by calling prepare_matrix() 
// The passed points must be in the interval [-$3f;$3f].
// Implemented in assembler to utilize seriously fast multiplication 
// rotate_matrix(signed byte register(X) x, signed byte zp($22) y, signed byte zp($23) z)
rotate_matrix: {
    .label y = $22
    .label z = $23
    // xr = x
    stx.z xr
    // yr = y
    lda.z y
    sta.z yr
    // zr = z
    lda.z z
    sta.z zr
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
debug_print: {
    .const print_schar_pos1_col = $25
    .const print_schar_pos2_row = 1
    .const print_schar_pos2_col = $25
    .const print_schar_pos3_row = 2
    .const print_schar_pos3_col = $25
    .const print_schar_pos4_row = 4
    .const print_schar_pos4_col = $1d
    .const print_schar_pos5_row = 4
    .const print_schar_pos5_col = $21
    .const print_schar_pos6_row = 4
    .const print_schar_pos6_col = $25
    .const print_schar_pos7_row = 5
    .const print_schar_pos7_col = $1d
    .const print_schar_pos8_row = 5
    .const print_schar_pos8_col = $21
    .const print_schar_pos9_row = 5
    .const print_schar_pos9_col = $25
    .const print_schar_pos10_row = 6
    .const print_schar_pos10_col = $1d
    .const print_schar_pos11_row = 6
    .const print_schar_pos11_col = $21
    .const print_schar_pos12_row = 6
    .const print_schar_pos12_col = $25
    .label at_line = SCREEN+$13*$28
    .label c = $23
    .label i = $21
    // print_schar_pos(sx, 0, 37)
    lda.z sx
    // print_schar_at(sb, print_screen+row*40+col)
    sta.z print_schar_at.b
    lda #<print_screen+print_schar_pos1_col
    sta.z print_schar_at.at
    lda #>print_screen+print_schar_pos1_col
    sta.z print_schar_at.at+1
    jsr print_schar_at
    // print_schar_pos(sy, 1, 37)
    lda.z sy
    // print_schar_at(sb, print_screen+row*40+col)
    sta.z print_schar_at.b
    lda #<print_screen+print_schar_pos2_row*$28+print_schar_pos2_col
    sta.z print_schar_at.at
    lda #>print_screen+print_schar_pos2_row*$28+print_schar_pos2_col
    sta.z print_schar_at.at+1
    jsr print_schar_at
    // print_schar_at(sb, print_screen+row*40+col)
    lda #<print_screen+print_schar_pos3_row*$28+print_schar_pos3_col
    sta.z print_schar_at.at
    lda #>print_screen+print_schar_pos3_row*$28+print_schar_pos3_col
    sta.z print_schar_at.at+1
    lda #sz
    sta.z print_schar_at.b
    jsr print_schar_at
    // print_schar_pos(rotation_matrix[0], 4, 29)
    lda rotation_matrix
    // print_schar_at(sb, print_screen+row*40+col)
    sta.z print_schar_at.b
    lda #<print_screen+print_schar_pos4_row*$28+print_schar_pos4_col
    sta.z print_schar_at.at
    lda #>print_screen+print_schar_pos4_row*$28+print_schar_pos4_col
    sta.z print_schar_at.at+1
    jsr print_schar_at
    // print_schar_pos(rotation_matrix[1], 4, 33)
    lda rotation_matrix+1
    // print_schar_at(sb, print_screen+row*40+col)
    sta.z print_schar_at.b
    lda #<print_screen+print_schar_pos5_row*$28+print_schar_pos5_col
    sta.z print_schar_at.at
    lda #>print_screen+print_schar_pos5_row*$28+print_schar_pos5_col
    sta.z print_schar_at.at+1
    jsr print_schar_at
    // print_schar_pos(rotation_matrix[2], 4, 37)
    lda rotation_matrix+2
    // print_schar_at(sb, print_screen+row*40+col)
    sta.z print_schar_at.b
    lda #<print_screen+print_schar_pos6_row*$28+print_schar_pos6_col
    sta.z print_schar_at.at
    lda #>print_screen+print_schar_pos6_row*$28+print_schar_pos6_col
    sta.z print_schar_at.at+1
    jsr print_schar_at
    // print_schar_pos(rotation_matrix[3], 5, 29)
    lda rotation_matrix+3
    // print_schar_at(sb, print_screen+row*40+col)
    sta.z print_schar_at.b
    lda #<print_screen+print_schar_pos7_row*$28+print_schar_pos7_col
    sta.z print_schar_at.at
    lda #>print_screen+print_schar_pos7_row*$28+print_schar_pos7_col
    sta.z print_schar_at.at+1
    jsr print_schar_at
    // print_schar_pos(rotation_matrix[4], 5, 33)
    lda rotation_matrix+4
    // print_schar_at(sb, print_screen+row*40+col)
    sta.z print_schar_at.b
    lda #<print_screen+print_schar_pos8_row*$28+print_schar_pos8_col
    sta.z print_schar_at.at
    lda #>print_screen+print_schar_pos8_row*$28+print_schar_pos8_col
    sta.z print_schar_at.at+1
    jsr print_schar_at
    // print_schar_pos(rotation_matrix[5], 5, 37)
    lda rotation_matrix+5
    // print_schar_at(sb, print_screen+row*40+col)
    sta.z print_schar_at.b
    lda #<print_screen+print_schar_pos9_row*$28+print_schar_pos9_col
    sta.z print_schar_at.at
    lda #>print_screen+print_schar_pos9_row*$28+print_schar_pos9_col
    sta.z print_schar_at.at+1
    jsr print_schar_at
    // print_schar_pos(rotation_matrix[6], 6, 29)
    lda rotation_matrix+6
    // print_schar_at(sb, print_screen+row*40+col)
    sta.z print_schar_at.b
    lda #<print_screen+print_schar_pos10_row*$28+print_schar_pos10_col
    sta.z print_schar_at.at
    lda #>print_screen+print_schar_pos10_row*$28+print_schar_pos10_col
    sta.z print_schar_at.at+1
    jsr print_schar_at
    // print_schar_pos(rotation_matrix[7], 6, 33)
    lda rotation_matrix+7
    // print_schar_at(sb, print_screen+row*40+col)
    sta.z print_schar_at.b
    lda #<print_screen+print_schar_pos11_row*$28+print_schar_pos11_col
    sta.z print_schar_at.at
    lda #>print_screen+print_schar_pos11_row*$28+print_schar_pos11_col
    sta.z print_schar_at.at+1
    jsr print_schar_at
    // print_schar_pos(rotation_matrix[8], 6, 37)
    lda rotation_matrix+8
    // print_schar_at(sb, print_screen+row*40+col)
    sta.z print_schar_at.b
    lda #<print_screen+print_schar_pos12_row*$28+print_schar_pos12_col
    sta.z print_schar_at.at
    lda #>print_screen+print_schar_pos12_row*$28+print_schar_pos12_col
    sta.z print_schar_at.at+1
    jsr print_schar_at
    lda #0
    sta.z i
    lda #4
    sta.z c
  __b1:
    // print_schar_at(xrs[i], at_line+40*0+c)
    lda.z c
    clc
    adc #<at_line
    sta.z print_schar_at.at
    lda #>at_line
    adc #0
    sta.z print_schar_at.at+1
    ldy.z i
    lda xrs,y
    sta.z print_schar_at.b
    jsr print_schar_at
    // print_schar_at(yrs[i], at_line+40*1+c)
    lda.z c
    clc
    adc #<at_line+$28*1
    sta.z print_schar_at.at
    lda #>at_line+$28*1
    adc #0
    sta.z print_schar_at.at+1
    ldy.z i
    lda yrs,y
    sta.z print_schar_at.b
    jsr print_schar_at
    // print_schar_at(zrs[i], at_line+40*2+c)
    lda.z c
    clc
    adc #<at_line+$28*2
    sta.z print_schar_at.at
    lda #>at_line+$28*2
    adc #0
    sta.z print_schar_at.at+1
    ldy.z i
    lda zrs,y
    sta.z print_schar_at.b
    jsr print_schar_at
    // print_schar_at(pps[i], at_line+40*3+c)
    lda.z c
    clc
    adc #<at_line+$28*3
    sta.z print_schar_at.at
    lda #>at_line+$28*3
    adc #0
    sta.z print_schar_at.at+1
    ldy.z i
    lda pps,y
    sta.z print_schar_at.b
    jsr print_schar_at
    // print_schar_at(xps[i], at_line+40*4+c)
    lda.z c
    clc
    adc #<at_line+$28*4
    sta.z print_schar_at.at
    lda #>at_line+$28*4
    adc #0
    sta.z print_schar_at.at+1
    ldy.z i
    lda xps,y
    sta.z print_schar_at.b
    jsr print_schar_at
    // print_schar_at(yps[i], at_line+40*5+c)
    lda.z c
    clc
    adc #<at_line+$28*5
    sta.z print_schar_at.at
    lda #>at_line+$28*5
    adc #0
    sta.z print_schar_at.at+1
    ldy.z i
    lda yps,y
    sta.z print_schar_at.b
    jsr print_schar_at
    // c += 4
    lax.z c
    axs #-[4]
    stx.z c
    // for( char i: 0..7)
    inc.z i
    lda #8
    cmp.z i
    beq !__b1+
    jmp __b1
  !__b1:
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = print_screen
    .label end = str+num
    .label dst = $11
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
// Print a single char
// print_char_at(byte register(X) ch, byte* zp($f) at)
print_char_at: {
    .label at = $f
    // *(at) = ch
    txa
    ldy #0
    sta (at),y
    // }
    rts
}
// Print a char as HEX at a specific position
// print_uchar_at(byte zp($22) b, byte* zp($f) at)
print_uchar_at: {
    .label b = $22
    .label at = $f
    // b>>4
    lda.z b
    lsr
    lsr
    lsr
    lsr
    // print_char_at(print_hextab[b>>4], at)
    tay
    ldx print_hextab,y
  // Table of hexadecimal digits
    jsr print_char_at
    // b&$f
    lda #$f
    and.z b
    tay
    // print_char_at(print_hextab[b&$f], at+1)
    inc.z print_char_at.at
    bne !+
    inc.z print_char_at.at+1
  !:
    ldx print_hextab,y
    jsr print_char_at
    // }
    rts
}
.segment Data
  print_hextab: .text "0123456789abcdef"
  // Positions to rotate
  xs: .byte -$34, -$34, -$34, 0, 0, $34, $34, $34
  ys: .byte -$34, 0, $34, -$34, $34, -$34, 0, $34
  zs: .byte $34, $34, $34, $34, $34, $34, $34, $34
  // Rotated positions
  xrs: .fill 8, 0
  yrs: .fill 8, 0
  zrs: .fill 8, 0
  // Perspective factors (from zrs)
  pps: .fill 8, 0
  // Rotated positions with perspective
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

.pc = $3000 "SPRITE"
// A single sprite
SPRITE:
.var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)

