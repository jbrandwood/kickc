// Pre-calculated bobs inside a charset (pre-moved to all x/y-combinations)
// Commodore 64 Registers and Constants
// The MOS 6526 Complex Interface Adapter (CIA)
// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const KEY_SPACE = $3c
  // The number of different X-shifts
  .const BOB_SHIFTS_X = 4
  // The number of different Y-shifts
  .const BOB_SHIFTS_Y = 8
  // The size of a sub-table of BOB_TABLES
  .const BOB_SUBTABLE_SIZE = BOB_SHIFTS_X*BOB_SHIFTS_Y
  // The number of BOBs to render
  .const NUM_BOBS = $19
  .const SIZEOF_POINTER = 2
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR = 2
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_B = 1
  .label RASTER = $d012
  .label BORDER_COLOR = $d020
  .label D018 = $d018
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  // The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
  // The BASIC screen
  .label BASIC_SCREEN = $400
  // The BASIC charset
  .label BASIC_CHARSET = $1000
  // The BOB screen
  .label BOB_SCREEN = $2800
  // The BOB charset
  .label BOB_CHARSET = $2000
  // BOB charset ID of the next glyph to be added
  .label bob_charset_next_id = $1b
  // Current index within the progress cursor (0-7)
  .label progress_idx = $f
  // Current position of the progress cursor
  .label progress_cursor = $d
  // Pointer to the next clean-up to add
  // Prepare for next clean-up
  .label renderBobCleanupNext = $19
main: {
    .const origY = $a00
    // Row and column offset vectors
    .const rowOffsetX = $c00
    .const colOffsetX = $100
    .const colOffsetY = $1800
    .const vicSelectGfxBank1_toDd001_return = 3
    .const vicSelectGfxBank2_toDd001_return = 3
    .const toD0181_return = (>(BOB_SCREEN&$3fff)*4)|(>BOB_CHARSET)/4&$f
    .const toD0182_return = (>(BASIC_SCREEN&$3fff)*4)|(>BASIC_CHARSET)/4&$f
    .label x = 4
    .label y = 6
    .label x_1 = 8
    .label y_1 = $a
    .label rowX = 4
    .label rowY = 6
    .label col = $f
    // Origin point
    .label origX = $d
    .label rowOffsetY = 2
    // mulf_init()
    jsr mulf_init
    // prepareBobs()
    jsr prepareBobs
    // renderBobInit()
    jsr renderBobInit
    // CIA2->PORT_A_DDR = %00000011
    lda #3
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA2->PORT_A = toDd00(gfx)
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2
    // *D018 = toD018(BOB_SCREEN, BOB_CHARSET)
    lda #toD0181_return
    sta D018
    // memset(BOB_SCREEN, 0x00, 1000)
  // Clear screen
    jsr memset
    lda #<$100
    sta.z rowOffsetY
    lda #>$100
    sta.z rowOffsetY+1
    lda #<$a00
    sta.z origX
    lda #>$a00
    sta.z origX+1
  // Render Grid of BOBs
  __b2:
    // while (*RASTER<$f8)
    lda RASTER
    cmp #$f8
    bcc __b2
    // *BORDER_COLOR = 0xf
    lda #$f
    sta BORDER_COLOR
    // renderBobCleanup()
    jsr renderBobCleanup
    lda.z origX
    sta.z x
    lda.z origX+1
    sta.z x+1
    lda #0
    sta.z col
    lda #<RENDERBOB_CLEANUP
    sta.z renderBobCleanupNext
    lda #>RENDERBOB_CLEANUP
    sta.z renderBobCleanupNext+1
    lda #<origY
    sta.z y
    lda #>origY
    sta.z y+1
  __b4:
    lda.z x
    sta.z x_1
    lda.z x+1
    sta.z x_1+1
    lda.z y
    sta.z y_1
    lda.z y+1
    sta.z y_1+1
    ldx #0
  __b5:
    // *BORDER_COLOR = 1
    //kickasm {{ .break }}
    lda #1
    sta BORDER_COLOR
    // renderBob(>x, >y)
    lda.z x_1+1
    sta.z renderBob.xpos
    lda.z y_1+1
    sta.z renderBob.ypos
    jsr renderBob
    // x += rowOffsetX
    clc
    lda.z x_1
    adc #<rowOffsetX
    sta.z x_1
    lda.z x_1+1
    adc #>rowOffsetX
    sta.z x_1+1
    // y += rowOffsetY
    lda.z y_1
    clc
    adc.z rowOffsetY
    sta.z y_1
    lda.z y_1+1
    adc.z rowOffsetY+1
    sta.z y_1+1
    // *BORDER_COLOR = 2
    lda #2
    sta BORDER_COLOR
    // for(char row: 0..4)
    inx
    cpx #5
    bne __b5
    // rowX += colOffsetX
    clc
    lda.z rowX
    adc #<colOffsetX
    sta.z rowX
    lda.z rowX+1
    adc #>colOffsetX
    sta.z rowX+1
    // rowY += colOffsetY
    clc
    lda.z rowY
    adc #<colOffsetY
    sta.z rowY
    lda.z rowY+1
    adc #>colOffsetY
    sta.z rowY+1
    // for(char col: 0..4)
    inc.z col
    lda #5
    cmp.z col
    bne __b4
    // origX += 0x0100
    clc
    lda.z origX
    adc #<$100
    sta.z origX
    lda.z origX+1
    adc #>$100
    sta.z origX+1
    // rowOffsetY += 0x0080
    clc
    lda.z rowOffsetY
    adc #<$80
    sta.z rowOffsetY
    lda.z rowOffsetY+1
    adc #>$80
    sta.z rowOffsetY+1
    // *BORDER_COLOR = 0
    lda #0
    sta BORDER_COLOR
    // keyboard_key_pressed(KEY_SPACE)
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_SPACE)
    // if(keyboard_key_pressed(KEY_SPACE))
    cmp #0
    bne __b8
    jmp __b2
  // Wait for space release
  __b8:
    // keyboard_key_pressed(KEY_SPACE)
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_SPACE)
    // while(keyboard_key_pressed(KEY_SPACE))
    cmp #0
    bne __b8
    // CIA2->PORT_A_DDR = %00000011
    lda #3
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA2->PORT_A = toDd00(gfx)
    lda #vicSelectGfxBank2_toDd001_return
    sta CIA2
    // *D018 = toD018(BASIC_SCREEN, BASIC_CHARSET)
    lda #toD0182_return
    sta D018
    // }
    rts
}
// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x/4)
mulf_init: {
    // x/2
    .label c = $c
    // Counter used for determining x%2==0
    .label sqr1_hi = $1c
    // Fill mulf_sqr1 = f(x) = int(x*x/4): If f(x) = x*x/4 then f(x+1) = f(x) + x/2 + 1/4
    .label sqr = $15
    .label sqr1_lo = $19
    // Decrease or increase x_255 - initially we decrease
    .label sqr2_hi = $13
    .label sqr2_lo = $11
    //Start with g(0)=f(255)
    .label dir = $10
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
    // for(char* sqr1_lo = mulf_sqr1_lo+1; sqr1_lo!=mulf_sqr1_lo+512; sqr1_lo++)
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
    // for(char* sqr2_lo = mulf_sqr2_lo; sqr2_lo!=mulf_sqr2_lo+511; sqr2_lo++)
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
    // for(char* sqr2_lo = mulf_sqr2_lo; sqr2_lo!=mulf_sqr2_lo+511; sqr2_lo++)
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
    // for(char* sqr1_lo = mulf_sqr1_lo+1; sqr1_lo!=mulf_sqr1_lo+512; sqr1_lo++)
    inc.z sqr1_lo
    bne !+
    inc.z sqr1_lo+1
  !:
    jmp __b1
}
// Creates the pre-shifted bobs into BOB_CHARSET and populates the BOB_TABLES
// Modifies PROTO_BOB by shifting it around
prepareBobs: {
    .label bob_table = $11
    .label shift_y = $c
    // Populate charset and tables
    .label bob_glyph = $1c
    .label cell = $18
    .label bob_table_idx = $10
    .label shift_x = $17
    // charsetFindOrAddGlyph(PROTO_BOB+48, BOB_CHARSET)
  // Ensure that glyph #0 is empty
    lda #<PROTO_BOB+$30
    sta.z charsetFindOrAddGlyph.glyph
    lda #>PROTO_BOB+$30
    sta.z charsetFindOrAddGlyph.glyph+1
    lda #0
    sta.z bob_charset_next_id
    jsr charsetFindOrAddGlyph
    lda #0
    sta.z bob_table_idx
    sta.z progress_idx
    lda #<BASIC_SCREEN
    sta.z progress_cursor
    lda #>BASIC_SCREEN
    sta.z progress_cursor+1
    lda #0
    sta.z shift_y
  __b1:
    // for(char shift_y=0;shift_y<BOB_SHIFTS_Y;shift_y++)
    lda.z shift_y
    cmp #BOB_SHIFTS_Y
    bcc __b4
    // }
    rts
  __b4:
    lda #0
    sta.z shift_x
  __b2:
    // for(char shift_x=0;shift_x<BOB_SHIFTS_X;shift_x++)
    lda.z shift_x
    cmp #BOB_SHIFTS_X
    bcc __b3
    // protoBobShiftDown()
  // Shift PROTO_BOB down and 8px left
    jsr protoBobShiftDown
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
    // protoBobShiftRight()
  // Shift PROTO_BOB right twice
    jsr protoBobShiftRight
    // protoBobShiftRight()
    jsr protoBobShiftRight
    // for(char shift_x=0;shift_x<BOB_SHIFTS_X;shift_x++)
    inc.z shift_x
    jmp __b2
  __b6:
    // charsetFindOrAddGlyph(bob_glyph, BOB_CHARSET)
    jsr charsetFindOrAddGlyph
    // charsetFindOrAddGlyph(bob_glyph, BOB_CHARSET)
    txa
    // *bob_table = charsetFindOrAddGlyph(bob_glyph, BOB_CHARSET)
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
// Initialize the tables used by renderBob()
renderBobInit: {
    .label __0 = $19
    .label __5 = $19
    .label __6 = $1c
    .label __7 = $19
    ldx #0
  __b1:
    // ((unsigned int)y)*40
    txa
    sta.z __5
    lda #0
    sta.z __5+1
    lda.z __5
    asl
    sta.z __6
    lda.z __5+1
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
    asl.z __0
    rol.z __0+1
    asl.z __0
    rol.z __0+1
    asl.z __0
    rol.z __0+1
    // MUL40[y] = ((unsigned int)y)*40
    txa
    asl
    tay
    lda.z __0
    sta MUL40,y
    lda.z __0+1
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
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = 0
    .const num = $3e8
    .label str = BOB_SCREEN
    .label end = str+num
    .label dst = $13
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
// Clean Up the rendered BOB's
renderBobCleanup: {
    .label screen = $19
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
// Render a single BOB at a given x/y-position
// X-position is 0-151. Each x-position is 2 pixels wide.
// Y-position is 0-183. Each y-position is 1 pixel high.
// renderBob(byte zp($17) xpos, byte zp($18) ypos)
renderBob: {
    .label __2 = $1c
    .label __5 = $1e
    .label xpos = $17
    .label ypos = $18
    .label x_char_offset = $1b
    .label y_offset = $1c
    .label screen = $1c
    .label bob_table_idx = $1e
    // x_char_offset = xpos/BOB_SHIFTS_X
    lda.z xpos
    lsr
    lsr
    sta.z x_char_offset
    // y_char_offset = ypos/BOB_SHIFTS_Y
    lda.z ypos
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
    lda #7
    and.z ypos
    // (ypos&7)*BOB_SHIFTS_X
    asl
    asl
    sta.z __5
    // xpos&3
    lda #3
    and.z xpos
    // bob_table_idx = (ypos&7)*BOB_SHIFTS_X+(xpos&3)
    clc
    adc.z bob_table_idx
    sta.z bob_table_idx
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
    ldy.z bob_table_idx
    lda BOB_TABLES,y
    ldy #0
    sta (screen),y
    // screen[40] = (BOB_TABLES+1*BOB_SUBTABLE_SIZE)[bob_table_idx]
    ldy.z bob_table_idx
    lda BOB_TABLES+1*BOB_SUBTABLE_SIZE,y
    ldy #$28
    sta (screen),y
    // screen[80] = (BOB_TABLES+2*BOB_SUBTABLE_SIZE)[bob_table_idx]
    ldy.z bob_table_idx
    lda BOB_TABLES+2*BOB_SUBTABLE_SIZE,y
    ldy #$50
    sta (screen),y
    // screen[1]  = (BOB_TABLES+3*BOB_SUBTABLE_SIZE)[bob_table_idx]
    ldy.z bob_table_idx
    lda BOB_TABLES+3*BOB_SUBTABLE_SIZE,y
    ldy #1
    sta (screen),y
    // screen[41] = (BOB_TABLES+4*BOB_SUBTABLE_SIZE)[bob_table_idx]
    ldy.z bob_table_idx
    lda BOB_TABLES+4*BOB_SUBTABLE_SIZE,y
    ldy #$29
    sta (screen),y
    // screen[81] = (BOB_TABLES+5*BOB_SUBTABLE_SIZE)[bob_table_idx]
    ldy.z bob_table_idx
    lda BOB_TABLES+5*BOB_SUBTABLE_SIZE,y
    ldy #$51
    sta (screen),y
    // screen[2]  = (BOB_TABLES+6*BOB_SUBTABLE_SIZE)[bob_table_idx]
    ldy.z bob_table_idx
    lda BOB_TABLES+6*BOB_SUBTABLE_SIZE,y
    ldy #2
    sta (screen),y
    // screen[42] = (BOB_TABLES+7*BOB_SUBTABLE_SIZE)[bob_table_idx]
    ldy.z bob_table_idx
    lda BOB_TABLES+7*BOB_SUBTABLE_SIZE,y
    ldy #$2a
    sta (screen),y
    // screen[82] = (BOB_TABLES+8*BOB_SUBTABLE_SIZE)[bob_table_idx]
    ldy.z bob_table_idx
    lda BOB_TABLES+8*BOB_SUBTABLE_SIZE,y
    ldy #$52
    sta (screen),y
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
// Looks through a charset to find a glyph if present. If not present it is added.
// Returns the glyph ID
// charsetFindOrAddGlyph(byte* zp($1c) glyph)
charsetFindOrAddGlyph: {
    .label glyph = $1c
    .label glyph_cursor = $15
    lda #<BOB_CHARSET
    sta.z glyph_cursor
    lda #>BOB_CHARSET
    sta.z glyph_cursor+1
    ldx #0
  __b1:
    // while(glyph_id!=bob_charset_next_id)
    cpx.z bob_charset_next_id
    bne __b9
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
    // glyph_cursor[i]=glyph[i]
    lda (glyph),y
    sta (glyph_cursor),y
    // for(char i=0;i<8;i++)
    iny
    jmp __b7
  __b9:
    ldy #0
  __b2:
    // for(char i=0;i<8;i++)
    cpy #8
    bcc __b3
    lda #1
    jmp __b5
  __b3:
    // if(glyph_cursor[i]!=glyph[i])
    lda (glyph_cursor),y
    cmp (glyph),y
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
// Shift PROTO_BOB down one Y pixel
// At the same time restore PROTO_BOB X by shifting 8 pixels left
protoBobShiftDown: {
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
// Shift PROTO_BOB right one X pixel
protoBobShiftRight: {
    .label carry = $18
    .label i = $1e
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
// Read a single row of the keyboard matrix
// The row ID (0-7) of the keyboard matrix row to read. See the C64 key matrix for row IDs.
// Returns the keys pressed on the row as bits according to the C64 key matrix.
// Notice: If the C64 normal interrupt is still running it will occasionally interrupt right between the read & write
// leading to erroneous readings. You must disable the normal interrupt or sei/cli around calls to the keyboard matrix reader.
keyboard_matrix_read: {
    // CIA1->PORT_A = keyboard_matrix_row_bitmask[rowid]
    lda keyboard_matrix_row_bitmask+keyboard_key_pressed.rowidx
    sta CIA1
    // ~CIA1->PORT_B
    lda CIA1+OFFSET_STRUCT_MOS6526_CIA_PORT_B
    eor #$ff
    // }
    rts
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

  // Tables containing the char to use for a specific cell of a shifted BOB.
  // char_id = BOB_TABLES[cell*BOB_SUBTABLE_SIZE + shift_y*BOB_SHIFTS_X + shift_x];
  BOB_TABLES: .fill 9*8*4, 0
  // Table used for deleting rendered BOB's. Contains pointers to first char of each BOB.
  RENDERBOB_CLEANUP: .fill 2*NUM_BOBS, 0
  // *40 Table unsigned int MUL40[0x20] = { ((unsigned int)i)*40 };
  MUL40: .fill 2*$20, 0
