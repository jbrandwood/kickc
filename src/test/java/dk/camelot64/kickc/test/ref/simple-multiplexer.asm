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
  .label D011 = $d011
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .const BLACK = 0
  .const GREEN = 5
  .const PLEX_COUNT = $18
  .label SPRITE = $2000
  .label SCREEN = $400
  .label YSIN = $2100
  .label PLEX_SCREEN_PTR = SCREEN+$3f8
  .label plex_sprite_idx = 4
  .label plex_show_idx = 3
  .label plex_sprite_msb = 5
  jsr main
main: {
    sei
    jsr init
    jsr loop
    rts
}
loop: {
    .label sin_idx = 2
    .label rasterY = 9
    .label ss = 6
    lda #0
    sta sin_idx
  b4:
    lda RASTER
    cmp #$ff
    bne b4
    inc BORDERCOL
    ldx sin_idx
    ldy #0
  b7:
    lda YSIN,x
    sta PLEX_YPOS,y
    txa
    clc
    adc #$a
    tax
    iny
    cpy #PLEX_COUNT-1+1
    bne b7
    inc sin_idx
    inc BORDERCOL
    jsr plexSort
    lda #BLACK
    sta BORDERCOL
  b8:
    lda D011
    and #$80
    cmp #0
    bne b8
    lda #0
    sta ss
    lda #1
    sta plex_sprite_msb
    lda #0
    sta plex_sprite_idx
    sta plex_show_idx
  b11:
    lda #BLACK
    sta BORDERCOL
    ldy plex_show_idx
    lda PLEX_SORTED_IDX,y
    tay
    lda PLEX_YPOS,y
    sec
    sbc #8
    sta rasterY
  b12:
    lda RASTER
    cmp rasterY
    bcc b12
    inc BORDERCOL
    jsr plexShowSprite
    inc ss
    lda ss
    cmp #PLEX_COUNT-1+1
    bne b11
    lda #BLACK
    sta BORDERCOL
    jmp b4
}
plexShowSprite: {
    lda plex_sprite_idx
    asl
    tay
    ldx plex_show_idx
    lda PLEX_SORTED_IDX,x
    tax
    lda PLEX_YPOS,x
    sta SPRITES_YPOS,y
    ldx plex_show_idx
    lda PLEX_SORTED_IDX,x
    tax
    lda PLEX_PTR,x
    ldx plex_sprite_idx
    sta PLEX_SCREEN_PTR,x
    ldx plex_show_idx
    lda PLEX_SORTED_IDX,x
    asl
    tax
    lda PLEX_XPOS,x
    sta SPRITES_XPOS,y
    lda PLEX_XPOS+1,x
    cmp #0
    bne b1
    lda plex_sprite_msb
    eor #$ff
    and SPRITES_XMSB
    sta SPRITES_XMSB
  b2:
    lda plex_sprite_idx
    clc
    adc #1
    and #7
    sta plex_sprite_idx
    inc plex_show_idx
    asl plex_sprite_msb
    lda plex_sprite_msb
    bne breturn
    lda #1
    sta plex_sprite_msb
  breturn:
    rts
  b1:
    lda SPRITES_XMSB
    ora plex_sprite_msb
    sta SPRITES_XMSB
    jmp b2
}
plexSort: {
    .label nxt_idx = 4
    .label nxt_y = 5
    .label m = 3
    lda #0
    sta m
  b1:
    ldy m
    lda PLEX_SORTED_IDX+1,y
    sta nxt_idx
    tay
    lda PLEX_YPOS,y
    sta nxt_y
    ldx m
    ldy PLEX_SORTED_IDX,x
    cmp PLEX_YPOS,y
    bcs b2
  b3:
    lda PLEX_SORTED_IDX,x
    sta PLEX_SORTED_IDX+1,x
    dex
    cpx #$ff
    bne b7
  b5:
    inx
    lda nxt_idx
    sta PLEX_SORTED_IDX,x
  b2:
    inc m
    lda m
    cmp #PLEX_COUNT-2+1
    bne b1
    rts
  b7:
    lda nxt_y
    ldy PLEX_SORTED_IDX,x
    cmp PLEX_YPOS,y
    bcc b3
    jmp b5
}
init: {
    .label xp = 7
    lda #VIC_DEN|VIC_RSEL|3
    sta D011
    jsr plexInit
    lda #<$20
    sta xp
    lda #>$20
    sta xp+1
    ldx #0
  b1:
    lda #$ff&SPRITE/$40
    sta PLEX_PTR,x
    txa
    asl
    tay
    lda xp
    sta PLEX_XPOS,y
    lda xp+1
    sta PLEX_XPOS+1,y
    clc
    lda xp
    adc #<$c
    sta xp
    lda xp+1
    adc #>$c
    sta xp+1
    inx
    cpx #PLEX_COUNT-1+1
    bne b1
    lda #$ff
    sta SPRITES_ENABLE
    ldx #0
  b2:
    lda #GREEN
    sta SPRITES_COLS,x
    inx
    cpx #8
    bne b2
    rts
}
plexInit: {
    ldx #0
  b1:
    txa
    sta PLEX_SORTED_IDX,x
    inx
    cpx #PLEX_COUNT-1+1
    bne b1
    rts
}
  PLEX_XPOS: .fill 2*PLEX_COUNT, 0
  PLEX_YPOS: .fill PLEX_COUNT, 0
  PLEX_PTR: .fill PLEX_COUNT, 0
  PLEX_SORTED_IDX: .fill PLEX_COUNT, 0
.pc = YSIN "Inline"
  .var min = 50
    .var max = 250-21
    .var ampl = max-min;
    .for(var i=0;i<256;i++)
        .byte round(min+(ampl/2)+(ampl/2)*sin(toRadians(360*i/256)))

.pc = SPRITE "Inline"
  .var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
.for (var y=0; y<21; y++)
    .for (var x=0;x<3; x++)
        .byte pic.getSinglecolorByte(x,y)

