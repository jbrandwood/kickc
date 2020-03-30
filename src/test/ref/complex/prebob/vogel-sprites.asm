// Same animation using a multiplexer
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
  // CIA#1 Port A: keyboard matrix columns and joystick #2
  .label CIA1_PORT_A = $dc00
  // CIA#1 Port B: keyboard matrix rows and joystick #1.
  .label CIA1_PORT_B = $dc01
  // The colors of the C64
  .const BLACK = 0
  .const GREEN = 5
  // The number of sprites in the multiplexer
  .const PLEX_COUNT = $20
  .const KEY_SPACE = $3c
  // The BASIC screen
  .label SCREEN = $400
  // The number of BOBs to render
  .const NUM_BOBS = $10
  .label COS = SIN+$40
  // The address of the sprite pointers on the current screen (screen+$3f8).
  .label PLEX_SCREEN_PTR = SCREEN+$3f8
  // The MSB bit of the next sprite to use for showing
  .label plex_sprite_msb = 5
  // The index of the sprite that is free next. Since sprites are used round-robin this moves forward each time a sprite is shown.
  .label plex_free_next = 2
  // The index the next sprite to use for showing (sprites are used round-robin)
  .label plex_sprite_idx = 3
  // The index in the PLEX tables of the next sprite to show
  // Prepare for showing the sprites
  .label plex_show_idx = 4
main: {
    // asm
    sei
    // init()
    jsr init
    // loop()
    jsr loop
    // exit()
    jsr exit
    // asm
    cli
    // }
    rts
}
// Exit the program
exit: {
  __b1:
  // Wait for space release
    // keyboard_key_pressed(KEY_SPACE)
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_SPACE)
    // while(keyboard_key_pressed(KEY_SPACE))
    cmp #0
    bne __b1
    // }
    rts
}
// Determines whether a specific key is currently pressed by accessing the matrix directly
// The key is a keyboard code defined from the keyboard matrix by %00rrrccc, where rrr is the row ID (0-7) and ccc is the column ID (0-7)
// All keys exist as as KEY_XXX constants.
// Returns zero if the key is not pressed and a non-zero value if the key is currently pressed
keyboard_key_pressed: {
    .const colidx = KEY_SPACE&7
    .label rowidx = KEY_SPACE>>3
    // keyboard_matrix_read(rowidx)
    jsr keyboard_matrix_read
    // keyboard_matrix_read(rowidx) & keyboard_matrix_col_bitmask[colidx]
    and keyboard_matrix_col_bitmask+colidx
    // }
    rts
}
// Read a single row of the keyboard matrix
// The row ID (0-7) of the keyboard matrix row to read. See the C64 key matrix for row IDs.
// Returns the keys pressed on the row as bits according to the C64 key matrix.
// Notice: If the C64 normal interrupt is still running it will occasionally interrupt right between the read & write
// leading to erroneous readings. You must disable kill the normal interrupt or sei/cli around calls to the keyboard matrix reader.
keyboard_matrix_read: {
    // *CIA1_PORT_A = keyboard_matrix_row_bitmask[rowid]
    lda keyboard_matrix_row_bitmask+keyboard_key_pressed.rowidx
    sta CIA1_PORT_A
    // ~*CIA1_PORT_B
    lda CIA1_PORT_B
    eor #$ff
    // }
    rts
}
// The main loop
loop: {
    .label __1 = 7
    .label __2 = 7
    .label __5 = 7
    .label __6 = 7
    .label x = 7
    .label y = 7
    .label a = 3
    .label r = 2
    .label i = 4
    // Render Rotated BOBs
    .label angle = 6
    .label plexFreeNextYpos1_return = $12
    .label i1 = 9
    lda #0
    sta.z angle
  __b2:
    // while (*RASTER<0xd8)
    lda RASTER
    cmp #$d8
    bcc __b2
    // *BORDERCOL = 0xf
    lda #$f
    sta BORDERCOL
    lda.z angle
    sta.z a
    lda #0
    sta.z i
    lda #$1e
    sta.z r
  __b4:
    // *BORDERCOL = 6
    //kickasm {{ .break }}
    lda #6
    sta BORDERCOL
    // mulf8s(r, COS[a])
    lda.z r
    ldy.z a
    ldx COS,y
    jsr mulf8s
    // mulf8s(r, COS[a])
    // mulf8s(r, COS[a])*2
    asl.z __2
    rol.z __2+1
    // x = mulf8s(r, COS[a])*2 + 125*0x100
    clc
    lda.z x
    adc #<$7d*$100
    sta.z x
    lda.z x+1
    adc #>$7d*$100
    sta.z x+1
    // >x
    tax
    // PLEX_XPOS[i] = >x
    lda.z i
    asl
    tay
    txa
    sta PLEX_XPOS,y
    // mulf8s(r, SIN[a])
    lda.z r
    ldy.z a
    ldx SIN,y
    jsr mulf8s
    // mulf8s(r, SIN[a])
    // mulf8s(r, SIN[a])*2
    asl.z __6
    rol.z __6+1
    // y = mulf8s(r, SIN[a])*2 + 125*0x100
    clc
    lda.z y
    adc #<$7d*$100
    sta.z y
    lda.z y+1
    adc #>$7d*$100
    sta.z y+1
    // >y
    // PLEX_YPOS[i] = >y
    ldy.z i
    sta PLEX_YPOS,y
    // a += 98
    lax.z a
    axs #-[$62]
    stx.z a
    // r += 3
    lax.z r
    axs #-[3]
    stx.z r
    // for(char i: 0..NUM_BOBS-1)
    inc.z i
    lda #NUM_BOBS-1+1
    cmp.z i
    bne __b4
    // *BORDERCOL = 3
    lda #3
    sta BORDERCOL
    // plexSort()
    jsr plexSort
    // angle += 3
    lax.z angle
    axs #-[3]
    stx.z angle
    // *BORDERCOL = BLACK
    lda #BLACK
    sta BORDERCOL
  // Sort the sprites by y-position
  __b6:
    // *D011&VIC_RST8
    lda #VIC_RST8
    and D011
    // while((*D011&VIC_RST8)!=0)
    cmp #0
    bne __b6
    lda #0
    sta.z i1
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
    // for( char i: 0..PLEX_COUNT-1)
    inc.z i1
    lda #PLEX_COUNT-1+1
    cmp.z i1
    bne __b7
    // *BORDERCOL = BLACK
    lda #BLACK
    sta BORDERCOL
    // keyboard_key_pressed(KEY_SPACE)
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_SPACE)
    // if(keyboard_key_pressed(KEY_SPACE))
    cmp #0
    bne __breturn
    jmp __b2
  __breturn:
    // }
    rts
}
// Show the next sprite.
// plexSort() prepares showing the sprites
plexShowSprite: {
    .label plex_sprite_idx2 = $13
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
    .label nxt_idx = $13
    .label nxt_y = $14
    .label m = $12
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
// Fast multiply two signed bytes to a word result
// mulf8s(signed byte register(A) a, signed byte register(X) b)
mulf8s: {
    .label return = 7
    // mulf8u_prepare((byte)a)
    jsr mulf8u_prepare
    // mulf8s_prepared(b)
    stx.z mulf8s_prepared.b
    jsr mulf8s_prepared
    // }
    rts
}
// Calculate fast multiply with a prepared unsigned byte to a word result
// The prepared number is set by calling mulf8s_prepare(byte a)
// mulf8s_prepared(signed byte zp($14) b)
mulf8s_prepared: {
    .label memA = $fd
    .label m = 7
    .label b = $14
    // mulf8u_prepared((byte) b)
    lda.z b
    jsr mulf8u_prepared
    // m = mulf8u_prepared((byte) b)
    // if(*memA<0)
    lda memA
    cmp #0
    bpl __b1
    // >m
    lda.z m+1
    // >m = (>m)-(byte)b
    sec
    sbc.z b
    sta.z m+1
  __b1:
    // if(b<0)
    lda.z b
    cmp #0
    bpl __b2
    // >m
    lda.z m+1
    // >m = (>m)-(byte)*memA
    sec
    sbc memA
    sta.z m+1
  __b2:
    // }
    rts
}
// Calculate fast multiply with a prepared unsigned byte to a word result
// The prepared number is set by calling mulf8u_prepare(byte a)
// mulf8u_prepared(byte register(A) b)
mulf8u_prepared: {
    .label resL = $fe
    .label memB = $ff
    .label return = 7
    // *memB = b
    sta memB
    // asm
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
    // return { *memB, *resL };
    lda resL
    sta.z return
    lda memB
    sta.z return+1
    // }
    rts
}
// Prepare for fast multiply with an unsigned byte to a word result
// mulf8u_prepare(byte register(A) a)
mulf8u_prepare: {
    .label memA = $fd
    // *memA = a
    sta memA
    // asm
    sta mulf8u_prepared.sm1+1
    sta mulf8u_prepared.sm3+1
    eor #$ff
    sta mulf8u_prepared.sm2+1
    sta mulf8u_prepared.sm4+1
    // }
    rts
}
// Initialize the program
init: {
    .label i = 6
    // *D011 = VIC_DEN | VIC_RSEL | 3
    lda #VIC_DEN|VIC_RSEL|3
    sta D011
    // plexInit(SCREEN)
  // Initialize the multiplexer
    jsr plexInit
    lda #0
    sta.z i
  // Set the sprite pointers & initial positions
  __b1:
    // PLEX_PTR[i] = (char)(SPRITE/0x40)
    lda #$ff&SPRITE/$40
    ldy.z i
    sta PLEX_PTR,y
    // i*5
    tya
    asl
    asl
    clc
    adc.z i
    // 24+i*5
    tax
    axs #-[$18]
    // PLEX_XPOS[i] = 24+i*5
    tya
    asl
    tay
    txa
    sta PLEX_XPOS,y
    // i*8
    lda.z i
    asl
    asl
    asl
    // 50+i*8
    clc
    adc #$32
    // PLEX_YPOS[i] = 50+i*8
    ldy.z i
    sta PLEX_YPOS,y
    // for(char i: 0..PLEX_COUNT-1)
    inc.z i
    lda #PLEX_COUNT-1+1
    cmp.z i
    bne __b1
    // *SPRITES_ENABLE = 0xff
    // Enable & initialize sprites
    lda #$ff
    sta SPRITES_ENABLE
    ldx #0
  __b3:
    // SPRITES_COLS[i] = GREEN
    lda #GREEN
    sta SPRITES_COLS,x
    // for(char i: 0..7)
    inx
    cpx #8
    bne __b3
    // mulf_init()
    jsr mulf_init
    // memset(SCREEN, ' ', 1000)
  // Clear screen
    jsr memset
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .label str = SCREEN
    .const c = ' '
    .const num = $3e8
    .label end = str+num
    .label dst = 7
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // }
    rts
  __b2:
    // *dst = c
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x/4)
mulf_init: {
    // x/2
    .label c = 9
    // Counter used for determining x%2==0
    .label sqr1_hi = $a
    // Fill mulf_sqr1 = f(x) = int(x*x/4): If f(x) = x*x/4 then f(x+1) = f(x) + x/2 + 1/4
    .label sqr = $10
    .label sqr1_lo = 7
    // Decrease or increase x_255 - initially we decrease
    .label sqr2_hi = $e
    .label sqr2_lo = $c
    //Start with g(0)=f(255)
    .label dir = $12
    ldx #0
    lda #<mulf_sqr1_hi+1
    sta.z sqr1_hi
    lda #>mulf_sqr1_hi+1
    sta.z sqr1_hi+1
    txa
    sta.z sqr
    sta.z sqr+1
    sta.z c
    lda #<mulf_sqr1_lo+1
    sta.z sqr1_lo
    lda #>mulf_sqr1_lo+1
    sta.z sqr1_lo+1
  __b1:
    // for(byte* sqr1_lo = mulf_sqr1_lo+1; sqr1_lo!=mulf_sqr1_lo+512; sqr1_lo++)
    lda.z sqr1_lo+1
    cmp #>mulf_sqr1_lo+$200
    bne __b2
    lda.z sqr1_lo
    cmp #<mulf_sqr1_lo+$200
    bne __b2
    lda #$ff
    sta.z dir
    lda #<mulf_sqr2_hi
    sta.z sqr2_hi
    lda #>mulf_sqr2_hi
    sta.z sqr2_hi+1
    ldx #-1
    lda #<mulf_sqr2_lo
    sta.z sqr2_lo
    lda #>mulf_sqr2_lo
    sta.z sqr2_lo+1
  __b5:
    // for(byte* sqr2_lo = mulf_sqr2_lo; sqr2_lo!=mulf_sqr2_lo+511; sqr2_lo++)
    lda.z sqr2_lo+1
    cmp #>mulf_sqr2_lo+$1ff
    bne __b6
    lda.z sqr2_lo
    cmp #<mulf_sqr2_lo+$1ff
    bne __b6
    // *(mulf_sqr2_lo+511) = *(mulf_sqr1_lo+256)
    // Set the very last value g(511) = f(256)
    lda mulf_sqr1_lo+$100
    sta mulf_sqr2_lo+$1ff
    // *(mulf_sqr2_hi+511) = *(mulf_sqr1_hi+256)
    lda mulf_sqr1_hi+$100
    sta mulf_sqr2_hi+$1ff
    // }
    rts
  __b6:
    // *sqr2_lo = mulf_sqr1_lo[x_255]
    lda mulf_sqr1_lo,x
    ldy #0
    sta (sqr2_lo),y
    // *sqr2_hi++ = mulf_sqr1_hi[x_255]
    lda mulf_sqr1_hi,x
    sta (sqr2_hi),y
    // *sqr2_hi++ = mulf_sqr1_hi[x_255];
    inc.z sqr2_hi
    bne !+
    inc.z sqr2_hi+1
  !:
    // x_255 = x_255 + dir
    txa
    clc
    adc.z dir
    tax
    // if(x_255==0)
    cpx #0
    bne __b8
    lda #1
    sta.z dir
  __b8:
    // for(byte* sqr2_lo = mulf_sqr2_lo; sqr2_lo!=mulf_sqr2_lo+511; sqr2_lo++)
    inc.z sqr2_lo
    bne !+
    inc.z sqr2_lo+1
  !:
    jmp __b5
  __b2:
    // if((++c&1)==0)
    inc.z c
    // ++c&1
    lda #1
    and.z c
    // if((++c&1)==0)
    cmp #0
    bne __b3
    // x_2++;
    inx
    // sqr++;
    inc.z sqr
    bne !+
    inc.z sqr+1
  !:
  __b3:
    // <sqr
    lda.z sqr
    // *sqr1_lo = <sqr
    ldy #0
    sta (sqr1_lo),y
    // >sqr
    lda.z sqr+1
    // *sqr1_hi++ = >sqr
    sta (sqr1_hi),y
    // *sqr1_hi++ = >sqr;
    inc.z sqr1_hi
    bne !+
    inc.z sqr1_hi+1
  !:
    // sqr = sqr + x_2
    txa
    clc
    adc.z sqr
    sta.z sqr
    bcc !+
    inc.z sqr+1
  !:
    // for(byte* sqr1_lo = mulf_sqr1_lo+1; sqr1_lo!=mulf_sqr1_lo+512; sqr1_lo++)
    inc.z sqr1_lo
    bne !+
    inc.z sqr1_lo+1
  !:
    jmp __b1
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
  // Keyboard row bitmask as expected by CIA#1 Port A when reading a specific keyboard matrix row (rows are numbered 0-7)
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  // Keyboard matrix column bitmasks for a specific keybooard matrix column when reading the keyboard. (columns are numbered 0-7)
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
  // The BOB sprite
  .align $1000
SPRITE:
.var pic = LoadPicture("smiley.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)

  // Sine and Cosine tables
  // Angles: $00=0, $80=PI,$100=2*PI
  // Sine/Cosine: signed fixed [-$7f,$7f]
  .align $40
SIN:
.for(var i=0;i<$140;i++)
        .byte >round($7fff*sin(i*2*PI/256))

