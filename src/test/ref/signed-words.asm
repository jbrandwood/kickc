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
    sta.z yvel_init
    lda #>$64
    sta.z yvel_init+1
    lda #<$c8
    sta.z xvel
    lda #>$c8
    sta.z xvel+1
    lda #<0
    sta.z ypos
    sta.z ypos+1
    sta.z xpos
    sta.z xpos+1
    lda #<$64
    sta.z yvel_12
    lda #>$64
    sta.z yvel_12+1
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
    lda.z ypos+1
    bpl b1
    sec
    lda #0
    sbc.z xvel
    sta.z xvel
    lda #0
    sbc.z xvel+1
    sta.z xvel+1
    lda.z yvel_init
    sec
    sbc #$a
    sta.z yvel_init
    lda.z yvel_init+1
    sbc #>$a
    sta.z yvel_init+1
    lda.z yvel_init
    cmp #<-$c8
    lda.z yvel_init+1
    sbc #>-$c8
    bvc !+
    eor #$80
  !:
    bpl b3
    lda #<$c8
    sta.z yvel
    lda #>$c8
    sta.z yvel+1
  b3:
    lda.z yvel
    sta.z yvel_21
    lda.z yvel+1
    sta.z yvel_21+1
    lda #<0
    sta.z ypos
    sta.z ypos+1
    sta.z xpos
    sta.z xpos+1
  b1:
    clc
    lda.z yvel_10
    adc #<g
    sta.z yvel_10
    lda.z yvel_10+1
    adc #>g
    sta.z yvel_10+1
    lda.z xpos
    clc
    adc.z xvel
    sta.z xpos
    lda.z xpos+1
    adc.z xvel+1
    sta.z xpos+1
    lda.z ypos
    clc
    adc.z yvel_10
    sta.z ypos
    lda.z ypos+1
    adc.z yvel_10+1
    sta.z ypos+1
    lda.z xpos
    sta.z $ff
    lda.z xpos+1
    sta.z _5
    lda #0
    bit.z xpos+1
    bpl !+
    lda #$ff
  !:
    sta.z _5+1
    rol.z $ff
    rol.z _5
    rol.z _5+1
    clc
    lda.z sprite_x
    adc #<$a0
    sta.z sprite_x
    lda.z sprite_x+1
    adc #>$a0
    sta.z sprite_x+1
    lda.z ypos
    sta.z $ff
    lda.z ypos+1
    sta.z _7
    lda #0
    bit.z ypos+1
    bpl !+
    lda #$ff
  !:
    sta.z _7+1
    rol.z $ff
    rol.z _7
    rol.z _7+1
    rol.z $ff
    rol.z _7
    rol.z _7+1
    rol.z $ff
    rol.z _7
    rol.z _7+1
    lda #<$e6
    sec
    sbc.z sprite_y
    sta.z sprite_y
    lda #>$e6
    sbc.z sprite_y+1
    sta.z sprite_y+1
    lda.z sprite_x
    sta SPRITES_XPOS
    lda.z sprite_y
    sta SPRITES_YPOS
    lda.z sprite_x+1
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
    sta.z sc
    lda #>SCREEN
    sta.z sc+1
  b2:
    lda #' '
    ldy #0
    sta (sc),y
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    lda.z sc+1
    cmp #>SCREEN+$3e8
    bne b2
    lda.z sc
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
