// A simple usage of the flexible sprite multiplexer routine
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label SPRITES_XMSB = $d010
  .label RASTER = $d012
  .label SPRITES_ENABLE = $d015
  .label BORDERCOL = $d020
  .label SPRITES_COLS = $d027
  .label VIC_CONTROL = $d011
  .label D011 = $d011
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  // VIC II IRQ Status Register
  .label IRQ_STATUS = $d019
  // VIC II IRQ Enable Register
  .label IRQ_ENABLE = $d01a
  // Bits for the IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  // CIA#1 Interrupt Status & Control Register
  .label CIA1_INTERRUPT = $dc0d
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  // The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  .const WHITE = 1
  .const RED = 2
  .const GREEN = 5
  // The number of sprites in the multiplexer
  .const PLEX_COUNT = $20
  .label SPRITE = $2000
  .label YSIN = $2100
  // The address of the sprite pointers on the current screen (screen+$3f8).
  .label PLEX_SCREEN_PTR = $400+$3f8
  .label plex_show_idx = 7
  .label plex_sprite_idx = 6
  .label plex_sprite_msb = 8
  .label plex_free_next = 9
  .label framedone = $a
bbegin:
  // The index in the PLEX tables of the next sprite to show
  lda #0
  sta plex_show_idx
  // The index the next sprite to use for showing (sprites are used round-robin)
  sta plex_sprite_idx
  // The MSB bit of the next sprite to use for showing
  lda #1
  sta plex_sprite_msb
  // The index of the sprite that is free next. Since sprites are used round-robin this moves forward each time a sprite is shown.
  lda #0
  sta plex_free_next
  lda #1
  sta framedone
  jsr main
  rts
main: {
    sei
    jsr init
    jsr loop
    rts
}
// The raster loop
loop: {
    .label sin_idx = 2
    lda #0
    sta sin_idx
  b2:
    lda framedone
    cmp #0
    bne b3
    jmp b2
  b3:
    lda #RED
    sta BORDERCOL
    ldx sin_idx
    ldy #0
  b4:
    lda YSIN,x
    sta PLEX_YPOS,y
    txa
    axs #-[8]
    iny
    cpy #PLEX_COUNT-1+1
    bne b4
    inc sin_idx
    inc BORDERCOL
    jsr plexSort
    lda #GREEN
    sta BORDERCOL
    lda #0
    sta framedone
    lda #$7f
    and VIC_CONTROL
    sta VIC_CONTROL
    lda #0
    sta RASTER
    jmp b2
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
    .label nxt_idx = $b
    .label nxt_y = $c
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
    bne b6
  b4:
    inx
    lda nxt_idx
    sta PLEX_SORTED_IDX,x
  b2:
    inc m
    lda #PLEX_COUNT-2+1
    cmp m
    bne b1
    // Prepare for showing the sprites
    lda #0
    sta plex_show_idx
    sta plex_sprite_idx
    lda #1
    sta plex_sprite_msb
    ldx #0
  plexFreePrepare1_b1:
    lda #0
    sta PLEX_FREE_YPOS,x
    inx
    cpx #8
    bne plexFreePrepare1_b1
    sta plex_free_next
    rts
  b6:
    lda nxt_y
    ldy PLEX_SORTED_IDX,x
    cmp PLEX_YPOS,y
    bcc b3
    jmp b4
}
// Initialize the program
init: {
    .label xp = 4
    lda #VIC_DEN|VIC_RSEL|3
    sta D011
    jsr plexInit
    lda #$20
    sta xp
    lda #0
    sta xp+1
    tax
  b1:
    lda #SPRITE/$40
    sta PLEX_PTR,x
    txa
    asl
    tay
    lda xp
    sta PLEX_XPOS,y
    lda xp+1
    sta PLEX_XPOS+1,y
    lda #9
    clc
    adc xp
    sta xp
    bcc !+
    inc xp+1
  !:
    inx
    cpx #PLEX_COUNT-1+1
    bne b1
    // Enable & initialize sprites
    lda #$ff
    sta SPRITES_ENABLE
    ldx #0
  b3:
    lda #GREEN
    sta SPRITES_COLS,x
    inx
    cpx #8
    bne b3
    // enable the interrupt
    sei
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    sta IRQ_STATUS
    lda #<plex_irq
    sta KERNEL_IRQ
    lda #>plex_irq
    sta KERNEL_IRQ+1
    cli
    rts
}
// Initialize the multiplexer data structures
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
plex_irq: {
    .label _4 = $d
    lda #WHITE
    sta BORDERCOL
  b3:
    jsr plexShowSprite
    ldy plexShowSprite.plexFreeAdd1__2
    ldx PLEX_FREE_YPOS,y
    lda RASTER
    clc
    adc #2
    sta _4
    lda plex_show_idx
    cmp #PLEX_COUNT
    bcc b7
  b4:
    lda #IRQ_RASTER
    sta IRQ_STATUS
    lda plex_show_idx
    cmp #PLEX_COUNT
    bcc b1
    lda #1
    sta framedone
  b2:
    lda #0
    sta BORDERCOL
    jmp $ea81
  b1:
    stx RASTER
    jmp b2
  b7:
    cpx _4
    bcc b3
    jmp b4
}
// Show the next sprite.
// plexSort() prepares showing the sprites
plexShowSprite: {
    .label _6 = 6
    .label plex_sprite_idx2 = $d
    .label plexFreeAdd1__2 = 9
    lda plex_sprite_idx
    asl
    sta plex_sprite_idx2
    ldx plex_show_idx
    ldy PLEX_SORTED_IDX,x
    lda PLEX_YPOS,y
    ldy plex_sprite_idx2
    sta SPRITES_YPOS,y
    clc
    adc #$15
    ldy plex_free_next
    sta PLEX_FREE_YPOS,y
    ldx plex_free_next
    inx
    lda #7
    sax plexFreeAdd1__2
    ldx plex_show_idx
    ldy PLEX_SORTED_IDX,x
    lda PLEX_PTR,y
    ldx plex_sprite_idx
    sta PLEX_SCREEN_PTR,x
    ldy plex_show_idx
    ldx PLEX_SORTED_IDX,y
    txa
    asl
    tay
    lda PLEX_XPOS,y
    ldy plex_sprite_idx2
    sta SPRITES_XPOS,y
    txa
    asl
    tay
    lda PLEX_XPOS+1,y
    cmp #0
    bne b1
    lda #$ff
    eor plex_sprite_msb
    and SPRITES_XMSB
    sta SPRITES_XMSB
  b2:
    ldx plex_sprite_idx
    inx
    lda #7
    sax _6
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
  // Contains the Y-position where each sprite is free again. PLEX_FREE_YPOS[s] holds the Y-position where sprite s is free to use again.
  PLEX_FREE_YPOS: .fill 8, 0
  // The x-positions of the multiplexer sprites ($000-$1ff)
  PLEX_XPOS: .fill 2*PLEX_COUNT, 0
  // The y-positions of the multiplexer sprites.
  PLEX_YPOS: .fill PLEX_COUNT, 0
  // The sprite pointers for the multiplexed sprites
  PLEX_PTR: .fill PLEX_COUNT, 0
  // Indexes of the plex-sprites sorted by sprite y-position. Each call to plexSort() will fix the sorting if changes to the Y-positions have ruined it.
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

