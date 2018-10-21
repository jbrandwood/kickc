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
    jsr calculate_matrix
    dec sy
    inc sz
    jsr store_matrix
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
    sta rotate_matrix.x
    ldx i
    ldy ys,x
    lda zs,x
    tax
    jsr rotate_matrix
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
rotate_matrix: {
    .label x = $a
    lda x
    sta xr
    tya
    sta yr
    txa
    sta zr
    clc
    tax
  C1:
    lda mulf_sqr1,x
  C2:
    sbc mulf_sqr2,x
    sta C3+1
  F1:
    lda mulf_sqr1,x
  F2:
    sbc mulf_sqr2,x
    sta F3+1
  I1:
    lda mulf_sqr1,x
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
    rts
}
mulf_init: {
    .label val = 2
    .label sqr = 6
    .label add = 8
    lda #<1
    sta add
    lda #>1
    sta add+1
    tax
    sta sqr
    sta sqr+1
  b1:
    lda sqr+1
    sta val
    sta mulf_sqr1,x
    sta mulf_sqr1+$100,x
    txa
    eor #$ff
    clc
    adc #1
    tay
    lda val
    sta mulf_sqr1,y
    txa
    eor #$ff
    clc
    adc #1
    tay
    lda val
    sta mulf_sqr1+$100,y
    sta mulf_sqr2+1,x
    sta mulf_sqr2+$100+1,x
    txa
    eor #$ff
    clc
    adc #1+1
    tay
    lda val
    sta mulf_sqr2,y
    txa
    eor #$ff
    clc
    adc #1+1
    tay
    lda val
    sta mulf_sqr2+$100,y
    lda sqr
    clc
    adc add
    sta sqr
    lda sqr+1
    adc add+1
    sta sqr+1
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
  rotation_matrix: .fill 9, 0
  .align $100
  mulf_sqr1: .fill $200, 0
  .align $100
  mulf_sqr2: .fill $200, 0
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

