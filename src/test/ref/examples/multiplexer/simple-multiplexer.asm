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
  .const VIC_RST8 = $80
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  //  The colors of the C64
  .const BLACK = 0
  .const GREEN = 5
  //  The number of sprites in the multiplexer
  .const PLEX_COUNT = $20
  .label SCREEN = $400
  .label SPRITE = $2000
  .label YSIN = $2100
  .label PLEX_SCREEN_PTR = SCREEN+$3f8
  .label plex_free_next = 3
  .label plex_show_idx = 4
  .label plex_sprite_msb = 5
main: {
    sei
    jsr init
    jsr loop
    rts
}
//  The raster loop
loop: {
    .label sin_idx = 2
    .label plexFreeNextYpos1_return = 9
    .label ss = 6
    lda #0
    sta sin_idx
  b4:
    lda RASTER
    cmp #$ff
    bne b4
    inc BORDERCOL
    ldy sin_idx
    ldx #0
  b7:
    lda YSIN,y
    sta PLEX_YPOS,x
    tya
    clc
    adc #8
    tay
    inx
    cpx #PLEX_COUNT-1+1
    bne b7
    inc sin_idx
    inc BORDERCOL
    jsr plexSort
    lda #BLACK
    sta BORDERCOL
  b8:
    lda D011
    and #VIC_RST8
    cmp #0
    bne b8
    lda #0
    sta ss
    lda #1
    sta plex_sprite_msb
    lda #0
    sta plex_show_idx
    tax
    sta plex_free_next
  b11:
    lda #BLACK
    sta BORDERCOL
    ldy plex_free_next
    lda PLEX_FREE_YPOS,y
    sta plexFreeNextYpos1_return
  b12:
    lda RASTER
    cmp plexFreeNextYpos1_return
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
//  Show the next sprite.
//  plexSort() prepares showing the sprites
plexShowSprite: {
    .label plex_sprite_idx2 = 9
    .label xpos_idx = $a
    txa
    asl
    sta plex_sprite_idx2
    ldy plex_show_idx
    lda PLEX_SORTED_IDX,y
    tay
    lda PLEX_YPOS,y
    ldy plex_sprite_idx2
    sta SPRITES_YPOS,y
    clc
    adc #$15
    ldy plex_free_next
    sta PLEX_FREE_YPOS,y
    tya
    clc
    adc #1
    and #7
    sta plex_free_next
    ldy plex_show_idx
    lda PLEX_SORTED_IDX,y
    tay
    lda PLEX_PTR,y
    sta PLEX_SCREEN_PTR,x
    ldy plex_show_idx
    lda PLEX_SORTED_IDX,y
    asl
    sta xpos_idx
    tay
    lda PLEX_XPOS,y
    ldy plex_sprite_idx2
    sta SPRITES_XPOS,y
    ldy xpos_idx
    lda PLEX_XPOS+1,y
    cmp #0
    bne b1
    lda plex_sprite_msb
    eor #$ff
    and SPRITES_XMSB
    sta SPRITES_XMSB
  b2:
    inx
    txa
    and #7
    tax
    inc plex_show_idx
    asl plex_sprite_msb
    lda plex_sprite_msb
    cmp #0
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
//  Ensure that the indices in PLEX_SORTED_IDX is sorted based on the y-positions in PLEX_YPOS
//  Assumes that the positions are nearly sorted already (as each sprite just moves a bit)
//  Uses an insertion sort:
//  1. Moves a marker (m) from the start to end of the array. Every time the marker moves forward all elements before the marker are sorted correctly.
//  2a. If the next element after the marker is larger that the current element
//      the marker can be moved forwards (as the sorting is correct).
//  2b. If the next element after the marker is smaller than the current element:
//      elements before the marker are shifted right one at a time until encountering one smaller than the current one.
//       It is then inserted at the spot. Now the marker can move forward.
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
    bne b8
  b5:
    inx
    lda nxt_idx
    sta PLEX_SORTED_IDX,x
  b2:
    inc m
    lda m
    cmp #PLEX_COUNT-2+1
    bne b1
    ldx #0
  plexFreePrepare1_b1:
    lda #0
    sta PLEX_FREE_YPOS,x
    inx
    cpx #8
    bne plexFreePrepare1_b1
    rts
  b8:
    lda nxt_y
    ldy PLEX_SORTED_IDX,x
    cmp PLEX_YPOS,y
    bcc b3
    jmp b5
}
//  Initialize the program
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
    adc #<9
    sta xp
    lda xp+1
    adc #>9
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
//  Initialize the multiplexer data structures
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
  //  Contains the Y-position where each sprite is free again. PLEX_FREE_YPOS[s] holds the Y-position where sprite s is free to use again.
  PLEX_FREE_YPOS: .fill 8, 0
  //  The x-positions of the multiplexer sprites ($000-$1ff)
  PLEX_XPOS: .fill 2*PLEX_COUNT, 0
  //  The y-positions of the multiplexer sprites.
  PLEX_YPOS: .fill PLEX_COUNT, 0
  //  The sprite pointers for the multiplexed sprites
  PLEX_PTR: .fill PLEX_COUNT, 0
  //  Indexes of the plex-sprites sorted by sprite y-position. Each call to plexSort() will fix the sorting if changes to the Y-positions have ruined it.
  PLEX_SORTED_IDX: .fill PLEX_COUNT, 0
.pc = YSIN "YSIN"
  .var min = 50
    .var max = 250-21
    .var ampl = max-min;
    .for(var i=0;i<256;i++)
        .byte round(min+(ampl/2)+(ampl/2)*sin(toRadians(360*i/256)))

.pc = SPRITE "SPRITE"
  .var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)

