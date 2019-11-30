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
  .label COS = SIN+$40
  // BOB charset ID of the next glyph to be added
  .label bob_charset_next_id = $f
  // Current index within the progress cursor (0-7)
  .label progress_idx = 3
  // Current position of the progress cursor
  .label progress_cursor = 6
  // Constants for KickAsm Vogel Sunflower
  .const PHI = (1+sqrt(5))/2


main: {
    .const vicSelectGfxBank1_toDd001_return = 3
    .const vicSelectGfxBank2_toDd001_return = 3
    .const toD0181_return = (>(BOB_SCREEN&$3fff)*4)|(>BOB_CHARSET)/4&$f
    .const toD0182_return = (>(SCREEN_BASIC&$3fff)*4)|(>CHARSET_BASIC)/4&$f
    .label __9 = 6
    .label __11 = 6
    .label __12 = 6
    .label x = $b
    .label y = 6
    .label a = 4
    .label r = 3
    .label i = 5
    // Render Rotated BOBs
    .label angle = 2
    jsr mulf_init
    jsr prepareBobs
    jsr renderBobInit
    lda #3
    sta CIA2_PORT_A_DDR
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2_PORT_A
    lda #toD0181_return
    sta D018
    jsr memset
    lda #0
    sta.z angle
  __b2:
    lda RASTER
    cmp #$f8
    bcc __b2
    lda.z angle
    sta.z a
    lda #0
    sta.z i
    lda #$1e
    sta.z r
  __b4:
    //kickasm {{ .break }}
    lda #1
    sta BORDERCOL
    lda.z r
    ldy.z a
    ldx COS,y
    jsr mulf8s
    lda.z __9
    clc
    adc #<$4b*$100
    sta.z x
    lda.z __9+1
    adc #>$4b*$100
    sta.z x+1
    lda.z r
    ldy.z a
    ldx SIN,y
    jsr mulf8s
    asl.z __12
    rol.z __12+1
    clc
    lda.z y
    adc #<$5a*$100
    sta.z y
    lda.z y+1
    adc #>$5a*$100
    sta.z y+1
    lda #2
    sta BORDERCOL
    lax.z a
    axs #-[$62]
    stx.z a
    lax.z r
    axs #-[3]
    stx.z r
    lda.z x+1
    sta.z renderBob.xpos
    lda.z y+1
    tax
    jsr renderBob
    inc.z i
    lda #$1a
    cmp.z i
    bne __b4
    lax.z angle
    axs #-[3]
    stx.z angle
    lda #0
    sta BORDERCOL
    jsr keyboard_key_pressed
    cmp #0
    bne __b6
    jmp __b2
  // Wait for space release
  __b6:
    jsr keyboard_key_pressed
    cmp #0
    bne __b6
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
// renderBob(byte zeropage($f) xpos, byte register(X) ypos)
renderBob: {
    .label __2 = $10
    .label __5 = $e
    .label xpos = $f
    .label x_char_offset = $d
    .label y_offset = $10
    .label screen = $10
    lda.z xpos
    lsr
    lsr
    sta.z x_char_offset
    txa
    lsr
    lsr
    lsr
    asl
    //unsigned int y_offset = (unsigned int)y_char_offset*40;
    tay
    lda RENDERBOB_YOFFSET,y
    sta.z y_offset
    lda RENDERBOB_YOFFSET+1,y
    sta.z y_offset+1
    clc
    lda.z __2
    adc #<BOB_SCREEN
    sta.z __2
    lda.z __2+1
    adc #>BOB_SCREEN
    sta.z __2+1
    lda.z x_char_offset
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    txa
    and #7
    asl
    asl
    sta.z __5
    lda #3
    and.z xpos
    clc
    adc.z __5
    tax
    lda BOB_TABLES,x
    ldy #0
    sta (screen),y
    lda BOB_TABLES+1*BOB_SUBTABLE_SIZE,x
    ldy #$28
    sta (screen),y
    lda BOB_TABLES+2*BOB_SUBTABLE_SIZE,x
    ldy #$50
    sta (screen),y
    lda BOB_TABLES+3*BOB_SUBTABLE_SIZE,x
    ldy #1
    sta (screen),y
    lda BOB_TABLES+4*BOB_SUBTABLE_SIZE,x
    ldy #$29
    sta (screen),y
    lda BOB_TABLES+5*BOB_SUBTABLE_SIZE,x
    ldy #$51
    sta (screen),y
    lda BOB_TABLES+6*BOB_SUBTABLE_SIZE,x
    ldy #2
    sta (screen),y
    lda BOB_TABLES+7*BOB_SUBTABLE_SIZE,x
    ldy #$2a
    sta (screen),y
    lda BOB_TABLES+8*BOB_SUBTABLE_SIZE,x
    ldy #$52
    sta (screen),y
    rts
}
// Fast multiply two signed bytes to a word result
// mulf8s(signed byte register(A) a, signed byte register(X) b)
mulf8s: {
    .label return = 6
    jsr mulf8u_prepare
    stx.z mulf8s_prepared.b
    jsr mulf8s_prepared
    rts
}
// Calculate fast multiply with a prepared unsigned byte to a word result
// The prepared number is set by calling mulf8s_prepare(byte a)
// mulf8s_prepared(signed byte zeropage($f) b)
mulf8s_prepared: {
    .label memA = $fd
    .label m = 6
    .label b = $f
    lda.z b
    jsr mulf8u_prepared
    lda memA
    cmp #0
    bpl __b1
    lda.z m+1
    sec
    sbc.z b
    sta.z m+1
  __b1:
    lda.z b
    cmp #0
    bpl __b2
    lda.z m+1
    sec
    sbc memA
    sta.z m+1
  __b2:
    rts
}
// Calculate fast multiply with a prepared unsigned byte to a word result
// The prepared number is set by calling mulf8u_prepare(byte a)
// mulf8u_prepared(byte register(A) b)
mulf8u_prepared: {
    .label resL = $fe
    .label memB = $ff
    .label return = 6
    sta memB
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
    lda resL
    sta.z return
    lda memB
    sta.z return+1
    rts
}
// Prepare for fast multiply with an unsigned byte to a word result
// mulf8u_prepare(byte register(A) a)
mulf8u_prepare: {
    .label memA = $fd
    sta memA
    sta mulf8u_prepared.sm1+1
    sta mulf8u_prepared.sm3+1
    eor #$ff
    sta mulf8u_prepared.sm2+1
    sta mulf8u_prepared.sm4+1
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
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    rts
  __b2:
    lda #c
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
// Initialize the tables used by renderBob()
renderBobInit: {
    .label __0 = $10
    .label __1 = $10
    .label __4 = $12
    .label __5 = $10
    ldx #0
  __b1:
    txa
    sta.z __0
    lda #0
    sta.z __0+1
    lda.z __0
    asl
    sta.z __4
    lda.z __0+1
    rol
    sta.z __4+1
    asl.z __4
    rol.z __4+1
    lda.z __5
    clc
    adc.z __4
    sta.z __5
    lda.z __5+1
    adc.z __4+1
    sta.z __5+1
    asl.z __1
    rol.z __1+1
    asl.z __1
    rol.z __1+1
    asl.z __1
    rol.z __1+1
    txa
    asl
    tay
    lda.z __1
    sta RENDERBOB_YOFFSET,y
    lda.z __1+1
    sta RENDERBOB_YOFFSET+1,y
    inx
    cpx #$20
    bne __b1
    rts
}
// Creates the pre-shifted bobs into BOB_CHARSET and populates the BOB_TABLES
// Modifies PROTO_BOB by shifting it around
prepareBobs: {
    .label bob_table = $12
    .label shift_y = 2
    // Populate charset and tables
    .label bob_glyph = $10
    .label cell = $d
    .label bob_table_idx = 4
    .label shift_x = 5
    jsr progress_init
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
    jsr progress_inc
    inc.z cell
    jmp __b5
}
// Increase PETSCII progress one bit
// Done by increasing the character until the idx is 8 and then moving to the next char
progress_inc: {
    inc.z progress_idx
    lda #8
    cmp.z progress_idx
    bne __b1
    lda progress_chars+8
    ldy #0
    sta (progress_cursor),y
    inc.z progress_cursor
    bne !+
    inc.z progress_cursor+1
  !:
    lda #0
    sta.z progress_idx
  __b1:
    ldy.z progress_idx
    lda progress_chars,y
    ldy #0
    sta (progress_cursor),y
    rts
    // Progress characters
    progress_chars: .byte $20, $65, $74, $75, $61, $f6, $e7, $ea, $e0
}
// Looks through BOB_CHARSET to find the passed bob glyph if present.
// If not present it is added
// Returns the glyph ID
// bobCharsetFindOrAddGlyph(byte* zeropage($10) bob_glyph)
bobCharsetFindOrAddGlyph: {
    .label bob_glyph = $10
    .label i = $a
    .label glyph_id = $e
    .label glyph_cursor = 8
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
    .label carry = $e
    .label i = $d
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
// Initialize the PETSCII progress bar
progress_init: {
    rts
}
// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x/4)
mulf_init: {
    // x/2
    .label c = $f
    // Counter used for determining x%2==0
    .label sqr1_hi = $10
    // Fill mulf_sqr1 = f(x) = int(x*x/4): If f(x) = x*x/4 then f(x+1) = f(x) + x/2 + 1/4
    .label sqr = $b
    .label sqr1_lo = 6
    // Decrease or increase x_255 - initially we decrease
    .label sqr2_hi = 8
    .label sqr2_lo = $12
    //Start with g(0)=f(255)
    .label dir = $a
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
    lda.z sqr2_lo+1
    cmp #>mulf_sqr2_lo+$1ff
    bne __b6
    lda.z sqr2_lo
    cmp #<mulf_sqr2_lo+$1ff
    bne __b6
    // Set the very last value g(511) = f(256)
    lda mulf_sqr1_lo+$100
    sta mulf_sqr2_lo+$1ff
    lda mulf_sqr1_hi+$100
    sta mulf_sqr2_hi+$1ff
    rts
  __b6:
    lda mulf_sqr1_lo,x
    ldy #0
    sta (sqr2_lo),y
    lda mulf_sqr1_hi,x
    sta (sqr2_hi),y
    inc.z sqr2_hi
    bne !+
    inc.z sqr2_hi+1
  !:
    txa
    clc
    adc.z dir
    tax
    cpx #0
    bne __b8
    lda #1
    sta.z dir
  __b8:
    inc.z sqr2_lo
    bne !+
    inc.z sqr2_lo+1
  !:
    jmp __b5
  __b2:
    inc.z c
    lda #1
    and.z c
    cmp #0
    bne __b3
    inx
    inc.z sqr
    bne !+
    inc.z sqr+1
  !:
  __b3:
    lda.z sqr
    ldy #0
    sta (sqr1_lo),y
    lda.z sqr+1
    sta (sqr1_hi),y
    inc.z sqr1_hi
    bne !+
    inc.z sqr1_hi+1
  !:
    txa
    clc
    adc.z sqr
    sta.z sqr
    bcc !+
    inc.z sqr+1
  !:
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
  // Table for getting BOB screen offset from the BOB Y-position
  RENDERBOB_YOFFSET: .fill 2*$20, 0
