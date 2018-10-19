.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label SPRITES_XMSB = $d010
  .label RASTER = $d012
  .label SPRITES_ENABLE = $d015
  .label BORDERCOL = $d020
  .label SPRITES_COLS = $d027
  .const GREEN = 5
  .label SCREEN = $400
  .label SPRITE = $3000
  .label COS = $2000
  .label SIN = COS+$40
  jsr main
main: {
    sei
    jsr init
    jsr anim
    rts
}
anim: {
    .const x = $59
    .const y = 0
    .label _4 = 5
    .label _6 = 7
    .label _10 = 3
    .label _11 = 3
    .label _12 = 3
    .label _13 = 3
    .label xr = 5
    .label yr = 7
    .label xpos = 3
    ldy #0
  b4:
    lda RASTER
    cmp #$ff
    bne b4
    inc BORDERCOL
    lda COS,y
    jsr mulf8u_prepare
    lda #x
    sta mulf8s_prepared.b
    jsr mulf8s_prepared
    lda mulf8s_prepared.return
    sta _4
    lda mulf8s_prepared.return+1
    sta _4+1
    asl xr
    rol xr+1
    lda #y
    sta mulf8s_prepared.b
    jsr mulf8s_prepared
    lda mulf8s_prepared.return
    sta _6
    lda mulf8s_prepared.return+1
    sta _6+1
    asl yr
    rol yr+1
    lda SIN,y
    jsr mulf8u_prepare
    lda #y
    sta mulf8s_prepared.b
    jsr mulf8s_prepared
    asl _11
    rol _11+1
    lda xr
    sec
    sbc _11
    sta xr
    lda xr+1
    sbc _11+1
    sta xr+1
    lda #x
    sta mulf8s_prepared.b
    jsr mulf8s_prepared
    asl _13
    rol _13+1
    lda yr
    clc
    adc _13
    sta yr
    lda yr+1
    adc _13+1
    sta yr+1
    lda xr+1
    sta xpos
    ora #$7f
    bmi !+
    lda #0
  !:
    sta xpos+1
    lda xpos
    clc
    adc #$59+$18+$3c
    sta xpos
    lda xpos+1
    adc #0
    sta xpos+1
    lda xpos
    sta SPRITES_XPOS
    lda xpos+1
    sta SPRITES_XMSB
    lda yr+1
    clc
    adc #$59+$33
    sta SPRITES_YPOS
    iny
    dec BORDERCOL
    jmp b4
}
mulf8s_prepared: {
    .label memA = $fd
    .label m = 3
    .label return = 3
    .label b = 2
    jsr mulf8u_prepared
    lda memA
    cmp #0
    bpl b1
    lda m+1
    sec
    sbc b
    sta m+1
  b1:
    lda b
    cmp #0
    bpl b2
    lda m+1
    sec
    sbc memA
    sta m+1
  b2:
    rts
}
mulf8u_prepared: {
    .label resL = $fe
    .label memB = $ff
    .label return = 3
    lda mulf8s_prepared.b
    sta memB
    tax
    sec
  sm1:
    lda mulf_sqr1_lo,x
  sm2:
    sbc mulf_sqr2_lo,x
    sta resL
  sm3:
    lda mulf_sqr1_hi,x
  sm4:
    sbc mulf_sqr2_hi,x
    sta memB
    lda resL
    sta return
    lda memB
    sta return+1
    rts
}
mulf8u_prepare: {
    .label memA = $fd
    sta memA
    sta mulf8u_prepared.sm1+1
    sta mulf8u_prepared.sm3+1
    eor #$ff
    sta mulf8u_prepared.sm2+1
    sta mulf8u_prepared.sm4+1
    rts
}
init: {
    .label sprites_ptr = SCREEN+$3f8
    .label spr_x = 2
    jsr mulf_init
    lda #$ff
    sta SPRITES_ENABLE
    lda #$3c
    sta spr_x
    ldy #0
  b1:
    tya
    asl
    tax
    lda #$ff&SPRITE/$40
    sta sprites_ptr,y
    lda spr_x
    sta SPRITES_XPOS,x
    sta SPRITES_YPOS,x
    lda #GREEN
    sta SPRITES_COLS,y
    lda #$18
    clc
    adc spr_x
    sta spr_x
    iny
    cpy #8
    bne b1
    rts
}
mulf_init: {
    .label sqr1_hi = 5
    .label sqr = 7
    .label sqr1_lo = 3
    .label x_2 = 2
    .label sqr2_hi = 5
    .label sqr2_lo = 3
    .label dir = 2
    lda #0
    sta x_2
    lda #<mulf_sqr1_hi+1
    sta sqr1_hi
    lda #>mulf_sqr1_hi+1
    sta sqr1_hi+1
    lda #<mulf_sqr1_lo+1
    sta sqr1_lo
    lda #>mulf_sqr1_lo+1
    sta sqr1_lo+1
    lda #<0
    sta sqr
    sta sqr+1
    tax
  b1:
    inx
    txa
    and #1
    cmp #0
    bne b2
    inc x_2
    inc sqr
    bne !+
    inc sqr+1
  !:
  b2:
    lda sqr
    ldy #0
    sta (sqr1_lo),y
    lda sqr+1
    sta (sqr1_hi),y
    inc sqr1_hi
    bne !+
    inc sqr1_hi+1
  !:
    lda x_2
    clc
    adc sqr
    sta sqr
    lda #0
    adc sqr+1
    sta sqr+1
    inc sqr1_lo
    bne !+
    inc sqr1_lo+1
  !:
    lda sqr1_lo+1
    cmp #>mulf_sqr1_lo+$200
    bne b1
    lda sqr1_lo
    cmp #<mulf_sqr1_lo+$200
    bne b1
    lda #$ff
    sta dir
    lda #<mulf_sqr2_hi
    sta sqr2_hi
    lda #>mulf_sqr2_hi
    sta sqr2_hi+1
    lda #<mulf_sqr2_lo
    sta sqr2_lo
    lda #>mulf_sqr2_lo
    sta sqr2_lo+1
    ldx #-1
  b3:
    lda mulf_sqr1_lo,x
    ldy #0
    sta (sqr2_lo),y
    lda mulf_sqr1_hi,x
    sta (sqr2_hi),y
    inc sqr2_hi
    bne !+
    inc sqr2_hi+1
  !:
    txa
    clc
    adc dir
    tax
    cpx #0
    bne b4
    lda #1
    sta dir
  b4:
    inc sqr2_lo
    bne !+
    inc sqr2_lo+1
  !:
    lda sqr2_lo+1
    cmp #>mulf_sqr2_lo+$1ff
    bne b3
    lda sqr2_lo
    cmp #<mulf_sqr2_lo+$1ff
    bne b3
    lda mulf_sqr1_lo+$100
    sta mulf_sqr2_lo+$1ff
    lda mulf_sqr1_hi+$100
    sta mulf_sqr2_hi+$1ff
    rts
}
  .align $100
  mulf_sqr1_lo: .fill $200, 0
  .align $100
  mulf_sqr1_hi: .fill $200, 0
  .align $100
  mulf_sqr2_lo: .fill $200, 0
  .align $100
  mulf_sqr2_hi: .fill $200, 0
.pc = COS "Inline"
  {
    .var min = -$7fff
    .var max = $7fff
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
    	.var rad = i*2*PI/256;
        .byte >round(min+(ampl/2)+(ampl/2)*cos(rad))
    }
    }

.pc = SPRITE "Inline"
  .var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)

