// A simple usage of the flexible sprite multiplexer routine
.pc = $801 "Basic"
:BasicUpstart(__b1)
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
  // The address of the sprite pointers on the current screen (screen+0x3f8).
  .label PLEX_SCREEN_PTR = $400+$3f8
  .label plex_show_idx = 6
  .label plex_sprite_idx = 7
  .label plex_sprite_msb = 8
  .label plex_free_next = 9
  .label framedone = $a
__b1:
  // The index in the PLEX tables of the next sprite to show
  lda #0
  sta.z plex_show_idx
  // The index the next sprite to use for showing (sprites are used round-robin)
  sta.z plex_sprite_idx
  // The MSB bit of the next sprite to use for showing
  lda #1
  sta.z plex_sprite_msb
  // The index of the sprite that is free next. Since sprites are used round-robin this moves forward each time a sprite is shown.
  lda #0
  sta.z plex_free_next
  lda #1
  sta.z framedone
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
    // The current index into the y-sinus
    .label sin_idx = 2
    lda #0
    sta.z sin_idx
  __b2:
    lda.z framedone
    cmp #0
    bne __b3
    jmp __b2
  __b3:
    lda #RED
    sta BORDERCOL
    ldx.z sin_idx
    ldy #0
  __b4:
    lda YSIN,x
    sta PLEX_YPOS,y
    txa
    axs #-[8]
    iny
    cpy #PLEX_COUNT-1+1
    bne __b4
    inc.z sin_idx
    inc BORDERCOL
    jsr plexSort
    lda #GREEN
    sta BORDERCOL
    lda #0
    sta.z framedone
    lda #$7f
    and VIC_CONTROL
    sta VIC_CONTROL
    lda #0
    sta RASTER
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
    .label nxt_idx = $b
    .label nxt_y = $c
    .label m = 3
    lda #0
    sta.z m
  __b1:
    ldy.z m
    lda PLEX_SORTED_IDX+1,y
    sta.z nxt_idx
    tay
    lda PLEX_YPOS,y
    sta.z nxt_y
    ldx.z m
    ldy PLEX_SORTED_IDX,x
    cmp PLEX_YPOS,y
    bcs __b2
  __b3:
    lda PLEX_SORTED_IDX,x
    sta PLEX_SORTED_IDX+1,x
    dex
    cpx #$ff
    beq __b4
    lda.z nxt_y
    ldy PLEX_SORTED_IDX,x
    cmp PLEX_YPOS,y
    bcc __b3
  __b4:
    inx
    lda.z nxt_idx
    sta PLEX_SORTED_IDX,x
  __b2:
    inc.z m
    lda #PLEX_COUNT-2+1
    cmp.z m
    bne __b1
    // Prepare for showing the sprites
    lda #0
    sta.z plex_show_idx
    sta.z plex_sprite_idx
    lda #1
    sta.z plex_sprite_msb
    ldx #0
  plexFreePrepare1___b1:
    lda #0
    sta PLEX_FREE_YPOS,x
    inx
    cpx #8
    bne plexFreePrepare1___b1
    sta.z plex_free_next
    rts
}
// Initialize the program
init: {
    // Set the x-positions & pointers
    .label xp = 4
    lda #VIC_DEN|VIC_RSEL|3
    sta D011
    jsr plexInit
    lda #<$20
    sta.z xp
    lda #>$20
    sta.z xp+1
    ldx #0
  __b1:
    lda #$ff&SPRITE/$40
    sta PLEX_PTR,x
    txa
    asl
    tay
    lda.z xp
    sta PLEX_XPOS,y
    lda.z xp+1
    sta PLEX_XPOS+1,y
    lda #9
    clc
    adc.z xp
    sta.z xp
    bcc !+
    inc.z xp+1
  !:
    inx
    cpx #PLEX_COUNT-1+1
    bne __b1
    // Enable & initialize sprites
    lda #$ff
    sta SPRITES_ENABLE
    ldx #0
  __b3:
    lda #GREEN
    sta SPRITES_COLS,x
    inx
    cpx #8
    bne __b3
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
  __b1:
    txa
    sta PLEX_SORTED_IDX,x
    inx
    cpx #PLEX_COUNT-1+1
    bne __b1
    rts
}
plex_irq: {
    .label __4 = $d
    lda #WHITE
    sta BORDERCOL
  __b3:
    jsr plexShowSprite
    ldy.z plex_free_next
    ldx PLEX_FREE_YPOS,y
    lda RASTER
    clc
    adc #2
    sta.z __4
    lda.z plex_show_idx
    cmp #PLEX_COUNT
    bcs __b4
    cpx.z __4
    bcc __b3
  __b4:
    lda #IRQ_RASTER
    sta IRQ_STATUS
    lda.z plex_show_idx
    cmp #PLEX_COUNT
    bcc __b1
    lda #1
    sta.z framedone
  __b2:
    lda #0
    sta BORDERCOL
    jmp $ea81
  __b1:
    stx RASTER
    jmp __b2
}
// Show the next sprite.
// plexSort() prepares showing the sprites
plexShowSprite: {
    .label plex_sprite_idx2 = $d
    lda.z plex_sprite_idx
    asl
    sta.z plex_sprite_idx2
    ldx.z plex_show_idx
    ldy PLEX_SORTED_IDX,x
    lda PLEX_YPOS,y
    ldy.z plex_sprite_idx2
    sta SPRITES_YPOS,y
    clc
    adc #$15
    ldy.z plex_free_next
    sta PLEX_FREE_YPOS,y
    ldx.z plex_free_next
    inx
    txa
    and #7
    sta.z plex_free_next
    ldx.z plex_show_idx
    ldy PLEX_SORTED_IDX,x
    lda PLEX_PTR,y
    ldx.z plex_sprite_idx
    sta PLEX_SCREEN_PTR,x
    ldy.z plex_show_idx
    lda PLEX_SORTED_IDX,y
    asl
    tax
    lda PLEX_XPOS,x
    ldy.z plex_sprite_idx2
    sta SPRITES_XPOS,y
    lda PLEX_XPOS+1,x
    cmp #0
    bne __b1
    lda #$ff
    eor.z plex_sprite_msb
    and SPRITES_XMSB
    sta SPRITES_XMSB
  __b2:
    ldx.z plex_sprite_idx
    inx
    txa
    and #7
    sta.z plex_sprite_idx
    inc.z plex_show_idx
    asl.z plex_sprite_msb
    lda.z plex_sprite_msb
    cmp #0
    bne __breturn
    lda #1
    sta.z plex_sprite_msb
  __breturn:
    rts
  __b1:
    lda SPRITES_XMSB
    ora.z plex_sprite_msb
    sta SPRITES_XMSB
    jmp __b2
}
  // The x-positions of the multiplexer sprites (0x000-0x1ff)
  PLEX_XPOS: .fill 2*PLEX_COUNT, 0
  // The y-positions of the multiplexer sprites.
  PLEX_YPOS: .fill PLEX_COUNT, 0
  // The sprite pointers for the multiplexed sprites
  PLEX_PTR: .fill PLEX_COUNT, 0
  // Indexes of the plex-sprites sorted by sprite y-position. Each call to plexSort() will fix the sorting if changes to the Y-positions have ruined it.
  PLEX_SORTED_IDX: .fill PLEX_COUNT, 0
  // Contains the Y-position where each sprite is free again. PLEX_FREE_YPOS[s] holds the Y-position where sprite s is free to use again.
  PLEX_FREE_YPOS: .fill 8, 0
  .align $40
SPRITE:
.var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)

  .align $100
YSIN:
.fill $100, round(139.5+89.5*sin(toRadians(360*i/256)))

