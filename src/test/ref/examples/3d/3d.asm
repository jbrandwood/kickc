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
  .label SCREEN = $400
  .label SPRITE = $3000
  .label COSH = $2000
  .label COSQ = $2200
  .label xr = $f0
  .label yr = $f1
  .label zr = $f2
  .label SINH = COSH+$40
  .label SINQ = COSQ+$40
  jsr main
main: {
    .label sy = 3
    .label sz = 4
    .label sx = 2
    .label i = 5
    sei
    jsr sprites_init
    jsr mulf_init
    lda #0
    sta sz
    sta sy
    sta sx
  b4:
    lda RASTER
    cmp #$ff
    bne b4
    inc BORDERCOL
    ldy sx
    ldx sz
    jsr prepare_matrix
    dec sy
    inc sz
    lda sy
    and #1
    cmp #0
    bne b7
    inc sx
  b7:
    lda #0
    sta i
  b8:
    inc BORDERCOL
    ldy i
    lda xs,y
    sta rotate.x
    ldx i
    ldy ys,x
    lda zs,x
    tax
    jsr rotate
    lda i
    asl
    tax
    lda xr
    cmp #$80
    ror
    clc
    adc #$80
    sta SPRITES_XPOS,x
    lda yr
    cmp #$80
    ror
    clc
    adc #$80
    sta SPRITES_YPOS,x
    inc i
    lda i
    cmp #8
    bne b8
    lda #LIGHT_BLUE
    sta BORDERCOL
    jmp b4
}
rotate: {
    .label x = $a
    lda x
    sta xr
    tya
    sta yr
    txa
    sta zr
    clc
    tax
    lda #0
  C1:
    adc mulf_sqr1,x
  C2:
    sbc mulf_sqr2,x
    sta C3+1
    lda #0
  F1:
    adc mulf_sqr1,x
  F2:
    sbc mulf_sqr2,x
    sta F3+1
    lda #0
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
    .label sy = 3
    .label t1 = 5
    .label t2 = $a
    .label t3 = $b
    .label t4 = $c
    .label t5 = $d
    .label t6 = $e
    .label t7 = $f
    .label t8 = $10
    .label t9 = $11
    .label t10 = $12
    txa
    eor #$ff
    sec
    adc sy
    sta t1
    txa
    clc
    adc sy
    sta t2
    txa
    sty $ff
    clc
    adc $ff
    sta t3
    tya
    stx $ff
    sec
    sbc $ff
    sta t4
    tya
    clc
    adc t2
    sta t5
    tya
    sec
    sbc t1
    sta t6
    tya
    clc
    adc t1
    sta t7
    tya
    eor #$ff
    sec
    adc t2
    sta t8
    tya
    eor #$ff
    sec
    adc sy
    sta t9
    tya
    clc
    adc sy
    sta t10
    ldx t1
    ldy t2
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
    .label sqr1 = 6
    .label add = 8
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
    sta mulf_sqr1+$100,x
    txa
    eor #$ff
    clc
    adc #1
    tay
    lda sqr1+1
    sta mulf_sqr1,y
    txa
    eor #$ff
    clc
    adc #1
    tay
    lda sqr1+1
    sta mulf_sqr1+$100,y
    sta mulf_sqr2+1,x
    sta mulf_sqr2+$100+1,x
    txa
    eor #$ff
    clc
    adc #1+1
    tay
    lda sqr1+1
    sta mulf_sqr2,y
    txa
    eor #$ff
    clc
    adc #1+1
    tay
    lda sqr1+1
    sta mulf_sqr2+$100,y
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
sprites_init: {
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
  .align $100
  mulf_sqr1: .fill $200, 0
  .align $100
  mulf_sqr2: .fill $200, 0
  rotation_matrix: .fill 9, 0
  xs: .byte -$3f, -$3f, -$3f, -$3f, $3f, $3f, $3f, $3f
  ys: .byte -$3f, -$3f, $3f, $3f, -$3f, -$3f, $3f, $3f
  zs: .byte -$3f, $3f, -$3f, $3f, -$3f, $3f, -$3f, $3f
.pc = SPRITE "Inline"
  .var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)

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

