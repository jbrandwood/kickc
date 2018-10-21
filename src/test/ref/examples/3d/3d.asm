.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label BORDERCOL = $d020
  .const LIGHT_BLUE = $e
  .label COSH = $2000
  .label COSQ = $2200
  .label xr = $f0
  .label yr = $f1
  .label zr = $f2
  .label SINH = COSH+$40
  .label SINQ = COSQ+$40
  jsr main
main: {
    .label SCREEN = $400
    sei
    jsr mulf_init
    jsr prepare_matrix
  b4:
    lda RASTER
    cmp #$ff
    bne b4
    inc BORDERCOL
    lda #$3f
    sta rotate.z
    lda #0
    tax
    tay
    jsr rotate
    lda xr
    sta SCREEN
    lda yr
    sta SCREEN+1
    lda zr
    sta SCREEN+2
    inc BORDERCOL
    lda #0
    sta rotate.z
    lda #$3f
    tax
    lda #0
    tay
    jsr rotate
    lda xr
    sta SCREEN+$28
    lda yr
    sta SCREEN+$29
    lda zr
    sta SCREEN+$2a
    inc BORDERCOL
    lda #0
    sta rotate.z
    tax
    lda #$3f
    tay
    jsr rotate
    lda xr
    sta SCREEN+$50
    lda yr
    sta SCREEN+$51
    lda zr
    sta SCREEN+$52
    lda #LIGHT_BLUE
    sta BORDERCOL
    jmp b4
}
rotate: {
    .label z = 2
    tya
    sta xr
    txa
    sta yr
    lda z
    sta zr
    clc
    tax
    lda #$80
  C1:
    adc mulf_sqr1,x
  C2:
    sbc mulf_sqr2,x
    sta C3+1
    lda #$80
  F1:
    adc mulf_sqr1,x
  F2:
    sbc mulf_sqr2,x
    sta F3+1
    lda #$80
  I1:
    adc mulf_sqr1,x
  I2:
    sbc mulf_sqr2,x
    sta I3+1
    ldx xr
    ldy yr
  C3:
    lda #0
  A1:
    adc mulf_sqr1,x
  A2:
    sbc mulf_sqr2,x
  B1:
    adc mulf_sqr1,y
  B2:
    sbc mulf_sqr2,y
    sta xr
  F3:
    lda #0
  D1:
    adc mulf_sqr1,x
  D2:
    sbc mulf_sqr2,x
  E1:
    adc mulf_sqr1,y
  E2:
    sbc mulf_sqr2,y
    sta yr
  I3:
    lda #0
  G1:
    adc mulf_sqr1,x
  G2:
    sbc mulf_sqr2,x
  H1:
    adc mulf_sqr1,y
  H2:
    sbc mulf_sqr2,y
    sta zr
    rts
}
prepare_matrix: {
    .const sx = 0
    .const sy = 0
    .const sz = 0
    .const t1 = sy-sz
    .const t2 = sy+sz
    .const t3 = sx+sz
    .const t4 = sx-sz
    .const t9 = sy-sx
    .const t10 = sy+sx
    .const t5 = sx+t2
    .const t6 = sx-t1
    .const t7 = sx+t1
    .const t8 = t2-sx
    .label _13 = 2
    .label _15 = 2
    .label _18 = 2
    .label _24 = 2
    .label _29 = 2
    .label _31 = 2
    lda COSH+t1
    ldy COSH+t2
    sty $ff
    clc
    adc $ff
    sta rotation_matrix
    lda SINH+t1
    ldy SINH+t2
    sty $ff
    sec
    sbc $ff
    sta rotation_matrix+1
    lda SINH+sy
    tay
    sty $ff
    clc
    adc $ff
    sta rotation_matrix+2
    lda SINH+t3
    ldy SINH+t4
    sty $ff
    sec
    sbc $ff
    sta _13
    lda COSQ+t6
    clc
    adc _13
    ldy COSQ+t5
    sty $ff
    sec
    sbc $ff
    sta _15
    lda COSQ+t8
    clc
    adc _15
    ldy COSQ+t7
    sty $ff
    sec
    sbc $ff
    sta rotation_matrix+3
    lda COSH+t3
    ldy COSH+t4
    sty $ff
    clc
    adc $ff
    sta _18
    lda SINQ+t5
    clc
    adc _18
    ldy SINQ+t6
    sty $ff
    sec
    sbc $ff
    ldy SINQ+t7
    sty $ff
    sec
    sbc $ff
    ldy SINQ+t8
    sty $ff
    sec
    sbc $ff
    sta rotation_matrix+4
    lda SINH+t9
    ldy SINH+t10
    sty $ff
    sec
    sbc $ff
    sta rotation_matrix+5
    lda COSH+t4
    ldy COSH+t3
    sty $ff
    sec
    sbc $ff
    sta _24
    lda SINQ+t6
    clc
    adc _24
    ldy SINQ+t5
    sty $ff
    sec
    sbc $ff
    ldy SINQ+t8
    sty $ff
    sec
    sbc $ff
    ldy SINQ+t7
    sty $ff
    sec
    sbc $ff
    sta rotation_matrix+6
    lda SINH+t3
    ldy SINH+t4
    sty $ff
    clc
    adc $ff
    sta _29
    lda COSQ+t6
    clc
    adc _29
    ldy COSQ+t5
    sty $ff
    sec
    sbc $ff
    sta _31
    lda COSQ+t7
    clc
    adc _31
    ldy COSQ+t8
    sty $ff
    sec
    sbc $ff
    sta rotation_matrix+7
    lda COSH+t9
    ldy COSH+t10
    sty $ff
    clc
    adc $ff
    sta rotation_matrix+8
    lda rotation_matrix+0
    sta rotate.A1+1
    eor #$ff
    sta rotate.A2+1
    lda rotation_matrix+1
    sta rotate.B1+1
    eor #$ff
    sta rotate.B2+1
    lda rotation_matrix+2
    sta rotate.C1+1
    eor #$ff
    sta rotate.C2+1
    lda rotation_matrix+3
    sta rotate.D1+1
    eor #$ff
    sta rotate.D2+1
    lda rotation_matrix+4
    sta rotate.E1+1
    eor #$ff
    sta rotate.E2+1
    lda rotation_matrix+5
    sta rotate.F1+1
    eor #$ff
    sta rotate.F2+1
    lda rotation_matrix+6
    sta rotate.G1+1
    eor #$ff
    sta rotate.G2+1
    lda rotation_matrix+7
    sta rotate.H1+1
    eor #$ff
    sta rotate.H2+1
    lda rotation_matrix+8
    sta rotate.I1+1
    eor #$ff
    sta rotate.I2+1
    rts
}
mulf_init: {
    .label sqr1 = 3
    .label add = 5
    lda #<1
    sta add
    lda #>1
    sta add+1
    tax
    sta sqr1
    sta sqr1+1
  b1:
    lda sqr1+1
    sta mulf_sqr1,x
    txa
    eor #$ff
    clc
    adc #1
    tay
    lda sqr1+1
    sta mulf_sqr1,y
    sta mulf_sqr2+1,x
    txa
    eor #$ff
    clc
    adc #1+1
    tay
    lda sqr1+1
    sta mulf_sqr2,y
    lda sqr1
    clc
    adc add
    sta sqr1
    lda sqr1+1
    adc add+1
    sta sqr1+1
    lda add
    clc
    adc #2
    sta add
    bcc !+
    inc add+1
  !:
    inx
    cpx #$81
    bne b1
    rts
}
  .align $100
  mulf_sqr1: .fill $200, 0
  .align $100
  mulf_sqr2: .fill $200, 0
  rotation_matrix: .fill 9, 0
.pc = COSH "Inline"
  {
    .var min = -$1fff
    .var max = $1fff
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte >round(min+(ampl/2)+(ampl/2)*cos(rad))
    }
    }

.pc = COSQ "Inline"
  {
    .var min = -$0fff
    .var max = $0fff
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte >round(min+(ampl/2)+(ampl/2)*cos(rad))
    }
    }

