.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label SPRITES_XMSB = $d010
  .label RASTER = $d012
  .label SPRITES_ENABLE = $d015
  .label SPRITES_EXPAND_Y = $d017
  .label SPRITES_EXPAND_X = $d01d
  .label SPRITES_COLS = $d027
  .const WHITE = 1
  .label SCREEN = $400
  .label SPRITE = $2000
  .const g = -5
  .label SPRITES_PTR = SCREEN+$3f8
  .label yvel_init = 4
  .label yvel = 4
  .label yvel_9 = 6
  .label xpos = 8
  .label ypos = $a
  .label yvel_10 = 6
  .label xvel = 2
  .label yvel_12 = 6
  .label yvel_22 = 6
  jsr main
main: {
    jsr init
    lda #$64
    sta yvel_init
    lda #0
    sta yvel_init+1
    lda #$c8
    sta xvel
    lda #0
    sta xvel+1
    sta ypos
    sta ypos+1
    sta xpos
    sta xpos+1
    lda #$64
    sta yvel_12
    lda #0
    sta yvel_12+1
  b2:
    lda RASTER
    cmp #$ff
    bne b2
    jsr anim
    jmp b2
}
anim: {
    .label _10 = $c
    .label _12 = $e
    .label sprite_x = $c
    .label sprite_y = $e
    lda ypos+1
    bpl b1
    sec
    lda xvel
    eor #$ff
    adc #0
    sta xvel
    lda xvel+1
    eor #$ff
    adc #0
    sta xvel+1
    lda yvel_init
    sec
    sbc #<$a
    sta yvel_init
    lda yvel_init+1
    sbc #>$a
    sta yvel_init+1
    lda yvel_init
    cmp #<-$c8
    lda yvel_init+1
    sbc #>-$c8
    bvc !+
    eor #$80
  !:
    bpl b2
    lda #$c8
    sta yvel
    lda #0
    sta yvel+1
  b2:
    lda yvel
    sta yvel_22
    lda yvel+1
    sta yvel_22+1
    lda #0
    sta ypos
    sta ypos+1
    sta xpos
    sta xpos+1
  b1:
    lda yvel_10
    clc
    adc #<g
    sta yvel_10
    lda yvel_10+1
    adc #>g
    sta yvel_10+1
    clc
    lda xpos
    adc xvel
    sta xpos
    lda xpos+1
    adc xvel+1
    sta xpos+1
    clc
    lda ypos
    adc yvel_10
    sta ypos
    lda ypos+1
    adc yvel_10+1
    sta ypos+1
    lda xpos
    sta $ff
    lda xpos+1
    sta _10
    lda #0
    bit xpos+1
    bpl !+
    lda #$ff
  !:
    sta _10+1
    rol $ff
    rol _10
    rol _10+1
    lda sprite_x
    clc
    adc #<$a0
    sta sprite_x
    lda sprite_x+1
    adc #>$a0
    sta sprite_x+1
    lda ypos
    sta $ff
    lda ypos+1
    sta _12
    lda #0
    bit ypos+1
    bpl !+
    lda #$ff
  !:
    sta _12+1
    rol $ff
    rol _12
    rol _12+1
    rol $ff
    rol _12
    rol _12+1
    rol $ff
    rol _12
    rol _12+1
    lda #<$e6
    sec
    sbc sprite_y
    sta sprite_y
    lda #>$e6
    sbc sprite_y+1
    sta sprite_y+1
    lda sprite_x
    sta SPRITES_XPOS+0
    lda sprite_y
    sta SPRITES_YPOS+0
    lda sprite_x+1
    sta SPRITES_XMSB
    rts
}
init: {
    .label sc = 2
    lda #1
    sta SPRITES_ENABLE
    lda #0
    sta SPRITES_EXPAND_X
    sta SPRITES_EXPAND_Y
    lda #$64
    sta SPRITES_XPOS+0
    sta SPRITES_YPOS+0
    lda #WHITE
    sta SPRITES_COLS+0
    lda #$ff & SPRITE/$40
    sta SPRITES_PTR+0
    lda #<SCREEN
    sta sc
    lda #>SCREEN
    sta sc+1
  b1:
    lda #' '
    ldy #0
    sta (sc),y
    inc sc
    bne !+
    inc sc+1
  !:
    lda sc+1
    cmp #>SCREEN+$3e8
    bne b1
    lda sc
    cmp #<SCREEN+$3e8
    bne b1
    ldx #0
  b2:
    lda #$ff
    sta SPRITE,x
    inx
    cpx #$40
    bne b2
    rts
}
