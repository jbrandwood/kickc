// 2D rotattion of 8 sprites 
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
  .const LIGHT_BLUE = $e
  .label SCREEN = $400
  // Sine and Cosine tables  
  // Angles: $00=0, $80=PI,$100=2*PI
  // Sine/Cosine: signed fixed [-$7f,$7f]
  .label COS = $2000
  // A single sprite
  .label SPRITE = $3000
  .label SIN = COS+$40
// sin(x) = cos(x+PI/2)
main: {
    sei
    jsr init
    jsr anim
    rts
}
anim: {
    .label _4 = 5
    .label _6 = 5
    .label _9 = 5
    .label _10 = 5
    .label _11 = 5
    .label _12 = 5
    .label cos_a = $b
    .label sin_a = $c
    .label x = $d
    .label y = $e
    .label xr = 7
    .label yr = 9
    .label xpos = 5
    .label sprite_msb = 4
    .label i = 3
    .label angle = 2
    lda #0
    sta angle
  b2:
    lda #$ff
    cmp RASTER
    bne b2
    inc BORDERCOL
    ldy angle
    lda COS,y
    sta cos_a
    lda SIN,y
    sta sin_a
    lda #0
    sta sprite_msb
    sta i
  b4:
    ldy i
    lda xs,y
    sta x
    // signed fixed[7.0]
    lda ys,y
    sta y
    lda cos_a
    jsr mulf8u_prepare
    ldy x
    jsr mulf8s_prepared
    lda _4
    asl
    sta xr
    lda _4+1
    rol
    sta xr+1
    ldy y
    jsr mulf8s_prepared
    lda _6
    asl
    sta yr
    lda _6+1
    rol
    sta yr+1
    lda sin_a
    jsr mulf8u_prepare
    ldy y
    jsr mulf8s_prepared
    asl _10
    rol _10+1
    lda xr
    sec
    sbc _10
    sta xr
    lda xr+1
    sbc _10+1
    sta xr+1
    ldy x
    jsr mulf8s_prepared
    asl _12
    rol _12+1
    // signed fixed[8.8]
    lda yr
    clc
    adc _12
    sta yr
    lda yr+1
    adc _12+1
    sta yr+1
    lda xr+1
    tax
    clc
    adc #<$18+$95
    sta xpos
    txa
    ora #$7f
    bmi !+
    lda #0
  !:
    adc #>$18+$95
    sta xpos+1
    lsr sprite_msb
    cmp #0
    beq b5
    lda #$80
    ora sprite_msb
    sta sprite_msb
  b5:
    lda yr+1
    clc
    adc #$59+$33
    tay
    lda i
    asl
    tax
    lda xpos
    sta SPRITES_XPOS,x
    tya
    sta SPRITES_YPOS,x
    inc i
    lda #8
    cmp i
    beq !b4+
    jmp b4
  !b4:
    lda sprite_msb
    sta SPRITES_XMSB
    inc angle
    lda #LIGHT_BLUE
    sta BORDERCOL
    jmp b2
}
// Calculate fast multiply with a prepared unsigned byte to a word result
// The prepared number is set by calling mulf8s_prepare(byte a)
// mulf8s_prepared(signed byte register(Y) b)
mulf8s_prepared: {
    .label memA = $fd
    .label _8 = $f
    .label _12 = $f
    .label m = 5
    .label return = 5
    tya
    jsr mulf8u_prepared
    lda memA
    cmp #0
    bpl b1
    lda m+1
    sta _8
    tya
    eor #$ff
    sec
    adc _8
    sta m+1
  b1:
    cpy #0
    bpl b2
    lda m+1
    sta _12
    lda memA
    eor #$ff
    sec
    adc _12
    sta m+1
  b2:
    rts
}
// Calculate fast multiply with a prepared unsigned byte to a word result
// The prepared number is set by calling mulf8u_prepare(byte a)
// mulf8u_prepared(byte register(A) b)
mulf8u_prepared: {
    .label resL = $fe
    .label memB = $ff
    .label return = 5
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
// Prepare for fast multiply with an unsigned byte to a word result
// mulf8u_prepare(byte register(A) a)
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
    jsr mulf_init
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
// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x/4)
mulf_init: {
    .label sqr1_hi = 7
    .label sqr = 9
    .label sqr1_lo = 5
    .label x_2 = 2
    .label sqr2_hi = 7
    .label sqr2_lo = 5
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
    bcc !+
    inc sqr+1
  !:
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
  b4:
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
    bne b5
    lda #1
    sta dir
  b5:
    inc sqr2_lo
    bne !+
    inc sqr2_lo+1
  !:
    lda sqr2_lo+1
    cmp #>mulf_sqr2_lo+$1ff
    bne b4
    lda sqr2_lo
    cmp #<mulf_sqr2_lo+$1ff
    bne b4
    // Set the very last value g(511) = f(256)
    lda mulf_sqr1_lo+$100
    sta mulf_sqr2_lo+$1ff
    lda mulf_sqr1_hi+$100
    sta mulf_sqr2_hi+$1ff
    rts
}
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
  // Positions to rotate
  xs: .byte -$46, -$46, -$46, 0, 0, $46, $46, $46
  ys: .byte -$46, 0, $46, -$46, $46, -$46, 0, $46
.pc = COS "COS"
  {
    .var min = -$7fff
    .var max = $7fff
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte >round(min+(ampl/2)+(ampl/2)*cos(rad))
    }
    }

.pc = SPRITE "SPRITE"
  .var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)

