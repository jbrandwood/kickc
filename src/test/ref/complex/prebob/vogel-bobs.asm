// Pre-calculated bobs inside a charset (pre-moved to all x/y-combinations)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label BORDERCOL = $d020
  .label D018 = $d018
  // CIA#1 Port A: keyboard matrix columns and joystick #2
  .label CIA1_PORT_A = $dc00
  // CIA#1 Port B: keyboard matrix rows and joystick #1.
  .label CIA1_PORT_B = $dc01
  // CIA#2 Port A: Serial bus, RS-232, VIC memory bank
  .label CIA2_PORT_A = $dd00
  // CIA #2 Port A data direction register.
  .label CIA2_PORT_A_DDR = $dd02
  .const KEY_SPACE = $3c
  // The BASIC screen
  .label SCREEN_BASIC = $400
  // The BASIC charset
  .label CHARSET_BASIC = $1000
  // The BOB screen
  .label BOB_SCREEN = $2800
  // The BOB charset
  .label BOB_CHARSET = $2000
  // The number of different X-shifts
  .const BOB_SHIFTS_X = 4
  // The number of different Y-shifts
  .const BOB_SHIFTS_Y = 8
  // The size of a sub-table of BOB_TABLES
  .const BOB_SUBTABLE_SIZE = BOB_SHIFTS_X*BOB_SHIFTS_Y
  // The number of BOBs to render
  .const NUM_BOBS = $14
  .const SIZEOF_POINTER = 2
  .label COS = SIN+$40
  // BOB charset ID of the next glyph to be added
  .label bob_charset_next_id = $d
  // Current index within the progress cursor (0-7)
  .label progress_idx = 3
  // Current position of the progress cursor
  .label progress_cursor = $b
  // Pointer to the next clean-up to add
  // Prepare for next clean-up
  .label renderBobCleanupNext = 6
main: {
    .const vicSelectGfxBank1_toDd001_return = 3
    .const vicSelectGfxBank2_toDd001_return = 3
    .const toD0181_return = (>(BOB_SCREEN&$3fff)*4)|(>BOB_CHARSET)/4&$f
    .const toD0182_return = (>(SCREEN_BASIC&$3fff)*4)|(>CHARSET_BASIC)/4&$f
    .label __10 = $b
    .label __12 = $b
    .label __13 = $b
    .label x = 8
    .label y = $b
    .label a = 4
    .label r = 3
    .label i = 5
    // Render Rotated BOBs
    .label angle = 2
    // mulf_init()
    jsr mulf_init
    // prepareBobs()
    jsr prepareBobs
    // renderBobInit()
    jsr renderBobInit
    // *CIA2_PORT_A_DDR = %00000011
    lda #3
    sta CIA2_PORT_A_DDR
    // *CIA2_PORT_A = toDd00(gfx)
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2_PORT_A
    // *D018 = toD018(BOB_SCREEN, BOB_CHARSET)
    lda #toD0181_return
    sta D018
    // memset(BOB_SCREEN, 0x00, 1000)
  /*
	// Clear screen
	memset(BOB_SCREEN, 0x00, 1000);
	// Display a BOB grid
	for(char x: 0..7)
	    for(char y: 0..3)
            renderBob(x*12+y, y*24+x);
	// Wait for space
	while(!keyboard_key_pressed(KEY_SPACE)) {}
	while(keyboard_key_pressed(KEY_SPACE)) {}
	*/
  // Clear screen
    jsr memset
    lda #0
    sta.z angle
  __b2:
    // while (*RASTER<$f8)
    lda RASTER
    cmp #$f8
    bcc __b2
    // *BORDERCOL = 0xf
    lda #$f
    sta BORDERCOL
    // renderBobCleanup()
    jsr renderBobCleanup
    lda.z angle
    sta.z a
    lda #0
    sta.z i
    lda #<RENDERBOB_CLEANUP
    sta.z renderBobCleanupNext
    lda #>RENDERBOB_CLEANUP
    sta.z renderBobCleanupNext+1
    lda #$1e
    sta.z r
  __b4:
    // *BORDERCOL = 1
    //kickasm {{ .break }}
    lda #1
    sta BORDERCOL
    // mulf8s(r, COS[a])
    lda.z r
    ldy.z a
    ldx COS,y
    jsr mulf8s
    // mulf8s(r, COS[a])
    // x = mulf8s(r, COS[a]) + 75*0x100
    lda.z __10
    clc
    adc #<$4b*$100
    sta.z x
    lda.z __10+1
    adc #>$4b*$100
    sta.z x+1
    // mulf8s(r, SIN[a])
    lda.z r
    ldy.z a
    ldx SIN,y
    jsr mulf8s
    // mulf8s(r, SIN[a])
    // mulf8s(r, SIN[a])*2
    asl.z __13
    rol.z __13+1
    // y = mulf8s(r, SIN[a])*2 + 90*0x100
    clc
    lda.z y
    adc #<$5a*$100
    sta.z y
    lda.z y+1
    adc #>$5a*$100
    sta.z y+1
    // *BORDERCOL = 2
    lda #2
    sta BORDERCOL
    // a += 98
    lax.z a
    axs #-[$62]
    stx.z a
    // r += 3
    lax.z r
    axs #-[3]
    stx.z r
    // renderBob(>x, >y)
    lda.z x+1
    sta.z renderBob.xpos
    lda.z y+1
    tax
    jsr renderBob
    // for(char i: 0..NUM_BOBS-1)
    inc.z i
    lda #NUM_BOBS-1+1
    cmp.z i
    bne __b4
    // angle += 3
    lax.z angle
    axs #-[3]
    stx.z angle
    // *BORDERCOL = 0
    lda #0
    sta BORDERCOL
    // keyboard_key_pressed(KEY_SPACE)
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_SPACE)
    // if(keyboard_key_pressed(KEY_SPACE))
    cmp #0
    bne __b6
    jmp __b2
  // Wait for space release
  __b6:
    // keyboard_key_pressed(KEY_SPACE)
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_SPACE)
    // while(keyboard_key_pressed(KEY_SPACE))
    cmp #0
    bne __b6
    // *CIA2_PORT_A_DDR = %00000011
    lda #3
    sta CIA2_PORT_A_DDR
    // *CIA2_PORT_A = toDd00(gfx)
    lda #vicSelectGfxBank2_toDd001_return
    sta CIA2_PORT_A
    // *D018 = toD018(SCREEN_BASIC, CHARSET_BASIC)
    lda #toD0182_return
    sta D018
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
// Render a single BOB at a given x/y-position
// X-position is 0-151. Each x-position is 2 pixels wide.
// Y-position is 0-183. Each y-position is 1 pixel high.
// renderBob(byte zp($e) xpos, byte register(X) ypos)
renderBob: {
    .label __2 = $b
    .label __5 = $d
    .label xpos = $e
    .label x_char_offset = $a
    .label y_offset = $b
    .label screen = $b
    // x_char_offset = xpos/BOB_SHIFTS_X
    lda.z xpos
    lsr
    lsr
    sta.z x_char_offset
    // y_char_offset = ypos/BOB_SHIFTS_Y
    txa
    lsr
    lsr
    lsr
    // y_offset = MUL40[y_char_offset]
    asl
    tay
    lda MUL40,y
    sta.z y_offset
    lda MUL40+1,y
    sta.z y_offset+1
    // BOB_SCREEN+y_offset
    clc
    lda.z __2
    adc #<BOB_SCREEN
    sta.z __2
    lda.z __2+1
    adc #>BOB_SCREEN
    sta.z __2+1
    // screen = BOB_SCREEN+y_offset+x_char_offset
    lda.z x_char_offset
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    // ypos&7
    txa
    and #7
    // (ypos&7)*BOB_SHIFTS_X
    asl
    asl
    sta.z __5
    // xpos&3
    lda #3
    and.z xpos
    // bob_table_idx = (ypos&7)*BOB_SHIFTS_X+(xpos&3)
    clc
    adc.z __5
    tax
    // *renderBobCleanupNext++ = screen
    ldy #0
    lda.z screen
    sta (renderBobCleanupNext),y
    iny
    lda.z screen+1
    sta (renderBobCleanupNext),y
    // *renderBobCleanupNext++ = screen;
    lda #SIZEOF_POINTER
    clc
    adc.z renderBobCleanupNext
    sta.z renderBobCleanupNext
    bcc !+
    inc.z renderBobCleanupNext+1
  !:
    // screen[0]  = (BOB_TABLES+0*BOB_SUBTABLE_SIZE)[bob_table_idx]
    lda BOB_TABLES,x
    ldy #0
    sta (screen),y
    // screen[40] = (BOB_TABLES+1*BOB_SUBTABLE_SIZE)[bob_table_idx]
    lda BOB_TABLES+1*BOB_SUBTABLE_SIZE,x
    ldy #$28
    sta (screen),y
    // screen[80] = (BOB_TABLES+2*BOB_SUBTABLE_SIZE)[bob_table_idx]
    lda BOB_TABLES+2*BOB_SUBTABLE_SIZE,x
    ldy #$50
    sta (screen),y
    // screen[1]  = (BOB_TABLES+3*BOB_SUBTABLE_SIZE)[bob_table_idx]
    lda BOB_TABLES+3*BOB_SUBTABLE_SIZE,x
    ldy #1
    sta (screen),y
    // screen[41] = (BOB_TABLES+4*BOB_SUBTABLE_SIZE)[bob_table_idx]
    lda BOB_TABLES+4*BOB_SUBTABLE_SIZE,x
    ldy #$29
    sta (screen),y
    // screen[81] = (BOB_TABLES+5*BOB_SUBTABLE_SIZE)[bob_table_idx]
    lda BOB_TABLES+5*BOB_SUBTABLE_SIZE,x
    ldy #$51
    sta (screen),y
    // screen[2]  = (BOB_TABLES+6*BOB_SUBTABLE_SIZE)[bob_table_idx]
    lda BOB_TABLES+6*BOB_SUBTABLE_SIZE,x
    ldy #2
    sta (screen),y
    // screen[42] = (BOB_TABLES+7*BOB_SUBTABLE_SIZE)[bob_table_idx]
    lda BOB_TABLES+7*BOB_SUBTABLE_SIZE,x
    ldy #$2a
    sta (screen),y
    // screen[82] = (BOB_TABLES+8*BOB_SUBTABLE_SIZE)[bob_table_idx]
    lda BOB_TABLES+8*BOB_SUBTABLE_SIZE,x
    ldy #$52
    sta (screen),y
    // }
    rts
}
// Fast multiply two signed bytes to a word result
// mulf8s(signed byte register(A) a, signed byte register(X) b)
mulf8s: {
    .label return = $b
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
// mulf8s_prepared(signed byte zp($e) b)
mulf8s_prepared: {
    .label memA = $fd
    .label m = $b
    .label b = $e
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
    .label return = $b
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
// Clean Up the rendered BOB's
renderBobCleanup: {
    .label screen = $f
    ldx #0
  __b1:
    // screen = RENDERBOB_CLEANUP[i]
    txa
    asl
    tay
    lda RENDERBOB_CLEANUP,y
    sta.z screen
    lda RENDERBOB_CLEANUP+1,y
    sta.z screen+1
    // screen[0]  = 0
    lda #0
    tay
    sta (screen),y
    // screen[40]  = 0
    ldy #$28
    sta (screen),y
    // screen[80]  = 0
    ldy #$50
    sta (screen),y
    // screen[1]  = 0
    ldy #1
    sta (screen),y
    // screen[41]  = 0
    ldy #$29
    sta (screen),y
    // screen[81]  = 0
    ldy #$51
    sta (screen),y
    // screen[2]  = 0
    ldy #2
    sta (screen),y
    // screen[42]  = 0
    ldy #$2a
    sta (screen),y
    // screen[82]  = 0
    ldy #$52
    sta (screen),y
    // for(char i: 0..NUM_BOBS-1)
    inx
    cpx #NUM_BOBS-1+1
    bne __b1
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .label str = BOB_SCREEN
    .const c = 0
    .const num = $3e8
    .label end = str+num
    .label dst = 6
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
// Initialize the tables used by renderBob()
renderBobInit: {
    .label __0 = $f
    .label __1 = $f
    .label __6 = $11
    .label __7 = $f
    ldx #0
  __b1:
    // (unsigned int)y
    txa
    sta.z __0
    lda #0
    sta.z __0+1
    // ((unsigned int)y)*40
    lda.z __0
    asl
    sta.z __6
    lda.z __0+1
    rol
    sta.z __6+1
    asl.z __6
    rol.z __6+1
    lda.z __7
    clc
    adc.z __6
    sta.z __7
    lda.z __7+1
    adc.z __6+1
    sta.z __7+1
    asl.z __1
    rol.z __1+1
    asl.z __1
    rol.z __1+1
    asl.z __1
    rol.z __1+1
    // MUL40[y] = ((unsigned int)y)*40
    txa
    asl
    tay
    lda.z __1
    sta MUL40,y
    lda.z __1+1
    sta MUL40+1,y
    // for(char y: 0..0x1f)
    inx
    cpx #$20
    bne __b1
    ldx #0
  __b2:
    // RENDERBOB_CLEANUP[i] = BOB_SCREEN
    txa
    asl
    tay
    lda #<BOB_SCREEN
    sta RENDERBOB_CLEANUP,y
    lda #>BOB_SCREEN
    sta RENDERBOB_CLEANUP+1,y
    // for(char i: 0..NUM_BOBS-1)
    inx
    cpx #NUM_BOBS-1+1
    bne __b2
    // }
    rts
}
// Creates the pre-shifted bobs into BOB_CHARSET and populates the BOB_TABLES
// Modifies PROTO_BOB by shifting it around
prepareBobs: {
    .label bob_table = $f
    .label shift_y = 2
    // Populate charset and tables
    .label bob_glyph = 6
    .label cell = $a
    .label bob_table_idx = 4
    .label shift_x = 5
    // progress_init(SCREEN_BASIC)
    jsr progress_init
    // bobCharsetFindOrAddGlyph(PROTO_BOB+48)
  // Ensure that glyph #0 is empty
    lda #<PROTO_BOB+$30
    sta.z bobCharsetFindOrAddGlyph.bob_glyph
    lda #>PROTO_BOB+$30
    sta.z bobCharsetFindOrAddGlyph.bob_glyph+1
    lda #0
    sta.z bob_charset_next_id
    jsr bobCharsetFindOrAddGlyph
    lda #0
    sta.z bob_table_idx
    sta.z progress_idx
    lda #<SCREEN_BASIC
    sta.z progress_cursor
    lda #>SCREEN_BASIC
    sta.z progress_cursor+1
    lda #0
    sta.z shift_y
  __b1:
    // for(char shift_y=0;shift_y<BOB_SHIFTS_Y;shift_y++)
    lda.z shift_y
    cmp #BOB_SHIFTS_Y
    bcc b1
    // }
    rts
  b1:
    lda #0
    sta.z shift_x
  __b2:
    // for(char shift_x=0;shift_x<BOB_SHIFTS_X;shift_x++)
    lda.z shift_x
    cmp #BOB_SHIFTS_X
    bcc __b3
    // shiftProtoBobDown()
  // Shift PROTO_BOB down and 8px left
    jsr shiftProtoBobDown
    // for(char shift_y=0;shift_y<BOB_SHIFTS_Y;shift_y++)
    inc.z shift_y
    jmp __b1
  __b3:
    // bob_table = BOB_TABLES + bob_table_idx
    lda.z bob_table_idx
    clc
    adc #<BOB_TABLES
    sta.z bob_table
    lda #>BOB_TABLES
    adc #0
    sta.z bob_table+1
    lda #<PROTO_BOB
    sta.z bob_glyph
    lda #>PROTO_BOB
    sta.z bob_glyph+1
    lda #0
    sta.z cell
  __b5:
    // for(char cell = 0; cell<9; cell++)
    lda.z cell
    cmp #9
    bcc __b6
    // bob_table_idx++;
    inc.z bob_table_idx
    // shiftProtoBobRight()
  // Shift PROTO_BOB right twice
    jsr shiftProtoBobRight
    // shiftProtoBobRight()
    jsr shiftProtoBobRight
    // for(char shift_x=0;shift_x<BOB_SHIFTS_X;shift_x++)
    inc.z shift_x
    jmp __b2
  __b6:
    // bobCharsetFindOrAddGlyph(bob_glyph)
    jsr bobCharsetFindOrAddGlyph
    // bobCharsetFindOrAddGlyph(bob_glyph)
    txa
    // *bob_table = bobCharsetFindOrAddGlyph(bob_glyph)
    // Look for an existing char in BOB_CHARSET 
    ldy #0
    sta (bob_table),y
    // bob_glyph+=8
    // Move to the next glyph
    lda #8
    clc
    adc.z bob_glyph
    sta.z bob_glyph
    bcc !+
    inc.z bob_glyph+1
  !:
    // bob_table += BOB_SHIFTS_X*BOB_SHIFTS_Y
    // Move to the next sub-table
    lda #BOB_SHIFTS_X*BOB_SHIFTS_Y
    clc
    adc.z bob_table
    sta.z bob_table
    bcc !+
    inc.z bob_table+1
  !:
    // progress_inc()
    jsr progress_inc
    // for(char cell = 0; cell<9; cell++)
    inc.z cell
    jmp __b5
}
// Increase PETSCII progress one bit
// Done by increasing the character until the idx is 8 and then moving to the next char
progress_inc: {
    // if(++progress_idx==8)
    inc.z progress_idx
    lda #8
    cmp.z progress_idx
    bne __b1
    // *progress_cursor = progress_chars[8]
    lda progress_chars+8
    ldy #0
    sta (progress_cursor),y
    // progress_cursor++;
    inc.z progress_cursor
    bne !+
    inc.z progress_cursor+1
  !:
    lda #0
    sta.z progress_idx
  __b1:
    // *progress_cursor = progress_chars[progress_idx]
    ldy.z progress_idx
    lda progress_chars,y
    ldy #0
    sta (progress_cursor),y
    // }
    rts
    // Progress characters
    progress_chars: .byte $20, $65, $74, $75, $61, $f6, $e7, $ea, $e0
}
// Looks through BOB_CHARSET to find the passed bob glyph if present.
// If not present it is added
// Returns the glyph ID
// bobCharsetFindOrAddGlyph(byte* zp(6) bob_glyph)
bobCharsetFindOrAddGlyph: {
    .label bob_glyph = 6
    .label glyph_cursor = $11
    lda #<BOB_CHARSET
    sta.z glyph_cursor
    lda #>BOB_CHARSET
    sta.z glyph_cursor+1
    ldx #0
  __b1:
    // while(glyph_id!=bob_charset_next_id)
    cpx.z bob_charset_next_id
    bne b1
    ldy #0
  // Not found - add it
  __b7:
    // for(char i=0;i<8;i++)
    cpy #8
    bcc __b8
    // bob_charset_next_id++;
    inc.z bob_charset_next_id
    // }
    rts
  __b8:
    // glyph_cursor[i]=bob_glyph[i]
    lda (bob_glyph),y
    sta (glyph_cursor),y
    // for(char i=0;i<8;i++)
    iny
    jmp __b7
  b1:
    ldy #0
  __b2:
    // for(char i=0;i<8;i++)
    cpy #8
    bcc __b3
    lda #1
    jmp __b5
  __b3:
    // if(glyph_cursor[i]!=bob_glyph[i])
    lda (glyph_cursor),y
    cmp (bob_glyph),y
    beq __b4
    lda #0
  __b5:
    // if(found)
    cmp #0
    beq __b6
    rts
  __b6:
    // glyph_id++;
    inx
    // glyph_cursor +=8
    lda #8
    clc
    adc.z glyph_cursor
    sta.z glyph_cursor
    bcc !+
    inc.z glyph_cursor+1
  !:
    jmp __b1
  __b4:
    // for(char i=0;i<8;i++)
    iny
    jmp __b2
}
// Shift PROTO_BOB right one X pixel
shiftProtoBobRight: {
    .label carry = $e
    .label i = $a
    ldy #0
    ldx #0
    txa
    sta.z i
  __b1:
    // for(char i=0;i<3*3*8;i++)
    lda.z i
    cmp #3*3*8
    bcc __b2
    // }
    rts
  __b2:
    // PROTO_BOB[j]&1
    lda #1
    and PROTO_BOB,x
    // (PROTO_BOB[j]&1)?0x80ub:0ub
    cmp #0
    bne __b3
    lda #0
    sta.z carry
    jmp __b4
  __b3:
    // (PROTO_BOB[j]&1)?0x80ub:0ub
    lda #$80
    sta.z carry
  __b4:
    // PROTO_BOB[j]>>1
    lda PROTO_BOB,x
    lsr
    // carry | PROTO_BOB[j]>>1
    sty.z $ff
    ora.z $ff
    // PROTO_BOB[j] = carry | PROTO_BOB[j]>>1
    // Shift value and add old carry
    sta PROTO_BOB,x
    // if(j>=48)
    // Increment j to iterate over the PROTO_BOB left-to-right, top-to-bottom (0, 24, 48, 1, 25, 49, ...)
    cpx #$30
    bcs __b5
    // j+=24
    txa
    axs #-[$18]
  __b6:
    // for(char i=0;i<3*3*8;i++)
    inc.z i
    ldy.z carry
    jmp __b1
  __b5:
    // j-=47
    txa
    axs #$2f
    jmp __b6
}
// Shift PROTO_BOB down one Y pixel
// At the same time restore PROTO_BOB X by shifting 8 pixels left
shiftProtoBobDown: {
    ldx #$17
  __b1:
    // for(char i=23;i>0;i--)
    cpx #0
    bne __b2
    // PROTO_BOB[0] = 0
    lda #0
    sta PROTO_BOB
    // PROTO_BOB[24] = 0
    sta PROTO_BOB+$18
    // PROTO_BOB[48] = 0
    sta PROTO_BOB+$30
    // }
    rts
  __b2:
    // PROTO_BOB[i] = (PROTO_BOB+23)[i]
    lda PROTO_BOB+$17,x
    sta PROTO_BOB,x
    // (PROTO_BOB+24)[i] = (PROTO_BOB+47)[i]
    lda PROTO_BOB+$2f,x
    sta PROTO_BOB+$18,x
    // (PROTO_BOB+48)[i] = 0x00
    lda #0
    sta PROTO_BOB+$30,x
    // for(char i=23;i>0;i--)
    dex
    jmp __b1
}
// Initialize the PETSCII progress bar
progress_init: {
    // }
    rts
}
// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x/4)
mulf_init: {
    // x/2
    .label c = $d
    // Counter used for determining x%2==0
    .label sqr1_hi = $f
    // Fill mulf_sqr1 = f(x) = int(x*x/4): If f(x) = x*x/4 then f(x+1) = f(x) + x/2 + 1/4
    .label sqr = $b
    .label sqr1_lo = 6
    // Decrease or increase x_255 - initially we decrease
    .label sqr2_hi = 8
    .label sqr2_lo = $11
    //Start with g(0)=f(255)
    .label dir = $e
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
  // Keyboard row bitmask as expected by CIA#1 Port A when reading a specific keyboard matrix row (rows are numbered 0-7)
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  // Keyboard matrix column bitmasks for a specific keybooard matrix column when reading the keyboard. (columns are numbered 0-7)
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
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
  // The prototype BOB (a 3x3 char image with a bob image in the upper 2x2 chars)
  // The chars are layout as follows with data in chars 0, 1, 3, 4 initially
  //   0 3 6
  //   1 4 7
  //   2 5 8
PROTO_BOB:
.var pic = LoadPicture("smiley.png", List().add($000000, $ffffff))
	.for (var x=0;x<3; x++)
    	.for (var y=0; y<24; y++)
            .byte pic.getSinglecolorByte(x,y)

  // Sine and Cosine tables
  // Angles: $00=0, $80=PI,$100=2*PI
  // Sine/Cosine: signed fixed [-$7f,$7f]
  .align $40
SIN:
.for(var i=0;i<$140;i++)
        .byte >round($7fff*sin(i*2*PI/256))

  // Tables containing the char to use for a specific cell of a shifted BOB.
  // char_id = BOB_TABLES[cell*BOB_SUBTABLE_SIZE + shift_y*BOB_SHIFTS_X + shift_x];
  BOB_TABLES: .fill 9*8*4, 0
  // Table used for deleting rendered BOB's. Contains pointers to first char of each BOB.
  RENDERBOB_CLEANUP: .fill 2*NUM_BOBS, 0
  // *40 Table unsigned int[0x20] MUL40 = { ((unsigned int)i)*40 };
  MUL40: .fill 2*$20, 0
