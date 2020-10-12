// Show a few simple splines using the splines library
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const VIC_BMM = $20
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .const WHITE = 1
  .const MOVE_TO = 0
  .const SPLINE_TO = 1
  .const LINE_TO = 2
  .const SIZEOF_STRUCT_SPLINEVECTOR16 = 4
  .const OFFSET_STRUCT_SPLINEVECTOR16_Y = 2
  .const OFFSET_STRUCT_SEGMENT_TO = 1
  .const OFFSET_STRUCT_SEGMENT_VIA = 5
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR = 2
  .label RASTER = $d012
  .label D011 = $d011
  .label D018 = $d018
  // The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
  .label BITMAP_SCREEN = $5c00
  .label BITMAP_GRAPHICS = $6000
  .label COS = SIN+$40
main: {
    .const vicSelectGfxBank1_toDd001_return = 3^(>BITMAP_SCREEN)/$40
    .const toD0181_return = (>(BITMAP_SCREEN&$3fff)*4)|(>BITMAP_GRAPHICS)/4&$f
    .label angle = 2
    // mulf_init()
    jsr mulf_init
    // bitmap_init(BITMAP_GRAPHICS, BITMAP_SCREEN)
    jsr bitmap_init
    // bitmap_clear(BLACK, WHITE)
    jsr bitmap_clear
    // CIA2->PORT_A_DDR = %00000011
    lda #3
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA2->PORT_A = toDd00(gfx)
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2
    // *D018 = toD018(BITMAP_SCREEN, BITMAP_GRAPHICS)
    lda #toD0181_return
    sta D018
    // *D011 = VIC_BMM|VIC_DEN|VIC_RSEL|3
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta D011
    lda #0
    sta.z angle
  __b2:
    // bitmap_clear(BLACK, WHITE)
    jsr bitmap_clear
    // show_letter(angle)
    jsr show_letter
    ldx #0
  __b3:
    // while(*RASTER!=0xfe)
    lda #$fe
    cmp RASTER
    bne __b3
  __b4:
    // while(*RASTER!=0xff)
    lda #$ff
    cmp RASTER
    bne __b4
    // for ( byte w: 0..60)
    inx
    cpx #$3d
    bne __b3
    // angle += 9
    lax.z angle
    axs #-[9]
    stx.z angle
    jmp __b2
}
// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x/4)
mulf_init: {
    // x/2
    .label c = 3
    // Counter used for determining x%2==0
    .label sqr1_hi = 4
    // Fill mulf_sqr1 = f(x) = int(x*x/4): If f(x) = x*x/4 then f(x+1) = f(x) + x/2 + 1/4
    .label sqr = $c
    .label sqr1_lo = 8
    // Decrease or increase x_255 - initially we decrease
    .label sqr2_hi = $a
    .label sqr2_lo = 6
    //Start with g(0)=f(255)
    .label dir = $18
    ldx #0
    lda #<mulf_sqr1_hi+1
    sta.z sqr1_hi
    lda #>mulf_sqr1_hi+1
    sta.z sqr1_hi+1
    txa
    sta.z sqr
    sta.z sqr+1
    sta.z c
    lda #<mulf_sqr1_lo+1
    sta.z sqr1_lo
    lda #>mulf_sqr1_lo+1
    sta.z sqr1_lo+1
  __b1:
    // for(char* sqr1_lo = mulf_sqr1_lo+1; sqr1_lo!=mulf_sqr1_lo+512; sqr1_lo++)
    lda.z sqr1_lo+1
    cmp #>mulf_sqr1_lo+$200
    bne __b2
    lda.z sqr1_lo
    cmp #<mulf_sqr1_lo+$200
    bne __b2
    lda #$ff
    sta.z dir
    lda #<mulf_sqr2_hi
    sta.z sqr2_hi
    lda #>mulf_sqr2_hi
    sta.z sqr2_hi+1
    ldx #-1
    lda #<mulf_sqr2_lo
    sta.z sqr2_lo
    lda #>mulf_sqr2_lo
    sta.z sqr2_lo+1
  __b5:
    // for(char* sqr2_lo = mulf_sqr2_lo; sqr2_lo!=mulf_sqr2_lo+511; sqr2_lo++)
    lda.z sqr2_lo+1
    cmp #>mulf_sqr2_lo+$1ff
    bne __b6
    lda.z sqr2_lo
    cmp #<mulf_sqr2_lo+$1ff
    bne __b6
    // *(mulf_sqr2_lo+511) = *(mulf_sqr1_lo+256)
    // Set the very last value g(511) = f(256)
    lda mulf_sqr1_lo+$100
    sta mulf_sqr2_lo+$1ff
    // *(mulf_sqr2_hi+511) = *(mulf_sqr1_hi+256)
    lda mulf_sqr1_hi+$100
    sta mulf_sqr2_hi+$1ff
    // }
    rts
  __b6:
    // *sqr2_lo = mulf_sqr1_lo[x_255]
    lda mulf_sqr1_lo,x
    ldy #0
    sta (sqr2_lo),y
    // *sqr2_hi++ = mulf_sqr1_hi[x_255]
    lda mulf_sqr1_hi,x
    sta (sqr2_hi),y
    // *sqr2_hi++ = mulf_sqr1_hi[x_255];
    inc.z sqr2_hi
    bne !+
    inc.z sqr2_hi+1
  !:
    // x_255 = x_255 + dir
    txa
    clc
    adc.z dir
    tax
    // if(x_255==0)
    cpx #0
    bne __b8
    lda #1
    sta.z dir
  __b8:
    // for(char* sqr2_lo = mulf_sqr2_lo; sqr2_lo!=mulf_sqr2_lo+511; sqr2_lo++)
    inc.z sqr2_lo
    bne !+
    inc.z sqr2_lo+1
  !:
    jmp __b5
  __b2:
    // if((++c&1)==0)
    inc.z c
    // ++c&1
    lda #1
    and.z c
    // if((++c&1)==0)
    cmp #0
    bne __b3
    // x_2++;
    inx
    // sqr++;
    inc.z sqr
    bne !+
    inc.z sqr+1
  !:
  __b3:
    // <sqr
    lda.z sqr
    // *sqr1_lo = <sqr
    ldy #0
    sta (sqr1_lo),y
    // >sqr
    lda.z sqr+1
    // *sqr1_hi++ = >sqr
    sta (sqr1_hi),y
    // *sqr1_hi++ = >sqr;
    inc.z sqr1_hi
    bne !+
    inc.z sqr1_hi+1
  !:
    // sqr = sqr + x_2
    txa
    clc
    adc.z sqr
    sta.z sqr
    bcc !+
    inc.z sqr+1
  !:
    // for(char* sqr1_lo = mulf_sqr1_lo+1; sqr1_lo!=mulf_sqr1_lo+512; sqr1_lo++)
    inc.z sqr1_lo
    bne !+
    inc.z sqr1_lo+1
  !:
    jmp __b1
}
// Initialize bitmap plotting tables
bitmap_init: {
    .label __7 = $18
    .label yoffs = 8
    ldx #0
    lda #$80
  __b1:
    // bitmap_plot_bit[x] = bits
    sta bitmap_plot_bit,x
    // bits >>= 1
    lsr
    // if(bits==0)
    cmp #0
    bne __b2
    lda #$80
  __b2:
    // for(char x : 0..255)
    inx
    cpx #0
    bne __b1
    lda #<BITMAP_GRAPHICS
    sta.z yoffs
    lda #>BITMAP_GRAPHICS
    sta.z yoffs+1
    ldx #0
  __b3:
    // y&$7
    lda #7
    sax.z __7
    // <yoffs
    lda.z yoffs
    // y&$7 | <yoffs
    ora.z __7
    // bitmap_plot_ylo[y] = y&$7 | <yoffs
    sta bitmap_plot_ylo,x
    // >yoffs
    lda.z yoffs+1
    // bitmap_plot_yhi[y] = >yoffs
    sta bitmap_plot_yhi,x
    // if((y&$7)==7)
    lda #7
    cmp.z __7
    bne __b4
    // yoffs = yoffs + 40*8
    clc
    lda.z yoffs
    adc #<$28*8
    sta.z yoffs
    lda.z yoffs+1
    adc #>$28*8
    sta.z yoffs+1
  __b4:
    // for(char y : 0..255)
    inx
    cpx #0
    bne __b3
    // }
    rts
}
// Clear all graphics on the bitmap
// bgcol - the background color to fill the screen with
// fgcol - the foreground color to fill the screen with
bitmap_clear: {
    .const col = WHITE<<4
    // memset(bitmap_screen, col, 1000uw)
    ldx #col
    lda #<BITMAP_SCREEN
    sta.z memset.str
    lda #>BITMAP_SCREEN
    sta.z memset.str+1
    lda #<$3e8
    sta.z memset.num
    lda #>$3e8
    sta.z memset.num+1
    jsr memset
    // memset(bitmap_gfx, 0, 8000uw)
    ldx #0
    lda #<BITMAP_GRAPHICS
    sta.z memset.str
    lda #>BITMAP_GRAPHICS
    sta.z memset.str+1
    lda #<$1f40
    sta.z memset.num
    lda #>$1f40
    sta.z memset.num+1
    jsr memset
    // }
    rts
}
// show_letter(byte zp(2) angle)
show_letter: {
    .label __17 = $18
    .label angle = 2
    .label to_x = 8
    .label to_y = $a
    .label to_x_1 = $c
    .label to_y_1 = $e
    .label via_x = 8
    .label via_y = $a
    .label via_x_1 = $c
    .label via_y_1 = $e
    .label segment_via_x = $c
    .label segment_via_y = $e
    .label i = 3
    .label current_x = 4
    .label current_y = 6
    .label current_x_1 = $19
    .label current_y_1 = $1b
    lda #<0
    sta.z current_y
    sta.z current_y+1
    sta.z current_x
    sta.z current_x+1
    sta.z i
  __b1:
    // to = letter_c[i].to
    lda.z i
    asl
    asl
    asl
    clc
    adc.z i
    sta.z __17
    tay
    lda letter_c+OFFSET_STRUCT_SEGMENT_TO,y
    sta.z to_x
    lda letter_c+OFFSET_STRUCT_SEGMENT_TO+1,y
    sta.z to_x+1
    lda letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y,y
    sta.z to_y
    lda letter_c+OFFSET_STRUCT_SEGMENT_TO+OFFSET_STRUCT_SPLINEVECTOR16_Y+1,y
    sta.z to_y+1
    // to = { to.x - 50, to.y - 150}
    lda.z to_x
    sec
    sbc #$32
    sta.z to_x
    lda.z to_x+1
    sbc #>$32
    sta.z to_x+1
    lda.z to_y
    sec
    sbc #<$96
    sta.z to_y
    lda.z to_y+1
    sbc #>$96
    sta.z to_y+1
    // rotate(to, angle)
    ldy.z angle
    jsr rotate
    // rotate(to, angle)
    // to = rotate(to, angle)
    // to = { to.x + 100, to.y + 100}
    clc
    lda.z to_x_1
    adc #<$64
    sta.z current_x_1
    lda.z to_x_1+1
    adc #>$64
    sta.z current_x_1+1
    clc
    lda.z to_y_1
    adc #<$64
    sta.z current_y_1
    lda.z to_y_1+1
    adc #>$64
    sta.z current_y_1+1
    // via = letter_c[i].via
    ldy.z __17
    lda letter_c+OFFSET_STRUCT_SEGMENT_VIA,y
    sta.z via_x
    lda letter_c+OFFSET_STRUCT_SEGMENT_VIA+1,y
    sta.z via_x+1
    lda letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y,y
    sta.z via_y
    lda letter_c+OFFSET_STRUCT_SEGMENT_VIA+OFFSET_STRUCT_SPLINEVECTOR16_Y+1,y
    sta.z via_y+1
    // via = { via.x - 50, via.y - 150}
    lda.z via_x
    sec
    sbc #$32
    sta.z via_x
    lda.z via_x+1
    sbc #>$32
    sta.z via_x+1
    lda.z via_y
    sec
    sbc #<$96
    sta.z via_y
    lda.z via_y+1
    sbc #>$96
    sta.z via_y+1
    // rotate(via, angle)
    ldy.z angle
    jsr rotate
    // rotate(via, angle)
    // via = rotate(via, angle)
    // via = { via.x + 100, via.y + 100}
    clc
    lda.z segment_via_x
    adc #<$64
    sta.z segment_via_x
    lda.z segment_via_x+1
    adc #>$64
    sta.z segment_via_x+1
    clc
    lda.z segment_via_y
    adc #<$64
    sta.z segment_via_y
    lda.z segment_via_y+1
    adc #>$64
    sta.z segment_via_y+1
    // segment = { letter_c[i].type, to, via}
    ldy.z __17
    lda letter_c,y
    // if(segment.type==MOVE_TO)
    cmp #MOVE_TO
    beq __b3
    // if(segment.type==SPLINE_TO)
    cmp #SPLINE_TO
    beq __b2
    // bitmap_line((unsigned int)current.x, (unsigned int)current.y, (unsigned int)segment.to.x, (unsigned int)segment.to.y)
    lda.z current_x_1
    sta.z bitmap_line.x2
    lda.z current_x_1+1
    sta.z bitmap_line.x2+1
    lda.z current_y_1
    sta.z bitmap_line.y2
    lda.z current_y_1+1
    sta.z bitmap_line.y2+1
    jsr bitmap_line
  __b3:
    // for( byte i: 0..21)
    inc.z i
    lda #$16
    cmp.z i
    bne __b9
    // }
    rts
  __b9:
    lda.z current_x_1
    sta.z current_x
    lda.z current_x_1+1
    sta.z current_x+1
    lda.z current_y_1
    sta.z current_y
    lda.z current_y_1+1
    sta.z current_y+1
    jmp __b1
  __b2:
    // spline_8segB(current, segment.via, segment.to)
    jsr spline_8segB
    // bitmap_plot_spline_8seg()
    jsr bitmap_plot_spline_8seg
    jmp __b3
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp($c) str, byte register(X) c, word zp($a) num)
memset: {
    .label end = $a
    .label dst = $c
    .label num = $a
    .label str = $c
    // if(num>0)
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    // end = (char*)str + num
    lda.z end
    clc
    adc.z str
    sta.z end
    lda.z end+1
    adc.z str+1
    sta.z end+1
  __b2:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
  __breturn:
    // }
    rts
  __b3:
    // *dst = c
    txa
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
// 2D-rotate a vector by an angle
// rotate(signed word zp(8) vector_x, signed word zp($a) vector_y, byte register(Y) angle)
rotate: {
    .label __0 = $14
    .label __2 = $14
    .label __4 = $14
    .label __5 = $1f
    .label __6 = $14
    .label __7 = $21
    .label __10 = $1d
    .label __11 = $2c
    .label __12 = $1f
    .label __13 = $21
    .label vector_x = 8
    .label vector_y = $a
    .label return_x = $c
    .label return_y = $e
    .label cos_a = $10
    .label xr = $1d
    .label yr = $2c
    .label sin_a = $10
    // cos_a = (signed int) COS[angle]
    lda COS,y
    sta.z cos_a
    ora #$7f
    bmi !+
    lda #0
  !:
    sta.z cos_a+1
    // mulf16s(cos_a, vector.x)
    lda.z vector_x
    sta.z mulf16s.b
    lda.z vector_x+1
    sta.z mulf16s.b+1
    jsr mulf16s
    // mulf16s(cos_a, vector.x)
    // (signed int )mulf16s(cos_a, vector.x)*2
    lda.z __0
    sta.z __10
    lda.z __0+1
    sta.z __10+1
    // xr = (signed int )mulf16s(cos_a, vector.x)*2
    asl.z xr
    rol.z xr+1
    // mulf16s(cos_a, vector.y)
    lda.z vector_y
    sta.z mulf16s.b
    lda.z vector_y+1
    sta.z mulf16s.b+1
    jsr mulf16s
    // mulf16s(cos_a, vector.y)
    // (signed int )mulf16s(cos_a, vector.y)*2
    lda.z __2
    sta.z __11
    lda.z __2+1
    sta.z __11+1
    // yr = (signed int )mulf16s(cos_a, vector.y)*2
    asl.z yr
    rol.z yr+1
    // sin_a = (signed int) SIN[angle]
    // signed fixed[8.8]
    lda SIN,y
    sta.z sin_a
    ora #$7f
    bmi !+
    lda #0
  !:
    sta.z sin_a+1
    // mulf16s(sin_a, vector.y)
    lda.z vector_y
    sta.z mulf16s.b
    lda.z vector_y+1
    sta.z mulf16s.b+1
    jsr mulf16s
    // mulf16s(sin_a, vector.y)
    // (signed int)mulf16s(sin_a, vector.y)*2
    lda.z __4
    sta.z __12
    lda.z __4+1
    sta.z __12+1
    asl.z __5
    rol.z __5+1
    // xr -= (signed int)mulf16s(sin_a, vector.y)*2
    // signed fixed[0.7]
    lda.z xr
    sec
    sbc.z __5
    sta.z xr
    lda.z xr+1
    sbc.z __5+1
    sta.z xr+1
    // mulf16s(sin_a, vector.x)
    lda.z vector_x
    sta.z mulf16s.b
    lda.z vector_x+1
    sta.z mulf16s.b+1
    jsr mulf16s
    // mulf16s(sin_a, vector.x)
    // (signed int)mulf16s(sin_a, vector.x)*2
    lda.z __6
    sta.z __13
    lda.z __6+1
    sta.z __13+1
    asl.z __7
    rol.z __7+1
    // yr += (signed int)mulf16s(sin_a, vector.x)*2
    // signed fixed[8.8]
    lda.z yr
    clc
    adc.z __7
    sta.z yr
    lda.z yr+1
    adc.z __7+1
    sta.z yr+1
    // >xr
    lda.z xr+1
    // >yr
    ldx.z yr+1
    // rotated = { (signed int)(signed char)>xr, (signed int)(signed char)>yr }
    sta.z return_x
    ora #$7f
    bmi !+
    lda #0
  !:
    sta.z return_x+1
    txa
    sta.z return_y
    ora #$7f
    bmi !+
    lda #0
  !:
    sta.z return_y+1
    // }
    rts
}
// Draw a line on the bitmap using bresenhams algorithm
// bitmap_line(word zp(4) x1, word zp(6) y1, word zp($c) x2, word zp($e) y2)
bitmap_line: {
    .label x = 4
    .label y = 6
    .label dx = $21
    .label dy = $1d
    .label sx = $23
    .label sy = $1f
    .label e1 = $12
    .label e = $10
    .label x1 = 4
    .label y1 = 6
    .label x2 = $c
    .label y2 = $e
    // abs_u16(x2-x1)
    lda.z x2
    sec
    sbc.z x
    sta.z abs_u16.w
    lda.z x2+1
    sbc.z x+1
    sta.z abs_u16.w+1
    jsr abs_u16
    // abs_u16(x2-x1)
    // dx = abs_u16(x2-x1)
    lda.z abs_u16.return
    sta.z dx
    lda.z abs_u16.return+1
    sta.z dx+1
    // abs_u16(y2-y1)
    lda.z y2
    sec
    sbc.z y
    sta.z abs_u16.w
    lda.z y2+1
    sbc.z y+1
    sta.z abs_u16.w+1
    jsr abs_u16
    // abs_u16(y2-y1)
    // dy = abs_u16(y2-y1)
    // if(dx==0 && dy==0)
    lda.z dx
    bne __b1
    lda.z dx+1
    bne __b1
    lda.z dy
    bne !+
    lda.z dy+1
    bne !__b4+
    jmp __b4
  !__b4:
  !:
  __b1:
    // sgn_u16(x2-x1)
    lda.z x2
    sec
    sbc.z x
    sta.z sgn_u16.w
    lda.z x2+1
    sbc.z x+1
    sta.z sgn_u16.w+1
    jsr sgn_u16
    // sgn_u16(x2-x1)
    // sx = sgn_u16(x2-x1)
    lda.z sgn_u16.return
    sta.z sx
    lda.z sgn_u16.return+1
    sta.z sx+1
    // sgn_u16(y2-y1)
    lda.z y2
    sec
    sbc.z y
    sta.z sgn_u16.w
    lda.z y2+1
    sbc.z y+1
    sta.z sgn_u16.w+1
    jsr sgn_u16
    // sgn_u16(y2-y1)
    // sy = sgn_u16(y2-y1)
    // if(dx > dy)
    lda.z dy+1
    cmp.z dx+1
    bcc __b2
    bne !+
    lda.z dy
    cmp.z dx
    bcc __b2
  !:
    // e = dx/2
    lda.z dx+1
    lsr
    sta.z e+1
    lda.z dx
    ror
    sta.z e
  __b6:
    // bitmap_plot(x,(char)y)
    lda.z y
    jsr bitmap_plot
    // y += sy
    lda.z y
    clc
    adc.z sy
    sta.z y
    lda.z y+1
    adc.z sy+1
    sta.z y+1
    // e += dx
    lda.z e
    clc
    adc.z dx
    sta.z e
    lda.z e+1
    adc.z dx+1
    sta.z e+1
    // if(dy<e)
    cmp.z dy+1
    bne !+
    lda.z e
    cmp.z dy
    beq __b7
  !:
    bcc __b7
    // x += sx
    lda.z x
    clc
    adc.z sx
    sta.z x
    lda.z x+1
    adc.z sx+1
    sta.z x+1
    // e -= dy
    lda.z e
    sec
    sbc.z dy
    sta.z e
    lda.z e+1
    sbc.z dy+1
    sta.z e+1
  __b7:
    // while (y != y2)
    lda.z y+1
    cmp.z y2+1
    bne __b6
    lda.z y
    cmp.z y2
    bne __b6
  __b3:
    // bitmap_plot(x,(char)y)
    lda.z y
    jsr bitmap_plot
    // }
    rts
  __b2:
    // e = dy/2
    lda.z dy+1
    lsr
    sta.z e1+1
    lda.z dy
    ror
    sta.z e1
  __b9:
    // bitmap_plot(x,(char)y)
    lda.z y
    jsr bitmap_plot
    // x += sx
    lda.z x
    clc
    adc.z sx
    sta.z x
    lda.z x+1
    adc.z sx+1
    sta.z x+1
    // e += dy
    lda.z e1
    clc
    adc.z dy
    sta.z e1
    lda.z e1+1
    adc.z dy+1
    sta.z e1+1
    // if(dx < e)
    cmp.z dx+1
    bne !+
    lda.z e1
    cmp.z dx
    beq __b10
  !:
    bcc __b10
    // y += sy
    lda.z y
    clc
    adc.z sy
    sta.z y
    lda.z y+1
    adc.z sy+1
    sta.z y+1
    // e -= dx
    lda.z e1
    sec
    sbc.z dx
    sta.z e1
    lda.z e1+1
    sbc.z dx+1
    sta.z e1+1
  __b10:
    // while (x != x2)
    lda.z x+1
    cmp.z x2+1
    bne __b9
    lda.z x
    cmp.z x2
    bne __b9
    jmp __b3
  __b4:
    // bitmap_plot(x,(char)y)
    lda.z y
    jsr bitmap_plot
    rts
}
// Generate a 8-segment quadratic spline using 16-bit fixed point 1/64-format math (6 decimal bits).
// The resulting spline segment points are returned in SPLINE_8SEG[]
// Point values must be within [-200 ; 1ff] for the calculation to not overflow.
// A quadratic spline is a curve defined by 3 points: P0, P1 and P2.
// The curve connects P0 to P2 through a smooth curve that moves towards P1, but does usually not touch it.
// spline_8segB(signed word zp(4) p0_x, signed word zp(6) p0_y, signed word zp($c) p1_x, signed word zp($e) p1_y, signed word zp($19) p2_x, signed word zp($1b) p2_y)
spline_8segB: {
    .label __0 = $23
    .label __1 = $23
    .label __3 = $2a
    .label __4 = $2a
    .label __6 = $c
    .label __8 = $e
    .label __10 = $c
    .label __12 = $e
    .label __18 = 4
    .label __19 = 4
    .label __20 = 6
    .label __21 = 6
    .label __22 = $26
    .label __23 = $26
    .label __24 = $28
    .label __25 = $28
    .label a_x = $23
    .label a_y = $2a
    .label b_x = $c
    .label b_y = $e
    .label i_x = $c
    .label i_y = $e
    .label j_x = $23
    .label j_y = $2a
    .label p_x = 4
    .label p_y = 6
    .label p0_x = 4
    .label p0_y = 6
    .label p1_x = $c
    .label p1_y = $e
    .label p2_x = $19
    .label p2_y = $1b
    // p1.x*2
    lda.z p1_x
    asl
    sta.z __0
    lda.z p1_x+1
    rol
    sta.z __0+1
    // p2.x - p1.x*2
    lda.z p2_x
    sec
    sbc.z __1
    sta.z __1
    lda.z p2_x+1
    sbc.z __1+1
    sta.z __1+1
    // a = { p2.x - p1.x*2 + p0.x, p2.y - p1.y*2 + p0.y}
    lda.z a_x
    clc
    adc.z p0_x
    sta.z a_x
    lda.z a_x+1
    adc.z p0_x+1
    sta.z a_x+1
    // p1.y*2
    lda.z p1_y
    asl
    sta.z __3
    lda.z p1_y+1
    rol
    sta.z __3+1
    // p2.y - p1.y*2
    lda.z p2_y
    sec
    sbc.z __4
    sta.z __4
    lda.z p2_y+1
    sbc.z __4+1
    sta.z __4+1
    // a = { p2.x - p1.x*2 + p0.x, p2.y - p1.y*2 + p0.y}
    lda.z a_y
    clc
    adc.z p0_y
    sta.z a_y
    lda.z a_y+1
    adc.z p0_y+1
    sta.z a_y+1
    // p1.x - p0.x
    lda.z __6
    sec
    sbc.z p0_x
    sta.z __6
    lda.z __6+1
    sbc.z p0_x+1
    sta.z __6+1
    // b = { (p1.x - p0.x)*2, (p1.y - p0.y)*2 }
    asl.z b_x
    rol.z b_x+1
    // p1.y - p0.y
    lda.z __8
    sec
    sbc.z p0_y
    sta.z __8
    lda.z __8+1
    sbc.z p0_y+1
    sta.z __8+1
    // b = { (p1.x - p0.x)*2, (p1.y - p0.y)*2 }
    asl.z b_y
    rol.z b_y+1
    // b.x*8
    asl.z __10
    rol.z __10+1
    asl.z __10
    rol.z __10+1
    asl.z __10
    rol.z __10+1
    // i = { a.x + b.x*8, a.y + b.y*8}
    lda.z i_x
    clc
    adc.z a_x
    sta.z i_x
    lda.z i_x+1
    adc.z a_x+1
    sta.z i_x+1
    // b.y*8
    asl.z __12
    rol.z __12+1
    asl.z __12
    rol.z __12+1
    asl.z __12
    rol.z __12+1
    // i = { a.x + b.x*8, a.y + b.y*8}
    lda.z i_y
    clc
    adc.z a_y
    sta.z i_y
    lda.z i_y+1
    adc.z a_y+1
    sta.z i_y+1
    // j = { a.x*2, a.y*2 }
    asl.z j_x
    rol.z j_x+1
    asl.z j_y
    rol.z j_y+1
    // p = { p0.x*0x40, p0.y*0x40 }
    lda.z p_x+1
    sta.z $ff
    lda.z p_x
    sta.z p_x+1
    lda #0
    sta.z p_x
    lsr.z $ff
    ror.z p_x+1
    ror.z p_x
    lsr.z $ff
    ror.z p_x+1
    ror.z p_x
    lda.z p_y+1
    sta.z $ff
    lda.z p_y
    sta.z p_y+1
    lda #0
    sta.z p_y
    lsr.z $ff
    ror.z p_y+1
    ror.z p_y
    lsr.z $ff
    ror.z p_y+1
    ror.z p_y
    tay
  __b1:
    // p.x+0x20
    clc
    lda.z p_x
    adc #<$20
    sta.z __22
    lda.z p_x+1
    adc #>$20
    sta.z __22+1
    // (p.x+0x20)/0x40
    lda.z __23
    sta.z $ff
    lda.z __23+1
    sta.z __23
    lda #0
    bit.z __23+1
    bpl !+
    lda #$ff
  !:
    sta.z __23+1
    rol.z $ff
    rol.z __23
    rol.z __23+1
    rol.z $ff
    rol.z __23
    rol.z __23+1
    // p.y+0x20
    clc
    lda.z p_y
    adc #<$20
    sta.z __24
    lda.z p_y+1
    adc #>$20
    sta.z __24+1
    // (p.y+0x20)/0x40
    lda.z __25
    sta.z $ff
    lda.z __25+1
    sta.z __25
    lda #0
    bit.z __25+1
    bpl !+
    lda #$ff
  !:
    sta.z __25+1
    rol.z $ff
    rol.z __25
    rol.z __25+1
    rol.z $ff
    rol.z __25
    rol.z __25+1
    // SPLINE_8SEG[n] = { (p.x+0x20)/0x40, (p.y+0x20)/0x40 }
    tya
    asl
    asl
    tax
    lda.z __23
    sta SPLINE_8SEG,x
    lda.z __23+1
    sta SPLINE_8SEG+1,x
    lda.z __25
    sta SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y,x
    lda.z __25+1
    sta SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y+1,x
    // p = { p.x+i.x, p.y+i.y }
    lda.z p_x
    clc
    adc.z i_x
    sta.z p_x
    lda.z p_x+1
    adc.z i_x+1
    sta.z p_x+1
    lda.z p_y
    clc
    adc.z i_y
    sta.z p_y
    lda.z p_y+1
    adc.z i_y+1
    sta.z p_y+1
    // i = { i.x+j.x, i.y+j.y }
    lda.z i_x
    clc
    adc.z j_x
    sta.z i_x
    lda.z i_x+1
    adc.z j_x+1
    sta.z i_x+1
    lda.z i_y
    clc
    adc.z j_y
    sta.z i_y
    lda.z i_y+1
    adc.z j_y+1
    sta.z i_y+1
    // for( char n: 0..7)
    iny
    cpy #8
    beq !__b1+
    jmp __b1
  !__b1:
    // p.x+0x20
    clc
    lda.z __18
    adc #<$20
    sta.z __18
    lda.z __18+1
    adc #>$20
    sta.z __18+1
    // (p.x+0x20)/0x40
    lda.z __19
    sta.z $ff
    lda.z __19+1
    sta.z __19
    lda #0
    bit.z __19+1
    bpl !+
    lda #$ff
  !:
    sta.z __19+1
    rol.z $ff
    rol.z __19
    rol.z __19+1
    rol.z $ff
    rol.z __19
    rol.z __19+1
    // p.y+0x20
    clc
    lda.z __20
    adc #<$20
    sta.z __20
    lda.z __20+1
    adc #>$20
    sta.z __20+1
    // (p.y+0x20)/0x40
    lda.z __21
    sta.z $ff
    lda.z __21+1
    sta.z __21
    lda #0
    bit.z __21+1
    bpl !+
    lda #$ff
  !:
    sta.z __21+1
    rol.z $ff
    rol.z __21
    rol.z __21+1
    rol.z $ff
    rol.z __21
    rol.z __21+1
    // SPLINE_8SEG[8] = { (p.x+0x20)/0x40, (p.y+0x20)/0x40 }
    lda.z __19
    sta SPLINE_8SEG+8*SIZEOF_STRUCT_SPLINEVECTOR16
    lda.z __19+1
    sta SPLINE_8SEG+8*SIZEOF_STRUCT_SPLINEVECTOR16+1
    lda.z __21
    sta SPLINE_8SEG+8*SIZEOF_STRUCT_SPLINEVECTOR16+OFFSET_STRUCT_SPLINEVECTOR16_Y
    lda.z __21+1
    sta SPLINE_8SEG+8*SIZEOF_STRUCT_SPLINEVECTOR16+OFFSET_STRUCT_SPLINEVECTOR16_Y+1
    // }
    rts
}
// Plot the spline in the SPLINE_8SEG array
bitmap_plot_spline_8seg: {
    .label __4 = $25
    .label current_x = 4
    .label current_y = 6
    .label n = $18
    // current = SPLINE_8SEG[0]
    lda SPLINE_8SEG
    sta.z current_x
    lda SPLINE_8SEG+1
    sta.z current_x+1
    lda SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y
    sta.z current_y
    lda SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y+1
    sta.z current_y+1
    lda #1
    sta.z n
  __b1:
    // bitmap_line((unsigned int)current.x, (unsigned int)current.y, (unsigned int)SPLINE_8SEG[n].x, (unsigned int)SPLINE_8SEG[n].y)
    lda.z n
    asl
    asl
    sta.z __4
    tay
    lda SPLINE_8SEG,y
    sta.z bitmap_line.x2
    lda SPLINE_8SEG+1,y
    sta.z bitmap_line.x2+1
    lda SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y,y
    sta.z bitmap_line.y2
    lda SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y+1,y
    sta.z bitmap_line.y2+1
    // bitmap_line((unsigned int)current.x, (unsigned int)current.y, (unsigned int)SPLINE_8SEG[n].x, (unsigned int)SPLINE_8SEG[n].y)
    jsr bitmap_line
    // current = SPLINE_8SEG[n]
    ldy.z __4
    lda SPLINE_8SEG,y
    sta.z current_x
    lda SPLINE_8SEG+1,y
    sta.z current_x+1
    lda SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y,y
    sta.z current_y
    lda SPLINE_8SEG+OFFSET_STRUCT_SPLINEVECTOR16_Y+1,y
    sta.z current_y+1
    // for(char n:1..8)
    inc.z n
    lda #9
    cmp.z n
    bne __b1
    // }
    rts
}
// Fast multiply two signed ints to a signed double unsigned int result
// Fixes offsets introduced by using unsigned multiplication
// mulf16s(signed word zp($10) a, signed word zp($12) b)
mulf16s: {
    .label __6 = $28
    .label __9 = $2a
    .label __11 = $28
    .label __12 = $2a
    .label m = $14
    .label return = $14
    .label a = $10
    .label b = $12
    // mulf16u((unsigned int)a, (unsigned int)b)
    lda.z a
    sta.z mulf16u.a
    lda.z a+1
    sta.z mulf16u.a+1
    lda.z b
    sta.z mulf16u.b
    lda.z b+1
    sta.z mulf16u.b+1
    jsr mulf16u
    // m = mulf16u((unsigned int)a, (unsigned int)b)
    // if(a<0)
    lda.z a+1
    bpl __b1
    // >m
    lda.z m+2
    sta.z __6
    lda.z m+3
    sta.z __6+1
    // >m = (>m)-(unsigned int)b
    lda.z __11
    sec
    sbc.z b
    sta.z __11
    lda.z __11+1
    sbc.z b+1
    sta.z __11+1
    lda.z __11
    sta.z m+2
    lda.z __11+1
    sta.z m+3
  __b1:
    // if(b<0)
    lda.z b+1
    bpl __b2
    // >m
    lda.z m+2
    sta.z __9
    lda.z m+3
    sta.z __9+1
    // >m = (>m)-(unsigned int)a
    lda.z __12
    sec
    sbc.z a
    sta.z __12
    lda.z __12+1
    sbc.z a+1
    sta.z __12+1
    lda.z __12
    sta.z m+2
    lda.z __12+1
    sta.z m+3
  __b2:
    // return (signed long)m;
    // }
    rts
}
// Get the absolute value of a 16-bit unsigned number treated as a signed number.
// abs_u16(word zp($1d) w)
abs_u16: {
    .label w = $1d
    .label return = $1d
    // >w
    lda.z w+1
    // >w&0x80
    and #$80
    // if(>w&0x80)
    cmp #0
    bne __b1
    rts
  __b1:
    // return -w;
    sec
    lda #0
    sbc.z return
    sta.z return
    lda #0
    sbc.z return+1
    sta.z return+1
    // }
    rts
}
// Get the sign of a 16-bit unsigned number treated as a signed number.
// Returns unsigned -1 if the number is
// sgn_u16(word zp($2c) w)
sgn_u16: {
    .label w = $2c
    .label return = $1f
    // >w
    lda.z w+1
    // >w&0x80
    and #$80
    // if(>w&0x80)
    cmp #0
    bne __b1
    lda #<1
    sta.z return
    lda #>1
    sta.z return+1
    rts
  __b1:
    lda #<-1
    sta.z return
    sta.z return+1
    // }
    rts
}
// Plot a single dot in the bitmap
// bitmap_plot(word zp(4) x, byte register(A) y)
bitmap_plot: {
    .label __0 = $2c
    .label plotter = $2a
    .label x = 4
    // plotter = (char*) { bitmap_plot_yhi[y], bitmap_plot_ylo[y] }
    tay
    lda bitmap_plot_yhi,y
    sta.z plotter+1
    lda bitmap_plot_ylo,y
    sta.z plotter
    // x & $fff8
    lda.z x
    and #<$fff8
    sta.z __0
    lda.z x+1
    and #>$fff8
    sta.z __0+1
    // plotter += ( x & $fff8 )
    lda.z plotter
    clc
    adc.z __0
    sta.z plotter
    lda.z plotter+1
    adc.z __0+1
    sta.z plotter+1
    // <x
    ldx.z x
    // *plotter |= bitmap_plot_bit[<x]
    lda bitmap_plot_bit,x
    ldy #0
    ora (plotter),y
    sta (plotter),y
    // }
    rts
}
// Fast multiply two unsigned ints to a double unsigned int result
// Done in assembler to utilize fast addition A+X
// mulf16u(word zp($2a) a, word zp($26) b)
mulf16u: {
    .label memA = $f8
    .label memB = $fa
    .label memR = $fc
    .label return = $14
    .label a = $2a
    .label b = $26
    // *memA = a
    lda.z a
    sta memA
    lda.z a+1
    sta memA+1
    // *memB = b
    lda.z b
    sta memB
    lda.z b+1
    sta memB+1
    // asm
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
    // return *memR;
    lda memR
    sta.z return
    lda memR+1
    sta.z return+1
    lda memR+2
    sta.z return+2
    lda memR+3
    sta.z return+3
    // }
    rts
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
  letter_c: .byte MOVE_TO
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

