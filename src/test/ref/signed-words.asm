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
  .label yvel_init = 2
  .label yvel = 2
  .label yvel_9 = 4
  .label xpos = 6
  .label ypos = 8
  .label yvel_10 = 4
  .label xvel = $a
  .label yvel_12 = 4
  .label yvel_21 = 4
main: {
    jsr init
    lda #<$64
    sta yvel_init
    lda #>$64
    sta yvel_init+1
    lda #<$c8
    sta xvel
    lda #>$c8
    sta xvel+1
    lda #<0
    sta ypos
    sta ypos+1
    sta xpos
    sta xpos+1
    lda #<$64
    sta yvel_12
    lda #>$64
    sta yvel_12+1
  b1:
    lda #$ff
    cmp RASTER
    bne b1
    jsr anim
    jmp b1
}
anim: {
    .label _5 = $c
    .label _7 = $e
    .label sprite_x = $c
    .label sprite_y = $e
    lda ypos+1
    bpl b1
    sec
    lda #0
    sbc xvel
    sta xvel
    lda #0
    sbc xvel+1
    sta xvel+1
    lda yvel_init
    sec
    sbc #$a
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
    bpl b3
    lda #<$c8
    sta yvel
    lda #>$c8
    sta yvel+1
  b3:
    lda yvel
    sta yvel_21
    lda yvel+1
    sta yvel_21+1
    lda #<0
    sta ypos
    sta ypos+1
    sta xpos
    sta xpos+1
  b1:
    clc
    lda yvel_10
    adc #<g
    sta yvel_10
    lda yvel_10+1
    adc #>g
    sta yvel_10+1
    lda xpos
    clc
    adc xvel
    sta xpos
    lda xpos+1
    adc xvel+1
    sta xpos+1
    lda ypos
    clc
    adc yvel_10
    sta ypos
    lda ypos+1
    adc yvel_10+1
    sta ypos+1
    lda xpos
    sta $ff
    lda xpos+1
    sta _5
    lda #0
    bit xpos+1
    bpl !+
    lda #$ff
  !:
    sta _5+1
    rol $ff
    rol _5
    rol _5+1
    clc
    lda sprite_x
    adc #<$a0
    sta sprite_x
    lda sprite_x+1
    adc #>$a0
    sta sprite_x+1
    lda ypos
    sta $ff
    lda ypos+1
    sta _7
    lda #0
    bit ypos+1
    bpl !+
    lda #$ff
  !:
    sta _7+1
    rol $ff
    rol _7
    rol _7+1
    rol $ff
    rol _7
    rol _7+1
    rol $ff
    rol _7
    rol _7+1
    lda #<$e6
    sec
    sbc sprite_y
    sta sprite_y
    lda #>$e6
    sbc sprite_y+1
    sta sprite_y+1
    lda sprite_x
    sta SPRITES_XPOS
    lda sprite_y
    sta SPRITES_YPOS
    lda sprite_x+1
    sta SPRITES_XMSB
    rts
}
// Fill and show a sprite, clear the screen
init: {
    .label sc = $a
    lda #1
    sta SPRITES_ENABLE
    lda #0
    sta SPRITES_EXPAND_X
    sta SPRITES_EXPAND_Y
    lda #$64
    sta SPRITES_XPOS
    sta SPRITES_YPOS
    lda #WHITE
    sta SPRITES_COLS
    lda #SPRITE/$40
    sta SPRITES_PTR
    lda #<SCREEN
    sta sc
    lda #>SCREEN
    sta sc+1
  b2:
    lda #' '
    ldy #0
    sta (sc),y
    inc sc
    bne !+
    inc sc+1
  !:
    lda sc+1
    cmp #>SCREEN+$3e8
    bne b2
    lda sc
    cmp #<SCREEN+$3e8
    bne b2
    ldx #0
  b3:
    lda #$ff
    sta SPRITE,x
    inx
    cpx #$40
    bne b3
    rts
}
