// A simple usage of the flexible sprite multiplexer routine
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
  // The colors of the C64
  .const BLACK = 0
  .const GREEN = 5
  // The number of sprites in the multiplexer
  .const PLEX_COUNT = $20
  // Location of screen & sprites
  .label SCREEN = $400
  .label SPRITE = $2000
  // The address of the sprite pointers on the current screen (screen+$3f8).
  .label PLEX_SCREEN_PTR = SCREEN+$3f8
  // The MSB bit of the next sprite to use for showing
  .label plex_sprite_msb = 3
  // The index of the sprite that is free next. Since sprites are used round-robin this moves forward each time a sprite is shown.
  .label plex_free_next = 5
  // The index the next sprite to use for showing (sprites are used round-robin)
  .label plex_sprite_idx = 9
  // The index in the PLEX tables of the next sprite to show
  // Prepare for showing the sprites
  .label plex_show_idx = $a
  // kickasm
main: {
    // asm
    sei
    // init()
    jsr init
    // loop()
    jsr loop
    // }
    rts
}
// The raster loop
loop: {
    // The current index into the y-sinus
    .label sin_idx = 2
    .label plexFreeNextYpos1_return = 8
    .label ss = 4
    lda #0
    sta.z sin_idx
  __b2:
    // while(*RASTER!=$ff)
    lda #$ff
    cmp RASTER
    bne __b2
    // (*BORDERCOL)++;
    inc BORDERCOL
    ldx.z sin_idx
    ldy #0
  __b4:
    // PLEX_YPOS[sy] = YSIN[y_idx]
    lda YSIN,x
    sta PLEX_YPOS,y
    // y_idx += 8
    txa
    axs #-[8]
    // for(byte sy: 0..PLEX_COUNT-1)
    iny
    cpy #PLEX_COUNT-1+1
    bne __b4
    // sin_idx +=1
    inc.z sin_idx
    // (*BORDERCOL)++;
    inc BORDERCOL
    // plexSort()
    jsr plexSort
    // *BORDERCOL = BLACK
    lda #BLACK
    sta BORDERCOL
  __b6:
    // *D011&VIC_RST8
    lda #VIC_RST8
    and D011
    // while((*D011&VIC_RST8)!=0)
    cmp #0
    bne __b6
    lda #0
    sta.z ss
    lda #1
    sta.z plex_sprite_msb
    lda #0
    sta.z plex_show_idx
    sta.z plex_sprite_idx
    sta.z plex_free_next
  // Show the sprites
  __b7:
    // *BORDERCOL = BLACK
    lda #BLACK
    sta BORDERCOL
    // return PLEX_FREE_YPOS[plex_free_next];
    ldy.z plex_free_next
    lda PLEX_FREE_YPOS,y
    sta.z plexFreeNextYpos1_return
  __b8:
    // while(*RASTER<rasterY)
    lda RASTER
    cmp.z plexFreeNextYpos1_return
    bcc __b8
    // (*BORDERCOL)++;
    inc BORDERCOL
    // plexShowSprite()
    jsr plexShowSprite
    // for( byte ss: 0..PLEX_COUNT-1)
    inc.z ss
    lda #PLEX_COUNT-1+1
    cmp.z ss
    bne __b7
    // *BORDERCOL = BLACK
    lda #BLACK
    sta BORDERCOL
    jmp __b2
}
// Show the next sprite.
// plexSort() prepares showing the sprites
plexShowSprite: {
    .label plex_sprite_idx2 = 8
    // plex_sprite_idx2 = plex_sprite_idx*2
    lda.z plex_sprite_idx
    asl
    sta.z plex_sprite_idx2
    // ypos = PLEX_YPOS[PLEX_SORTED_IDX[plex_show_idx]]
    ldx.z plex_show_idx
    ldy PLEX_SORTED_IDX,x
    lda PLEX_YPOS,y
    // SPRITES_YPOS[plex_sprite_idx2] = ypos
    ldy.z plex_sprite_idx2
    sta SPRITES_YPOS,y
    // ypos+21
    clc
    adc #$15
    // PLEX_FREE_YPOS[plex_free_next] =  ypos+21
    ldy.z plex_free_next
    sta PLEX_FREE_YPOS,y
    // plex_free_next+1
    ldx.z plex_free_next
    inx
    // plex_free_next = (plex_free_next+1)&7
    lda #7
    sax.z plex_free_next
    // PLEX_SCREEN_PTR[plex_sprite_idx] = PLEX_PTR[PLEX_SORTED_IDX[plex_show_idx]]
    ldx.z plex_show_idx
    ldy PLEX_SORTED_IDX,x
    lda PLEX_PTR,y
    ldx.z plex_sprite_idx
    sta PLEX_SCREEN_PTR,x
    // xpos_idx = PLEX_SORTED_IDX[plex_show_idx]
    ldy.z plex_show_idx
    lda PLEX_SORTED_IDX,y
    // <PLEX_XPOS[xpos_idx]
    asl
    tax
    lda PLEX_XPOS,x
    // SPRITES_XPOS[plex_sprite_idx2] = <PLEX_XPOS[xpos_idx]
    ldy.z plex_sprite_idx2
    sta SPRITES_XPOS,y
    // >PLEX_XPOS[xpos_idx]
    lda PLEX_XPOS+1,x
    // if(>PLEX_XPOS[xpos_idx]!=0)
    cmp #0
    bne __b1
    // $ff^plex_sprite_msb
    lda #$ff
    eor.z plex_sprite_msb
    // *SPRITES_XMSB &= ($ff^plex_sprite_msb)
    and SPRITES_XMSB
    sta SPRITES_XMSB
  __b2:
    // plex_sprite_idx+1
    ldx.z plex_sprite_idx
    inx
    // plex_sprite_idx = (plex_sprite_idx+1)&7
    lda #7
    sax.z plex_sprite_idx
    // plex_show_idx++;
    inc.z plex_show_idx
    // plex_sprite_msb *=2
    asl.z plex_sprite_msb
    // if(plex_sprite_msb==0)
    lda.z plex_sprite_msb
    cmp #0
    bne __b5
    lda #1
    sta.z plex_sprite_msb
    rts
  __b5:
    // }
    rts
  __b1:
    // *SPRITES_XMSB |= plex_sprite_msb
    lda SPRITES_XMSB
    ora.z plex_sprite_msb
    sta SPRITES_XMSB
    jmp __b2
}
// Ensure that the indices in PLEX_SORTED_IDX is sorted based on the y-positions in PLEX_YPOS
// Assumes that the positions are nearly sorted already (as each sprite just moves a bit)
// Uses an insertion sort:
// 1. Moves a marker (m) from the start to end of the array. Every time the marker moves forward all elements before the marker are sorted correctly.
// 2a. If the next element after the marker is larger that the current element
//     the marker can be moved forwards (as the sorting is correct).
// 2b. If the next element after the marker is smaller than the current element:
//     elements before the marker are shifted right one at a time until encountering one smaller than the current one.
//      It is then inserted at the spot. Now the marker can move forward.
plexSort: {
    .label nxt_idx = 9
    .label nxt_y = $a
    .label m = 5
    lda #0
    sta.z m
  __b1:
    // nxt_idx = PLEX_SORTED_IDX[m+1]
    ldy.z m
    lda PLEX_SORTED_IDX+1,y
    sta.z nxt_idx
    // nxt_y = PLEX_YPOS[nxt_idx]
    tay
    lda PLEX_YPOS,y
    sta.z nxt_y
    // if(nxt_y<PLEX_YPOS[PLEX_SORTED_IDX[m]])
    ldx.z m
    ldy PLEX_SORTED_IDX,x
    cmp PLEX_YPOS,y
    bcs __b2
  __b3:
    // PLEX_SORTED_IDX[s+1] = PLEX_SORTED_IDX[s]
    lda PLEX_SORTED_IDX,x
    sta PLEX_SORTED_IDX+1,x
    // s--;
    dex
    // while((s!=$ff) && (nxt_y<PLEX_YPOS[PLEX_SORTED_IDX[s]]))
    cpx #$ff
    beq __b4
    lda.z nxt_y
    ldy PLEX_SORTED_IDX,x
    cmp PLEX_YPOS,y
    bcc __b3
  __b4:
    // s++;
    inx
    // PLEX_SORTED_IDX[s] = nxt_idx
    lda.z nxt_idx
    sta PLEX_SORTED_IDX,x
  __b2:
    // for(byte m: 0..PLEX_COUNT-2)
    inc.z m
    lda #PLEX_COUNT-2+1
    cmp.z m
    bne __b1
    ldx #0
  plexFreePrepare1___b1:
    // PLEX_FREE_YPOS[s] = 0
    lda #0
    sta PLEX_FREE_YPOS,x
    // for( byte s: 0..7)
    inx
    cpx #8
    bne plexFreePrepare1___b1
    // }
    rts
}
// Initialize the program
init: {
    // Set the x-positions & pointers
    .label xp = 6
    // *D011 = VIC_DEN | VIC_RSEL | 3
    lda #VIC_DEN|VIC_RSEL|3
    sta D011
    // plexInit(SCREEN)
    jsr plexInit
    lda #<$20
    sta.z xp
    lda #>$20
    sta.z xp+1
    ldx #0
  __b1:
    // PLEX_PTR[sx] = (byte)(SPRITE/$40)
    lda #SPRITE/$40
    sta PLEX_PTR,x
    // PLEX_XPOS[sx] = xp
    txa
    asl
    tay
    lda.z xp
    sta PLEX_XPOS,y
    lda.z xp+1
    sta PLEX_XPOS+1,y
    // xp += 9
    lda #9
    clc
    adc.z xp
    sta.z xp
    bcc !+
    inc.z xp+1
  !:
    // for(byte sx: 0..PLEX_COUNT-1)
    inx
    cpx #PLEX_COUNT-1+1
    bne __b1
    // *SPRITES_ENABLE = $ff
    // Enable & initialize sprites
    lda #$ff
    sta SPRITES_ENABLE
    ldx #0
  __b3:
    // SPRITES_COLS[ss] = GREEN
    lda #GREEN
    sta SPRITES_COLS,x
    // for(byte ss: 0..7)
    inx
    cpx #8
    bne __b3
    // }
    rts
}
// Initialize the multiplexer data structures
plexInit: {
    ldx #0
  __b1:
    // PLEX_SORTED_IDX[i] = i
    txa
    sta PLEX_SORTED_IDX,x
    // for(byte i: 0..PLEX_COUNT-1)
    inx
    cpx #PLEX_COUNT-1+1
    bne __b1
    // }
    rts
}
  // The x-positions of the multiplexer sprites ($000-$1ff)
  PLEX_XPOS: .fill 2*PLEX_COUNT, 0
  // The y-positions of the multiplexer sprites.
  PLEX_YPOS: .fill PLEX_COUNT, 0
  // The sprite pointers for the multiplexed sprites
  PLEX_PTR: .fill PLEX_COUNT, 0
  // Indexes of the plex-sprites sorted by sprite y-position. Each call to plexSort() will fix the sorting if changes to the Y-positions have ruined it.
  PLEX_SORTED_IDX: .fill PLEX_COUNT, 0
  // Contains the Y-position where each sprite is free again. PLEX_FREE_YPOS[s] holds the Y-position where sprite s is free to use again.
  PLEX_FREE_YPOS: .fill 8, 0
  .align $100
YSIN:
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

