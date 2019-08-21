// Plasma based on the distance/angle to the screen center
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
  .label D018 = $d018
  // Color Ram
  .label COLS = $d800
  // The colors of the C64
  .const BLACK = 0
  // Top of the heap used by malloc()
  .label HEAP_TOP = $a000
  // The number of iterations performed during 16-bit CORDIC atan2 calculation
  .const CORDIC_ITERATIONS_16 = $f
  .label print_line_cursor = $400
  // SID registers for random number generation
  .label SID_VOICE3_FREQ = $d40e
  .label SID_VOICE3_CONTROL = $d412
  .const SID_CONTROL_NOISE = $80
  .label SID_VOICE3_OSC = $d41b
  // Plasma charset
  .label CHARSET = $2000
  // Plasma screen 1
  .label SCREEN1 = $2800
  // Plasma screen 2
  .label SCREEN2 = $2c00
  .const NUM_SQUARES = $30
  .label heap_head = 9
  .label SQUARES = $13
  .label print_char_cursor = 7
  // Screen containing distance to center
  .label SCREEN_DIST = $b
  // Screen containing angle to center
  .label SCREEN_ANGLE = $d
  .label sin_offset_x = 2
  .label sin_offset_y = $11
bbegin:
  lda #<$3e8
  sta.z malloc.size
  lda #>$3e8
  sta.z malloc.size+1
  lda #<HEAP_TOP
  sta.z heap_head
  lda #>HEAP_TOP
  sta.z heap_head+1
  jsr malloc
  lda.z malloc.mem
  sta.z SCREEN_DIST
  lda.z malloc.mem+1
  sta.z SCREEN_DIST+1
  lda #<$3e8
  sta.z malloc.size
  lda #>$3e8
  sta.z malloc.size+1
  jsr malloc
  lda.z malloc.mem
  sta.z SCREEN_ANGLE
  lda.z malloc.mem+1
  sta.z SCREEN_ANGLE+1
  jsr main
  rts
main: {
    .const toD0181_return = (>(SCREEN1&$3fff)*4)|(>CHARSET)/4&$f
    .const toD0182_return = (>(SCREEN2&$3fff)*4)|(>CHARSET)/4&$f
    lda.z SCREEN_DIST
    sta.z init_dist_screen.screen
    lda.z SCREEN_DIST+1
    sta.z init_dist_screen.screen+1
    jsr init_dist_screen
    lda.z SCREEN_ANGLE
    sta.z init_angle_screen.screen
    lda.z SCREEN_ANGLE+1
    sta.z init_angle_screen.screen+1
    jsr init_angle_screen
    jsr make_plasma_charset
    ldx #BLACK
    lda #<COLS
    sta.z memset.str
    lda #>COLS
    sta.z memset.str+1
    jsr memset
    lda #0
    sta.z sin_offset_y
    sta.z sin_offset_x
  // Show double-buffered plasma
  b2:
    lda #<SCREEN1
    sta.z doplasma.screen
    lda #>SCREEN1
    sta.z doplasma.screen+1
    jsr doplasma
    lda #toD0181_return
    sta D018
    lda #<SCREEN2
    sta.z doplasma.screen
    lda #>SCREEN2
    sta.z doplasma.screen+1
    jsr doplasma
    lda #toD0182_return
    sta D018
    jmp b2
}
// Render plasma to the passed screen
// doplasma(byte* zeropage(7) screen)
doplasma: {
    .label angle = 3
    .label dist = 5
    .label sin_x = $13
    .label sin_y = $f
    .label screen = 7
    .label y = $12
    lda.z SCREEN_ANGLE
    sta.z angle
    lda.z SCREEN_ANGLE+1
    sta.z angle+1
    lda.z SCREEN_DIST
    sta.z dist
    lda.z SCREEN_DIST+1
    sta.z dist+1
    lda.z sin_offset_x
    clc
    adc #<SINTABLE
    sta.z sin_x
    lda #>SINTABLE
    adc #0
    sta.z sin_x+1
    lda.z sin_offset_y
    clc
    adc #<SINTABLE
    sta.z sin_y
    lda #>SINTABLE
    adc #0
    sta.z sin_y+1
    lda #0
    sta.z y
  b1:
    ldx #0
  b2:
    txa
    tay
    lda (dist),y
    sta.z $ff
    lda (angle),y
    tay
    lda (sin_x),y
    ldy.z $ff
    clc
    adc (sin_y),y
    stx.z $ff
    ldy.z $ff
    sta (screen),y
    inx
    cpx #$28
    bne b2
    lda #$28
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    lda #$28
    clc
    adc.z angle
    sta.z angle
    bcc !+
    inc.z angle+1
  !:
    lda #$28
    clc
    adc.z dist
    sta.z dist
    bcc !+
    inc.z dist+1
  !:
    inc.z y
    lda #$1a
    cmp.z y
    bne b1
    lax.z sin_offset_x
    axs #3
    stx.z sin_offset_x
    lax.z sin_offset_y
    axs #7
    stx.z sin_offset_y
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage(3) str, byte register(X) c)
memset: {
    .label end = $f
    .label dst = 3
    .label str = 3
    lda.z str
    clc
    adc #<$3e8
    sta.z end
    lda.z str+1
    adc #>$3e8
    sta.z end+1
  b2:
    lda.z dst+1
    cmp.z end+1
    bne b3
    lda.z dst
    cmp.z end
    bne b3
    rts
  b3:
    txa
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp b2
}
// Make a plasma-friendly charset where the chars are randomly filled
make_plasma_charset: {
    .label _7 = $12
    .label _10 = $13
    .label _11 = $13
    .label s = $11
    .label i = 2
    .label c = 5
    .label _16 = $13
    jsr sid_rnd_init
    jsr print_cls
    lda #<print_line_cursor
    sta.z print_char_cursor
    lda #>print_line_cursor
    sta.z print_char_cursor+1
    lda #<0
    sta.z c
    sta.z c+1
  b2:
    lda.z c
    tay
    lda SINTABLE,y
    sta.z s
    lda #0
    sta.z i
  b4:
    ldy #0
    ldx #0
  b7:
    jsr sid_rnd
    and #$ff
    sta.z _7
    lda.z s
    cmp.z _7
    bcs b9
    tya
    ora bittab,x
    tay
  b9:
    inx
    cpx #8
    bcc b7
    lda.z c
    asl
    sta.z _10
    lda.z c+1
    rol
    sta.z _10+1
    asl.z _10
    rol.z _10+1
    asl.z _10
    rol.z _10+1
    lda.z i
    clc
    adc.z _11
    sta.z _11
    bcc !+
    inc.z _11+1
  !:
    clc
    lda.z _16
    adc #<CHARSET
    sta.z _16
    lda.z _16+1
    adc #>CHARSET
    sta.z _16+1
    tya
    ldy #0
    sta (_16),y
    inc.z i
    lda.z i
    cmp #8
    bcc b4
    lda #7
    and.z c
    cmp #0
    bne b12
    jsr print_char
  b12:
    inc.z c
    bne !+
    inc.z c+1
  !:
    lda.z c+1
    cmp #>$100
    bcc b2
    bne !+
    lda.z c
    cmp #<$100
    bcc b2
  !:
    rts
    bittab: .byte 1, 2, 4, 8, $10, $20, $40, $80
}
// Print a single char
print_char: {
    .const ch = '.'
    lda #ch
    ldy #0
    sta (print_char_cursor),y
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    rts
}
// Get a random number from the SID voice 3,
// Must be initialized with sid_rnd_init()
sid_rnd: {
    lda SID_VOICE3_OSC
    rts
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    ldx #' '
    lda #<print_line_cursor
    sta.z memset.str
    lda #>print_line_cursor
    sta.z memset.str+1
    jsr memset
    rts
}
// Initialize SID voice 3 for random number generation
sid_rnd_init: {
    lda #<$ffff
    sta SID_VOICE3_FREQ
    lda #>$ffff
    sta SID_VOICE3_FREQ+1
    lda #SID_CONTROL_NOISE
    sta SID_VOICE3_CONTROL
    rts
}
// Populates 1000 bytes (a screen) with values representing the angle to the center.
// Utilizes symmetry around the  center
// init_angle_screen(byte* zeropage(5) screen)
init_angle_screen: {
    .label _11 = $18
    .label screen = 5
    .label screen_topline = 3
    .label screen_bottomline = 5
    .label xw = $13
    .label yw = $16
    .label angle_w = $18
    .label ang_w = $15
    .label x = $12
    .label xb = 2
    .label y = $11
    lda.z screen
    clc
    adc #<$28*$c
    sta.z screen_topline
    lda.z screen+1
    adc #>$28*$c
    sta.z screen_topline+1
    clc
    lda.z screen_bottomline
    adc #<$28*$c
    sta.z screen_bottomline
    lda.z screen_bottomline+1
    adc #>$28*$c
    sta.z screen_bottomline+1
    lda #0
    sta.z y
  b1:
    lda #$27
    sta.z xb
    lda #0
    sta.z x
  b3:
    lda.z x
    asl
    eor #$ff
    clc
    adc #$27+1
    ldy #0
    sta.z xw+1
    sty.z xw
    lda.z y
    asl
    sta.z yw+1
    sty.z yw
    jsr atan2_16
    lda #$80
    clc
    adc.z _11
    sta.z _11
    bcc !+
    inc.z _11+1
  !:
    lda.z _11+1
    sta.z ang_w
    ldy.z xb
    sta (screen_bottomline),y
    eor #$ff
    clc
    adc #1
    sta (screen_topline),y
    lda #$80
    clc
    adc.z ang_w
    ldy.z x
    sta (screen_topline),y
    lda #$80
    sec
    sbc.z ang_w
    sta (screen_bottomline),y
    inc.z x
    dec.z xb
    lda.z x
    cmp #$13+1
    bcc b3
    lda.z screen_topline
    sec
    sbc #<$28
    sta.z screen_topline
    lda.z screen_topline+1
    sbc #>$28
    sta.z screen_topline+1
    lda #$28
    clc
    adc.z screen_bottomline
    sta.z screen_bottomline
    bcc !+
    inc.z screen_bottomline+1
  !:
    inc.z y
    lda #$d
    cmp.z y
    bne b1
    rts
}
// Find the atan2(x, y) - which is the angle of the line from (0,0) to (x,y)
// Finding the angle requires a binary search using CORDIC_ITERATIONS_16
// Returns the angle in hex-degrees (0=0, 0x8000=PI, 0x10000=2*PI)
// atan2_16(signed word zeropage($13) x, signed word zeropage($16) y)
atan2_16: {
    .label _2 = 7
    .label _7 = $f
    .label yi = 7
    .label xi = $f
    .label angle = $18
    .label xd = 9
    .label yd = $1a
    .label return = $18
    .label x = $13
    .label y = $16
    lda.z y+1
    bmi !b1+
    jmp b1
  !b1:
    sec
    lda #0
    sbc.z y
    sta.z _2
    lda #0
    sbc.z y+1
    sta.z _2+1
  b3:
    lda.z x+1
    bmi !b4+
    jmp b4
  !b4:
    sec
    lda #0
    sbc.z x
    sta.z _7
    lda #0
    sbc.z x+1
    sta.z _7+1
  b6:
    lda #<0
    sta.z angle
    sta.z angle+1
    tax
  b10:
    lda.z yi+1
    bne b11
    lda.z yi
    bne b11
  b12:
    lsr.z angle+1
    ror.z angle
    lda.z x+1
    bpl b7
    sec
    lda #<$8000
    sbc.z angle
    sta.z angle
    lda #>$8000
    sbc.z angle+1
    sta.z angle+1
  b7:
    lda.z y+1
    bpl b8
    sec
    lda #0
    sbc.z angle
    sta.z angle
    lda #0
    sbc.z angle+1
    sta.z angle+1
  b8:
    rts
  b11:
    txa
    tay
    lda.z xi
    sta.z xd
    lda.z xi+1
    sta.z xd+1
    lda.z yi
    sta.z yd
    lda.z yi+1
    sta.z yd+1
  b13:
    cpy #2
    bcs b14
    cpy #0
    beq b17
    lda.z xd+1
    cmp #$80
    ror.z xd+1
    ror.z xd
    lda.z yd+1
    cmp #$80
    ror.z yd+1
    ror.z yd
  b17:
    lda.z yi+1
    bpl b18
    lda.z xi
    sec
    sbc.z yd
    sta.z xi
    lda.z xi+1
    sbc.z yd+1
    sta.z xi+1
    lda.z yi
    clc
    adc.z xd
    sta.z yi
    lda.z yi+1
    adc.z xd+1
    sta.z yi+1
    txa
    asl
    tay
    sec
    lda.z angle
    sbc CORDIC_ATAN2_ANGLES_16,y
    sta.z angle
    lda.z angle+1
    sbc CORDIC_ATAN2_ANGLES_16+1,y
    sta.z angle+1
  b19:
    inx
    cpx #CORDIC_ITERATIONS_16-1+1
    bne !b12+
    jmp b12
  !b12:
    jmp b10
  b18:
    lda.z xi
    clc
    adc.z yd
    sta.z xi
    lda.z xi+1
    adc.z yd+1
    sta.z xi+1
    lda.z yi
    sec
    sbc.z xd
    sta.z yi
    lda.z yi+1
    sbc.z xd+1
    sta.z yi+1
    txa
    asl
    tay
    clc
    lda.z angle
    adc CORDIC_ATAN2_ANGLES_16,y
    sta.z angle
    lda.z angle+1
    adc CORDIC_ATAN2_ANGLES_16+1,y
    sta.z angle+1
    jmp b19
  b14:
    lda.z xd+1
    cmp #$80
    ror.z xd+1
    ror.z xd
    lda.z xd+1
    cmp #$80
    ror.z xd+1
    ror.z xd
    lda.z yd+1
    cmp #$80
    ror.z yd+1
    ror.z yd
    lda.z yd+1
    cmp #$80
    ror.z yd+1
    ror.z yd
    dey
    dey
    jmp b13
  b4:
    lda.z x
    sta.z xi
    lda.z x+1
    sta.z xi+1
    jmp b6
  b1:
    lda.z y
    sta.z yi
    lda.z y+1
    sta.z yi+1
    jmp b3
}
// Populates 1000 bytes (a screen) with values representing the distance to the center.
// The actual value stored is distance*2 to increase precision
// init_dist_screen(byte* zeropage(3) screen)
init_dist_screen: {
    .label screen = 3
    .label screen_bottomline = 5
    .label yds = $16
    .label screen_topline = 3
    .label y = 2
    .label xds = $18
    .label ds = $18
    .label x = $11
    .label xb = $12
    jsr init_squares
    lda.z screen
    clc
    adc #<$28*$18
    sta.z screen_bottomline
    lda.z screen+1
    adc #>$28*$18
    sta.z screen_bottomline+1
    lda #0
    sta.z y
  b1:
    lda.z y
    asl
    cmp #$18
    bcs b2
    eor #$ff
    clc
    adc #$18+1
  b4:
    jsr sqr
    lda.z sqr.return
    sta.z sqr.return_2
    lda.z sqr.return+1
    sta.z sqr.return_2+1
    lda #$27
    sta.z xb
    lda #0
    sta.z x
  b6:
    lda.z x
    asl
    cmp #$27
    bcs b8
    eor #$ff
    clc
    adc #$27+1
  b10:
    jsr sqr
    lda.z ds
    clc
    adc.z yds
    sta.z ds
    lda.z ds+1
    adc.z yds+1
    sta.z ds+1
    jsr sqrt
    ldy.z x
    sta (screen_topline),y
    sta (screen_bottomline),y
    ldy.z xb
    sta (screen_topline),y
    sta (screen_bottomline),y
    inc.z x
    dec.z xb
    lda.z x
    cmp #$13+1
    bcc b6
    lda #$28
    clc
    adc.z screen_topline
    sta.z screen_topline
    bcc !+
    inc.z screen_topline+1
  !:
    lda.z screen_bottomline
    sec
    sbc #<$28
    sta.z screen_bottomline
    lda.z screen_bottomline+1
    sbc #>$28
    sta.z screen_bottomline+1
    inc.z y
    lda #$d
    cmp.z y
    bne b1
    rts
  b8:
    sec
    sbc #$27
    jmp b10
  b2:
    sec
    sbc #$18
    jmp b4
}
// Find the (integer) square root of a word value
// If the square is not an integer then it returns the largest integer N where N*N <= val
// Uses a table of squares that must be initialized by calling init_squares()
// sqrt(word zeropage($18) val)
sqrt: {
    .label _1 = $f
    .label _3 = $f
    .label found = $f
    .label val = $18
    lda.z SQUARES
    sta.z bsearch16u.items_1
    lda.z SQUARES+1
    sta.z bsearch16u.items_1+1
    jsr bsearch16u
    lda.z _3
    sec
    sbc.z SQUARES
    sta.z _3
    lda.z _3+1
    sbc.z SQUARES+1
    sta.z _3+1
    lsr.z _1+1
    ror.z _1
    lda.z _1
    rts
}
// Searches an array of nitems unsigned words, the initial member of which is pointed to by base, for a member that matches the value key.
// - key - The value to look for
// - items - Pointer to the start of the array to search in
// - num - The number of items in the array
// Returns pointer to an entry in the array that matches the search key
// bsearch16u(word zeropage($18) key, word* zeropage($f) items, byte register(X) num)
bsearch16u: {
    .label _2 = $f
    .label pivot = $f
    .label result = $1a
    .label return = $f
    .label items = $f
    .label key = $18
    .label items_1 = 7
    .label items_10 = 7
    .label items_16 = 7
    ldx #NUM_SQUARES
  b4:
    txa
    lsr
    asl
    clc
    adc.z items_10
    sta.z pivot
    lda #0
    adc.z items_10+1
    sta.z pivot+1
    sec
    lda.z key
    ldy #0
    sbc (pivot),y
    sta.z result
    lda.z key+1
    iny
    sbc (pivot),y
    sta.z result+1
    bne b6
    lda.z result
    bne b6
  breturn:
    rts
  b6:
    lda.z result+1
    bmi b10
    bne !+
    lda.z result
    beq b10
  !:
    lda #1*SIZEOF_WORD
    clc
    adc.z items
    sta.z items
    bcc !+
    inc.z items+1
  !:
    dex
  b7:
    txa
    lsr
    tax
    cpx #0
    bne b9
    ldy #1
    lda (items),y
    cmp.z key+1
    bne !+
    dey
    lda (items),y
    cmp.z key
    beq breturn
  !:
    bcc breturn
    lda.z _2
    sec
    sbc #<1*SIZEOF_WORD
    sta.z _2
    lda.z _2+1
    sbc #>1*SIZEOF_WORD
    sta.z _2+1
    rts
  b9:
    lda.z items
    sta.z items_16
    lda.z items+1
    sta.z items_16+1
    jmp b4
  b10:
    lda.z items_10
    sta.z items
    lda.z items_10+1
    sta.z items+1
    jmp b7
}
// Find the square of a byte value
// Uses a table of squares that must be initialized by calling init_squares()
// sqr(byte register(A) val)
sqr: {
    .label return = $18
    .label return_2 = $16
    asl
    tay
    lda (SQUARES),y
    sta.z return
    iny
    lda (SQUARES),y
    sta.z return+1
    rts
}
// Initialize squares table
// Uses iterative formula (x+1)^2 = x^2 + 2*x + 1
init_squares: {
    .label squares = $1a
    .label sqr = $18
    lda #<NUM_SQUARES*SIZEOF_WORD
    sta.z malloc.size
    lda #>NUM_SQUARES*SIZEOF_WORD
    sta.z malloc.size+1
    jsr malloc
    lda.z SQUARES
    sta.z squares
    lda.z SQUARES+1
    sta.z squares+1
    ldx #0
    txa
    sta.z sqr
    sta.z sqr+1
  b1:
    ldy #0
    lda.z sqr
    sta (squares),y
    iny
    lda.z sqr+1
    sta (squares),y
    lda #SIZEOF_WORD
    clc
    adc.z squares
    sta.z squares
    bcc !+
    inc.z squares+1
  !:
    txa
    asl
    clc
    adc #1
    clc
    adc.z sqr
    sta.z sqr
    bcc !+
    inc.z sqr+1
  !:
    inx
    cpx #NUM_SQUARES-1+1
    bne b1
    rts
}
// Allocates a block of size bytes of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
// malloc(word zeropage($13) size)
malloc: {
    .label mem = $13
    .label size = $13
    lda.z heap_head
    sec
    sbc.z mem
    sta.z mem
    lda.z heap_head+1
    sbc.z mem+1
    sta.z mem+1
    lda.z mem
    sta.z heap_head
    lda.z mem+1
    sta.z heap_head+1
    rts
}
  // Angles representing ATAN(0.5), ATAN(0.25), ATAN(0.125), ...
CORDIC_ATAN2_ANGLES_16:
.for (var i=0; i<CORDIC_ITERATIONS_16; i++)
        .word 256*2*256*atan(1/pow(2,i))/PI/2

  .align $100
SINTABLE:
.for(var i=0;i<$200;i++)
        .byte round(127.5+127.5*sin(2*PI*i/256))

