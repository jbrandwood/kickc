// Put a 2x2 font into sprites and show it on screen
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // RAM in $A000, $E000 CHAR ROM in $D000
  .const PROCPORT_RAM_CHARROM = 1
  // BASIC in $A000, I/O in $D000, KERNEL in $E000
  .const PROCPORT_BASIC_KERNEL_IO = 7
  // The address of the CHARGEN character set
  .label CHARGEN = $d000
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label SPRITES_XMSB = $d010
  .label RASTER = $d012
  .label SPRITES_ENABLE = $d015
  .label SPRITES_COLS = $d027
  .label VIC_CONTROL = $d011
  .label D018 = $d018
  // VIC II IRQ Status Register
  .label IRQ_STATUS = $d019
  // VIC II IRQ Enable Register
  .label IRQ_ENABLE = $d01a
  // Bits for the IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  // The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  .const WHITE = 1
  // The number of sprites in the multiplexer
  .const PLEX_COUNT = $20
  .label CHARSET_DEFAULT = $1000
  .label SPRITES = $3000
  .label SCREEN = $400
  // The high-value table
  .label XMOVEMENT_HI = XMOVEMENT+$100
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  // The address of the sprite pointers on the current screen (screen+0x3f8).
  .label PLEX_SCREEN_PTR = $400+$3f8
  .const toSpritePtr1_return = SPRITES/$40
  .label plex_show_idx = $d
  .label plex_sprite_idx = $e
  .label plex_sprite_msb = $f
  .label plex_free_next = $10
  .label frame_done = $11
  // The next char to use from the scroll text
  .label scroll_text_next = 4
  // Y-sine index
  .label y_sin_idx = 2
  // X-movement index
  .label x_movement_idx = 3
__bbegin:
  // plex_show_idx=0
  // The index in the PLEX tables of the next sprite to show
  lda #0
  sta.z plex_show_idx
  // plex_sprite_idx=0
  // The index the next sprite to use for showing (sprites are used round-robin)
  sta.z plex_sprite_idx
  // plex_sprite_msb=1
  // The MSB bit of the next sprite to use for showing
  lda #1
  sta.z plex_sprite_msb
  // plex_free_next = 0
  // The index of the sprite that is free next. Since sprites are used round-robin this moves forward each time a sprite is shown.
  lda #0
  sta.z plex_free_next
  // frame_done = false
  // Signal used between IRQ and main loop. Set to true when the IRQ is done showing the sprites.
  sta.z frame_done
  jsr main
  rts
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>CHARSET_DEFAULT)/4&$f
    .label s = 2
    .label __13 = $12
    // asm
    // Create 2x2 font from CHARGEN
    sei
    // *PROCPORT = PROCPORT_RAM_CHARROM
    lda #PROCPORT_RAM_CHARROM
    sta PROCPORT
    // font_2x2(CHARGEN, FONT)
    jsr font_2x2
    // *PROCPORT = PROCPORT_BASIC_KERNEL_IO
    lda #PROCPORT_BASIC_KERNEL_IO
    sta PROCPORT
    // asm
    cli
    // font_2x2_to_sprites(FONT, SPRITES, 64)
  // Convert font to sprites
    jsr font_2x2_to_sprites
    // plexInit(SCREEN)
  // Initialize the multiplexer
    jsr plexInit
    // *D018 = toD018(SCREEN, CHARSET_DEFAULT)
    // Show screen
    lda #toD0181_return
    sta D018
    ldx #0
    txa
    sta.z s
  // Set the x-positions & pointers
  __b1:
    // for(char s=0, x=0;s<PLEX_COUNT;s++,x+=8)
    lda.z s
    cmp #PLEX_COUNT
    bcc __b2
    // *SPRITES_ENABLE = 0xff
    // Enable & initialize sprites
    lda #$ff
    sta SPRITES_ENABLE
    ldx #0
  __b4:
    // SPRITES_COLS[s] = WHITE
    lda #WHITE
    sta SPRITES_COLS,x
    // for(char s: 0..7)
    inx
    cpx #8
    bne __b4
    // plex_move()
  // Move the sprites
    lda #<SCROLL_TEXT
    sta.z scroll_text_next
    lda #>SCROLL_TEXT
    sta.z scroll_text_next+1
    lda #0
    sta.z x_movement_idx
    sta.z y_sin_idx
    jsr plex_move
    // plexSort()
  // Sort the sprites by y-position
    jsr plexSort
    // asm
    // Enable the plex IRQ
    sei
    // CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_INTERRUPT
    // *VIC_CONTROL &=0x7f
    // Set raster line to 0x00
    lda #$7f
    and VIC_CONTROL
    sta VIC_CONTROL
    // *RASTER = 0x28
    lda #$28
    sta RASTER
    // *IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge any IRQ
    sta IRQ_STATUS
    // *KERNEL_IRQ = &plex_irq
    // Set the IRQ routine
    lda #<plex_irq
    sta KERNEL_IRQ
    lda #>plex_irq
    sta KERNEL_IRQ+1
    // asm
    cli
  __b6:
    // while(!frame_done)
    lda.z frame_done
    cmp #0
    bne __b7
    jmp __b6
  __b7:
    // frame_done = false
    lda #0
    sta.z frame_done
    // plex_move()
  //*BORDERCOL = RED;
  // Move the sprites
    jsr plex_move
    // plexSort()
  // Sort the sprites by y-position
    jsr plexSort
    jmp __b6
  __b2:
    // PLEX_PTR[s] = SPRITE_0+' '
    lda #toSpritePtr1_return+' '
    ldy.z s
    sta PLEX_PTR,y
    // PLEX_XPOS[s] = { XMOVEMENT_HI[x], XMOVEMENT[x] }
    tya
    asl
    tay
    lda XMOVEMENT_HI,x
    sta.z __13+1
    lda XMOVEMENT,x
    sta.z __13
    sta PLEX_XPOS,y
    lda.z __13+1
    sta PLEX_XPOS+1,y
    // x+=8
    txa
    axs #-[8]
    // for(char s=0, x=0;s<PLEX_COUNT;s++,x+=8)
    inc.z s
    jmp __b1
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
    .label nxt_idx = $14
    .label nxt_y = $15
    .label m = $c
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
    // while((s!=0xff) && (nxt_y<PLEX_YPOS[PLEX_SORTED_IDX[s]]))
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
    // for(char m: 0..PLEX_COUNT-2)
    inc.z m
    lda #PLEX_COUNT-2+1
    cmp.z m
    bne __b1
    // plex_show_idx = 0
    // Prepare for showing the sprites
    lda #0
    sta.z plex_show_idx
    // plex_sprite_idx = 0
    sta.z plex_sprite_idx
    // plex_sprite_msb = 1
    lda #1
    sta.z plex_sprite_msb
    ldx #0
  plexFreePrepare1___b1:
    // PLEX_FREE_YPOS[s] = 0
    lda #0
    sta PLEX_FREE_YPOS,x
    // for( char s: 0..7)
    inx
    cpx #8
    bne plexFreePrepare1___b1
    // plex_free_next = 0
    sta.z plex_free_next
    // }
    rts
}
// Move the plex sprites in an Y-sine and scroll them to the left.
plex_move: {
    .label y_idx = $c
    .label x_idx = $15
    .label s = $14
    .label __7 = $16
    // y_idx = y_sin_idx
    lda.z y_sin_idx
    sta.z y_idx
    // x_idx = x_movement_idx
    lda.z x_movement_idx
    sta.z x_idx
    lda #0
    sta.z s
  __b1:
    // PLEX_YPOS[s] = YSIN[y_idx]
    // Assign sine value
    ldy.z y_idx
    lda YSIN,y
    ldy.z s
    sta PLEX_YPOS,y
    // y_idx += 8
    lax.z y_idx
    axs #-[8]
    stx.z y_idx
    // PLEX_XPOS[s] = { XMOVEMENT_HI[x_idx], XMOVEMENT[x_idx] }
    tya
    asl
    tax
    ldy.z x_idx
    lda XMOVEMENT_HI,y
    sta.z __7+1
    lda XMOVEMENT,y
    sta.z __7
    sta PLEX_XPOS,x
    lda.z __7+1
    sta PLEX_XPOS+1,x
    // if(x_idx==0)
    tya
    cmp #0
    bne __b2
    // if(*scroll_text_next==0)
    ldy #0
    lda (scroll_text_next),y
    cmp #0
    bne __b3
    lda #<SCROLL_TEXT
    sta.z scroll_text_next
    lda #>SCROLL_TEXT
    sta.z scroll_text_next+1
  __b3:
    // SPRITE_0+*scroll_text_next++
    lda #toSpritePtr1_return
    clc
    ldy #0
    adc (scroll_text_next),y
    // PLEX_PTR[s] = SPRITE_0+*scroll_text_next++
    // Read next char from the scroll text
    ldy.z s
    sta PLEX_PTR,y
    // PLEX_PTR[s] = SPRITE_0+*scroll_text_next++;
    inc.z scroll_text_next
    bne !+
    inc.z scroll_text_next+1
  !:
  __b2:
    // x_idx +=8
    lax.z x_idx
    axs #-[8]
    stx.z x_idx
    // for(char s: 0..PLEX_COUNT-1)
    inc.z s
    lda #PLEX_COUNT-1+1
    cmp.z s
    bne __b1
    // y_sin_idx += 3
    lax.z y_sin_idx
    axs #-[3]
    stx.z y_sin_idx
    // x_movement_idx++;
    inc.z x_movement_idx
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
    // for(char i: 0..PLEX_COUNT-1)
    inx
    cpx #PLEX_COUNT-1+1
    bne __b1
    // }
    rts
}
// Convert a 2x2-font to sprites
// - font_2x2 The source 2x2-font
// - sprites The destination sprites
// - num_chars The number of chars to convert
font_2x2_to_sprites: {
    .const num_chars = $40
    .label __3 = $18
    .label char_right = $a
    .label sprite_idx = $15
    .label char_left = 8
    .label char_current = $16
    .label sprite = 6
    .label c = $14
    lda #<SPRITES
    sta.z sprite
    lda #>SPRITES
    sta.z sprite+1
    lda #<FONT
    sta.z char_current
    lda #>FONT
    sta.z char_current+1
    lda #0
    sta.z c
  __b1:
    // for(char c=0;c<num_chars;c++)
    lda.z c
    cmp #num_chars
    bcc __b2
    // }
    rts
  __b2:
    // char_right = char_current + 0x40*8
    lda.z char_current
    clc
    adc #<$40*8
    sta.z char_right
    lda.z char_current+1
    adc #>$40*8
    sta.z char_right+1
    lda.z char_current
    sta.z char_left
    lda.z char_current+1
    sta.z char_left+1
    lda #0
    sta.z sprite_idx
    tax
  __b3:
    // i&7
    lda #7
    sax.z __3
    // sprite[sprite_idx++] = char_left[i&7]
    ldy.z __3
    lda (char_left),y
    ldy.z sprite_idx
    sta (sprite),y
    // sprite[sprite_idx++] = char_left[i&7];
    inc.z sprite_idx
    // sprite[sprite_idx++] = char_right[i&7]
    ldy.z __3
    lda (char_right),y
    ldy.z sprite_idx
    sta (sprite),y
    // sprite[sprite_idx++] = char_right[i&7];
    iny
    // sprite[sprite_idx++] = 0x00
    lda #0
    sta (sprite),y
    // sprite[sprite_idx++] = 0x00;
    iny
    sty.z sprite_idx
    // if(i==7)
    cpx #7
    beq __b4
    // if(i==15)
    cpx #$f
    bne __b5
    lda #<FONT+' '*8
    sta.z char_right
    lda #>FONT+' '*8
    sta.z char_right+1
    lda #<FONT+' '*8
    sta.z char_left
    lda #>FONT+' '*8
    sta.z char_left+1
  __b5:
    // for(char i: 0..20)
    inx
    cpx #$15
    bne __b3
    // char_current += 8
    lda #8
    clc
    adc.z char_current
    sta.z char_current
    bcc !+
    inc.z char_current+1
  !:
    // sprite += 0x40
    lda #$40
    clc
    adc.z sprite
    sta.z sprite
    bcc !+
    inc.z sprite+1
  !:
    // for(char c=0;c<num_chars;c++)
    inc.z c
    jmp __b1
  __b4:
    // char_left = char_current + 0x80*8
    lda.z char_current
    clc
    adc #<$80*8
    sta.z char_left
    lda.z char_current+1
    adc #>$80*8
    sta.z char_left+1
    // char_right = char_current + 0xc0*8
    lda.z char_current
    clc
    adc #<$c0*8
    sta.z char_right
    lda.z char_current+1
    adc #>$c0*8
    sta.z char_right+1
    jmp __b5
}
// Create a 2x2-font by doubling all pixels of the 64 first chars
// The font layout is:
// - 0x00 - 0x3f Upper left glyphs
// - 0x40 - 0x7f Upper right glyphs
// - 0x80 - 0xbf Lower left glyphs
// - 0xc0 - 0xff Lower right glyphs
font_2x2: {
    .label __5 = $12
    .label __7 = $12
    .label next_2x2_left = $16
    .label next_2x2_right = $a
    .label glyph_bits = $c
    .label glyph_bits_2x2 = $12
    .label l2 = $18
    .label l = $15
    .label next_2x2_left_1 = 8
    .label next_2x2 = $16
    .label next_original = 6
    .label c = $14
    lda #0
    sta.z c
    lda #<CHARGEN
    sta.z next_original
    lda #>CHARGEN
    sta.z next_original+1
    lda #<FONT
    sta.z next_2x2_left
    lda #>FONT
    sta.z next_2x2_left+1
  __b1:
    // next_2x2_right = next_2x2 + 0x40*8
    lda.z next_2x2_left
    clc
    adc #<$40*8
    sta.z next_2x2_right
    lda.z next_2x2_left+1
    adc #>$40*8
    sta.z next_2x2_right+1
    lda.z next_2x2_left
    sta.z next_2x2_left_1
    lda.z next_2x2_left+1
    sta.z next_2x2_left_1+1
    lda #0
    sta.z l2
    sta.z l
  __b2:
    // glyph_bits = next_original[l]
    ldy.z l
    lda (next_original),y
    sta.z glyph_bits
    ldy #0
    tya
    sta.z glyph_bits_2x2
    sta.z glyph_bits_2x2+1
  __b3:
    // glyph_bits&0x80
    lda #$80
    and.z glyph_bits
    // (glyph_bits&0x80)?1uc:0uc
    cmp #0
    bne __b4
    ldx #0
    jmp __b5
  __b4:
    // (glyph_bits&0x80)?1uc:0uc
    ldx #1
  __b5:
    // glyph_bits_2x2<<1
    asl.z __5
    rol.z __5+1
    // glyph_bits_2x2 = glyph_bits_2x2<<1|glyph_bit
    txa
    ora.z glyph_bits_2x2
    sta.z glyph_bits_2x2
    // glyph_bits_2x2<<1
    asl.z __7
    rol.z __7+1
    // glyph_bits_2x2 = glyph_bits_2x2<<1|glyph_bit
    txa
    ora.z glyph_bits_2x2
    sta.z glyph_bits_2x2
    // glyph_bits <<= 1
    // Move to next bit
    asl.z glyph_bits
    // for(char b: 0..7)
    iny
    cpy #8
    bne __b3
    // >glyph_bits_2x2
    lda.z glyph_bits_2x2+1
    // next_2x2_left[l2] = >glyph_bits_2x2
    // Put the generated 2x2-line into the 2x2-font twice
    ldy.z l2
    sta (next_2x2_left_1),y
    // l2+1
    iny
    // next_2x2_left[l2+1] = >glyph_bits_2x2
    sta (next_2x2_left_1),y
    // <glyph_bits_2x2
    lda.z glyph_bits_2x2
    // next_2x2_right[l2] = <glyph_bits_2x2
    ldy.z l2
    sta (next_2x2_right),y
    // l2+1
    iny
    // next_2x2_right[l2+1] = <glyph_bits_2x2
    sta (next_2x2_right),y
    // l2 += 2
    lda.z l2
    clc
    adc #2
    sta.z l2
    // if(l2==8)
    lda #8
    cmp.z l2
    bne __b8
    // next_2x2_left = next_2x2 + 0x80*8
    lda.z next_2x2_left
    clc
    adc #<$80*8
    sta.z next_2x2_left_1
    lda.z next_2x2_left+1
    adc #>$80*8
    sta.z next_2x2_left_1+1
    // next_2x2_right = next_2x2 + 0xc0*8
    lda.z next_2x2_left
    clc
    adc #<$c0*8
    sta.z next_2x2_right
    lda.z next_2x2_left+1
    adc #>$c0*8
    sta.z next_2x2_right+1
    lda #0
    sta.z l2
  __b8:
    // for(char l: 0..7)
    inc.z l
    lda #8
    cmp.z l
    bne __b2
    // next_2x2 += 8
    clc
    adc.z next_2x2
    sta.z next_2x2
    bcc !+
    inc.z next_2x2+1
  !:
    // next_original += 8
    lda #8
    clc
    adc.z next_original
    sta.z next_original
    bcc !+
    inc.z next_original+1
  !:
    // for(char c: 0..0x3f)
    inc.z c
    lda #$40
    cmp.z c
    beq !__b1+
    jmp __b1
  !__b1:
    // }
    rts
}
// Show sprites from the multiplexer, rescheduling the IRQ as many times as needed
plex_irq: {
    .label __4 = $19
    // asm
    sei
  __b3:
    // plexShowSprite()
    jsr plexShowSprite
    // return PLEX_FREE_YPOS[plex_free_next];
    ldy.z plex_free_next
    ldx PLEX_FREE_YPOS,y
    // *RASTER+3
    lda #3
    clc
    adc RASTER
    sta.z __4
    // while (plex_show_idx < PLEX_COUNT && rasterY < *RASTER+3)
    lda.z plex_show_idx
    cmp #PLEX_COUNT
    bcs __b4
    cpx.z __4
    bcc __b3
  __b4:
    // if (plex_show_idx<PLEX_COUNT)
    lda.z plex_show_idx
    cmp #PLEX_COUNT
    bcc __b1
    // *RASTER = 0x28
    // Reset the raster IRQ to the top of the screen
    lda #$28
    sta RASTER
    // frame_done = true
    // Signal that the IRQ is done showing sprites
    lda #1
    sta.z frame_done
  __b2:
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // asm
    //*BORDERCOL = 0;
    cli
    // }
    jmp $ea81
  __b1:
    // *RASTER = rasterY
    // Set raster IRQ line to the next sprite Y-position
    stx RASTER
    jmp __b2
}
// Show the next sprite.
// plexSort() prepares showing the sprites
plexShowSprite: {
    .label plex_sprite_idx2 = $1a
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
    tya
    clc
    adc #1
    // (plex_free_next+1)&7
    and #7
    // plex_free_next = (plex_free_next+1)&7
    sta.z plex_free_next
    // PLEX_SCREEN_PTR[plex_sprite_idx] = PLEX_PTR[PLEX_SORTED_IDX[plex_show_idx]]
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
    // 0xff^plex_sprite_msb
    lda #$ff
    eor.z plex_sprite_msb
    // *SPRITES_XMSB &= (0xff^plex_sprite_msb)
    and SPRITES_XMSB
    sta SPRITES_XMSB
  __b2:
    // plex_sprite_idx+1
    ldx.z plex_sprite_idx
    inx
    // (plex_sprite_idx+1)&7
    txa
    and #7
    // plex_sprite_idx = (plex_sprite_idx+1)&7
    sta.z plex_sprite_idx
    // plex_show_idx++;
    inc.z plex_show_idx
    // plex_sprite_msb <<=1
    asl.z plex_sprite_msb
    // if(plex_sprite_msb==0)
    lda.z plex_sprite_msb
    cmp #0
    bne __breturn
    // plex_sprite_msb = 1
    lda #1
    sta.z plex_sprite_msb
  __breturn:
    // }
    rts
  __b1:
    // *SPRITES_XMSB |= plex_sprite_msb
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
  //char FONT[0x0800] = kickasm(resource "elefont.bin") {{
  //	.import binary "elefont.bin"
  //}};
  FONT: .fill $800, 0
  .align $100
YSIN:
.fill $100, round(142+89.5*sin(toRadians(360*i/256)))

  .align $100
XMOVEMENT:
//.lohifill $100, round(344-i*344/$100-86*sin(toRadians(360*i/$100)))
    //.lohifill $100, round(344-i*344/$100-129*sin(toRadians(360*i/$100)))
    .lohifill $100, round(344-i*344/$100 -86*sin(toRadians(360*i/$100)) -43*sin(toRadians(360*i/$80)))
    //.lohifill $100, round(344-i*344/$100-86*sin(toRadians(360*i/$80)))

  // The scroll text
  SCROLL_TEXT: .text "camelot presents a spanking new contribution to the always hungry c64 scene. in this time of the corona virus we have chosen to direct our efforts towards the safe haven of coding, pixeling and composing for our beloved old breadbin.      "
  .byte 0
