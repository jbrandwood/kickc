// Pre-calculated bobs inside a charset (pre-mpved to all x/y-combinations)
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
  // The screen
  .label BOB_SCREEN = $4800
  // The charset that will receive the shifted bobs
  .label BOB_CHARSET = $4000
  // The number of different X-shifts
  .const BOB_SHIFTS_X = 4
  // The number of different Y-shifts
  .const BOB_SHIFTS_Y = 8
  // The size of a sub-table of BOB_TABLES
  .const BOB_SUBTABLE_SIZE = BOB_SHIFTS_X*BOB_SHIFTS_Y
  // BOB charset ID of the next glyph to be added
  .label bob_charset_next_id = 9
main: {
    .const vicSelectGfxBank1_toDd001_return = 3^(>BOB_SCREEN)/$40
    .const vicSelectGfxBank2_toDd001_return = 3
    .const toD0181_return = >(BOB_SCREEN&$3fff)*4
    .const toD0182_return = (>(SCREEN_BASIC&$3fff)*4)|(>CHARSET_BASIC)/4&$f
    .label x = 2
    // Render sine BOBs
    .label sin_x_idx = 3
    jsr prepareBobs
    lda #3
    sta CIA2_PORT_A_DDR
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2_PORT_A
    lda #toD0181_return
    sta D018
    lda #<BOB_SCREEN
    sta.z memset.str
    lda #>BOB_SCREEN
    sta.z memset.str+1
    jsr memset
    lda #0
    sta.z x
  // Display a BOB grid
  __b1:
    ldx #0
  __b2:
    lda.z x
    asl
    clc
    adc.z x
    asl
    asl
    stx.z $ff
    clc
    adc.z $ff
    sta.z renderBob.xpos
    txa
    asl
    stx.z $ff
    clc
    adc.z $ff
    asl
    asl
    asl
    clc
    adc.z x
    tay
    jsr renderBob
    inx
    cpx #4
    bne __b2
    inc.z x
    lda #8
    cmp.z x
    bne __b1
  b1:
  // Wait for space
    jsr keyboard_key_pressed
    cmp #0
    beq b1
  __b5:
    jsr keyboard_key_pressed
    cmp #0
    bne __b5
    lda #<BOB_SCREEN
    sta.z memset.str
    lda #>BOB_SCREEN
    sta.z memset.str+1
    jsr memset
    ldx #$49
    lda #0
    sta.z sin_x_idx
  __b8:
    lda RASTER
    cmp #$f8
    bcc __b8
    inc BORDERCOL
    ldy.z sin_x_idx
    lda SIN_X_TAB+$15*4,y
    sta.z renderBob.xpos
    ldy SIN_Y_TAB,x
    jsr renderBob
    ldy.z sin_x_idx
    lda SIN_X_TAB+$13*3,y
    sta.z renderBob.xpos
    ldy SIN_Y_TAB+$f*1,x
    jsr renderBob
    ldy.z sin_x_idx
    lda SIN_X_TAB+$11*2,y
    sta.z renderBob.xpos
    ldy SIN_Y_TAB+$11*2,x
    jsr renderBob
    ldy.z sin_x_idx
    lda SIN_X_TAB+$f*1,y
    sta.z renderBob.xpos
    ldy SIN_Y_TAB+$13*3,x
    jsr renderBob
    ldy.z sin_x_idx
    lda SIN_X_TAB,y
    sta.z renderBob.xpos
    ldy SIN_Y_TAB+$15*4,x
    jsr renderBob
    inc.z sin_x_idx
    inx
    dec BORDERCOL
    jsr keyboard_key_pressed
    cmp #0
    bne vicSelectGfxBank2
    jmp __b8
  vicSelectGfxBank2:
    lda #3
    sta CIA2_PORT_A_DDR
    lda #vicSelectGfxBank2_toDd001_return
    sta CIA2_PORT_A
    lda #toD0182_return
    sta D018
    rts
}
// Determines whether a specific key is currently pressed by accessing the matrix directly
// The key is a keyboard code defined from the keyboard matrix by %00rrrccc, where rrr is the row ID (0-7) and ccc is the column ID (0-7)
// All keys exist as as KEY_XXX constants.
// Returns zero if the key is not pressed and a non-zero value if the key is currently pressed
keyboard_key_pressed: {
    .const colidx = KEY_SPACE&7
    .label rowidx = KEY_SPACE>>3
    jsr keyboard_matrix_read
    and keyboard_matrix_col_bitmask+colidx
    rts
}
// Read a single row of the keyboard matrix
// The row ID (0-7) of the keyboard matrix row to read. See the C64 key matrix for row IDs.
// Returns the keys pressed on the row as bits according to the C64 key matrix.
// Notice: If the C64 normal interrupt is still running it will occasionally interrupt right between the read & write
// leading to erroneous readings. You must disable kill the normal interrupt or sei/cli around calls to the keyboard matrix reader.
keyboard_matrix_read: {
    lda keyboard_matrix_row_bitmask+keyboard_key_pressed.rowidx
    sta CIA1_PORT_A
    lda CIA1_PORT_B
    eor #$ff
    rts
}
// Render a single BOB at a given x/y-position
// X-position is 0-151. Each x-position is 2 pixels wide.
// Y-position is 0-183. Each y-position is 1 pixel high.
// renderBob(byte zeropage(4) xpos, byte register(Y) ypos)
renderBob: {
    .label __2 = $d
    .label __4 = $d
    .label __7 = $c
    .label xpos = 4
    .label x_char_offset = 9
    .label y_offset = $d
    .label screen = $d
    .label bob_table_idx = $c
    .label __10 = $a
    .label __11 = $d
    lda.z xpos
    lsr
    lsr
    sta.z x_char_offset
    tya
    lsr
    lsr
    lsr
    sta.z __2
    lda #0
    sta.z __2+1
    lda.z __2
    asl
    sta.z __10
    lda.z __2+1
    rol
    sta.z __10+1
    asl.z __10
    rol.z __10+1
    lda.z __11
    clc
    adc.z __10
    sta.z __11
    lda.z __11+1
    adc.z __10+1
    sta.z __11+1
    asl.z y_offset
    rol.z y_offset+1
    asl.z y_offset
    rol.z y_offset+1
    asl.z y_offset
    rol.z y_offset+1
    clc
    lda.z __4
    adc #<BOB_SCREEN
    sta.z __4
    lda.z __4+1
    adc #>BOB_SCREEN
    sta.z __4+1
    lda.z x_char_offset
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    tya
    and #7
    asl
    asl
    sta.z __7
    lda #3
    and.z xpos
    clc
    adc.z bob_table_idx
    sta.z bob_table_idx
    tay
    lda BOB_TABLES,y
    ldy #0
    sta (screen),y
    ldy.z bob_table_idx
    lda BOB_TABLES+1*BOB_SUBTABLE_SIZE,y
    ldy #$28
    sta (screen),y
    ldy.z bob_table_idx
    lda BOB_TABLES+2*BOB_SUBTABLE_SIZE,y
    ldy #$50
    sta (screen),y
    ldy.z bob_table_idx
    lda BOB_TABLES+3*BOB_SUBTABLE_SIZE,y
    ldy #1
    sta (screen),y
    ldy.z bob_table_idx
    lda BOB_TABLES+4*BOB_SUBTABLE_SIZE,y
    ldy #$29
    sta (screen),y
    ldy.z bob_table_idx
    lda BOB_TABLES+5*BOB_SUBTABLE_SIZE,y
    ldy #$51
    sta (screen),y
    ldy.z bob_table_idx
    lda BOB_TABLES+6*BOB_SUBTABLE_SIZE,y
    ldy #2
    sta (screen),y
    ldy.z bob_table_idx
    lda BOB_TABLES+7*BOB_SUBTABLE_SIZE,y
    ldy #$2a
    sta (screen),y
    ldy.z bob_table_idx
    lda BOB_TABLES+8*BOB_SUBTABLE_SIZE,y
    ldy #$52
    sta (screen),y
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage(5) str)
memset: {
    .label end = $d
    .label dst = 5
    .label str = 5
    lda.z str
    clc
    adc #<$3e8
    sta.z end
    lda.z str+1
    adc #>$3e8
    sta.z end+1
  __b2:
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
    rts
  __b3:
    lda #0
    tay
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
// Creates the pre-shifted bobs into BOB_CHARSET and populates the BOB_TABLES
// Modifies PROTO_BOB by shifting it around
prepareBobs: {
    .label bob_table = $d
    .label shift_y = 2
    // Populate charset and tables
    .label bob_glyph = 5
    .label cell = 7
    .label bob_table_idx = 3
    .label shift_x = 4
    lda #<PROTO_BOB+$30
    sta.z bobCharsetFindOrAddGlyph.bob_glyph
    lda #>PROTO_BOB+$30
    sta.z bobCharsetFindOrAddGlyph.bob_glyph+1
    lda #0
    sta.z bob_charset_next_id
    jsr bobCharsetFindOrAddGlyph
    lda #0
    sta.z bob_table_idx
    sta.z shift_y
  __b1:
    lda.z shift_y
    cmp #BOB_SHIFTS_Y
    bcc b1
    rts
  b1:
    lda #0
    sta.z shift_x
  __b2:
    lda.z shift_x
    cmp #BOB_SHIFTS_X
    bcc __b3
    jsr shiftProtoBobDown
    inc.z shift_y
    jmp __b1
  __b3:
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
    lda.z cell
    cmp #9
    bcc __b6
    inc.z bob_table_idx
    jsr shiftProtoBobRight
    jsr shiftProtoBobRight
    inc.z shift_x
    jmp __b2
  __b6:
    jsr bobCharsetFindOrAddGlyph
    lda.z bobCharsetFindOrAddGlyph.glyph_id
    // Look for an existing char in BOB_CHARSET 
    ldy #0
    sta (bob_table),y
    // Move to the next glyph
    lda #8
    clc
    adc.z bob_glyph
    sta.z bob_glyph
    bcc !+
    inc.z bob_glyph+1
  !:
    // Move to the next sub-table
    lda #BOB_SHIFTS_X*BOB_SHIFTS_Y
    clc
    adc.z bob_table
    sta.z bob_table
    bcc !+
    inc.z bob_table+1
  !:
    inc.z cell
    jmp __b5
}
// Looks through BOB_CHARSET to find the passed bob glyph if present.
// If not present it is added
// Returns the glyph ID
// bobCharsetFindOrAddGlyph(byte* zeropage(5) bob_glyph)
bobCharsetFindOrAddGlyph: {
    .label bob_glyph = 5
    .label i = $c
    .label glyph_id = 8
    .label glyph_cursor = $a
    lda #<BOB_CHARSET
    sta.z glyph_cursor
    lda #>BOB_CHARSET
    sta.z glyph_cursor+1
    lda #0
    sta.z glyph_id
  __b1:
    lda.z glyph_id
    cmp.z bob_charset_next_id
    bne b1
    ldy #0
  // Not found - add it
  __b7:
    cpy #8
    bcc __b8
    inc.z bob_charset_next_id
    rts
  __b8:
    lda (bob_glyph),y
    sta (glyph_cursor),y
    iny
    jmp __b7
  b1:
    lda #0
    sta.z i
  __b2:
    lda.z i
    cmp #8
    bcc __b3
    lda #1
    jmp __b5
  __b3:
    ldy.z i
    lda (glyph_cursor),y
    tax
    lda (bob_glyph),y
    tay
    sty.z $ff
    cpx.z $ff
    beq __b4
    lda #0
  __b5:
    cmp #0
    beq __b6
    rts
  __b6:
    inc.z glyph_id
    lda #8
    clc
    adc.z glyph_cursor
    sta.z glyph_cursor
    bcc !+
    inc.z glyph_cursor+1
  !:
    jmp __b1
  __b4:
    inc.z i
    jmp __b2
}
// Shift PROTO_BOB right one X pixel
shiftProtoBobRight: {
    .label carry = 8
    .label i = 7
    ldy #0
    ldx #0
    txa
    sta.z i
  __b1:
    lda.z i
    cmp #3*3*8
    bcc __b2
    rts
  __b2:
    lda #1
    and PROTO_BOB,x
    cmp #0
    bne __b3
    lda #0
    sta.z carry
    jmp __b4
  __b3:
    lda #$80
    sta.z carry
  __b4:
    lda PROTO_BOB,x
    lsr
    sty.z $ff
    ora.z $ff
    // Shift value and add old carry
    sta PROTO_BOB,x
    // Increment j to iterate over the PROTO_BOB left-to-right, top-to-bottom (0, 24, 48, 1, 25, 49, ...)
    cpx #$30
    bcs __b5
    txa
    axs #-[$18]
  __b6:
    inc.z i
    ldy.z carry
    jmp __b1
  __b5:
    txa
    axs #$2f
    jmp __b6
}
// Shift PROTO_BOB down one Y pixel
// At the same time restore PROTO_BOB X by shifting 8 pixels left
shiftProtoBobDown: {
    ldx #$17
  __b1:
    cpx #0
    bne __b2
    lda #0
    sta PROTO_BOB
    sta PROTO_BOB+$18
    sta PROTO_BOB+$30
    rts
  __b2:
    lda PROTO_BOB+$17,x
    sta PROTO_BOB,x
    lda PROTO_BOB+$2f,x
    sta PROTO_BOB+$18,x
    lda #0
    sta PROTO_BOB+$30,x
    dex
    jmp __b1
}
  // Keyboard row bitmask as expected by CIA#1 Port A when reading a specific keyboard matrix row (rows are numbered 0-7)
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  // Keyboard matrix column bitmasks for a specific keybooard matrix column when reading the keyboard. (columns are numbered 0-7)
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
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

  // Sine used for the X-coordinate
SIN_X_TAB:
.fill $200, 75.5+75.5*sin(i*2*PI/256) 
  // Sine used for the Y-coordinate
SIN_Y_TAB:
.fill $200, 91.5+91.5*sin(i*2*PI/256) 
  // Tables containing the char to use for a specific cell of a shifted BOB.
  // char_id = BOB_TABLES[cell*BOB_SUBTABLE_SIZE + shift_y*BOB_SHIFTS_X + shift_x];
  BOB_TABLES: .fill 9*8*4, 0
