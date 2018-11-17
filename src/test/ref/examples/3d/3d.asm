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
  .label xr = $f0
  .label yr = $f1
  .label zr = $f2
  .label pp = $f3
  .label xp = $f4
  .label yp = $f5
  .label psp1 = $f6
  .label psp2 = $f8
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
    jsr anim
    rts
}
anim: {
    .label i = 4
    lda #0
    sta sy
    sta sx
  b4:
    lda RASTER
    cmp #$ff
    bne b4
    inc BORDERCOL
    ldx sx
    jsr calculate_matrix
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
    adc xp
    sta SPRITES_XPOS,x
    lda #$80
    clc
    adc yp
    sta SPRITES_YPOS,x
    inc i
    lda i
    cmp #8
    bne b7
    lda #LIGHT_GREY
    sta BORDERCOL
    lda #LIGHT_BLUE
    sta BORDERCOL
    inc sx
    inc sx
    lda sy
    sec
    sbc #3
    sta sy
    jmp b4
}
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
calculate_matrix: {
    .label sy = 3
    .label t1 = 4
    .label t3 = 5
    .label t4 = 6
    .label t5 = 7
    .label t6 = 8
    .label t7 = 9
    .label t8 = $a
    .label t9 = $b
    .label t10 = $c
    lda sy
    sec
    sbc #sz
    sta t1
    lda #sz
    clc
    adc sy
    tay
    stx t3
    stx t4
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
    lda SINH+sz,x
    sbc SINH+-sz,y
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
  zs: .byte $34, $34, $34, $34, $34, $34, $34, $34
  xrs: .fill 8, 0
  yrs: .fill 8, 0
  zrs: .fill 8, 0
  pps: .fill 8, 0
  xps: .fill 8, 0
  yps: .fill 8, 0
  rotation_matrix: .fill 9, 0
  xs: .byte -$34, -$34, -$34, 0, 0, $34, $34, $34
  ys: .byte -$34, 0, $34, -$34, $34, -$34, 0, $34
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

