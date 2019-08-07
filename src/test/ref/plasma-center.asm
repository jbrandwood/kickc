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
  sta malloc.size
  lda #>$3e8
  sta malloc.size+1
  lda #<HEAP_TOP
  sta heap_head
  lda #>HEAP_TOP
  sta heap_head+1
  jsr malloc
  lda malloc.mem
  sta SCREEN_DIST
  lda malloc.mem+1
  sta SCREEN_DIST+1
  lda #<$3e8
  sta malloc.size
  lda #>$3e8
  sta malloc.size+1
  jsr malloc
  lda malloc.mem
  sta SCREEN_ANGLE
  lda malloc.mem+1
  sta SCREEN_ANGLE+1
  jsr main
  rts
main: {
    .const toD0181_return = (>(SCREEN1&$3fff)*4)|(>CHARSET)/4&$f
    .const toD0182_return = (>(SCREEN2&$3fff)*4)|(>CHARSET)/4&$f
    lda SCREEN_DIST
    sta init_dist_screen.screen
    lda SCREEN_DIST+1
    sta init_dist_screen.screen+1
    jsr init_dist_screen
    lda SCREEN_ANGLE
    sta init_angle_screen.screen
    lda SCREEN_ANGLE+1
    sta init_angle_screen.screen+1
    jsr init_angle_screen
    jsr make_plasma_charset
    ldx #BLACK
    lda #<COLS
    sta memset.str
    lda #>COLS
    sta memset.str+1
    jsr memset
    lda #0
    sta sin_offset_y
    sta sin_offset_x
  // Show double-buffered plasma
  b2:
    lda #<SCREEN1
    sta doplasma.screen
    lda #>SCREEN1
    sta doplasma.screen+1
    jsr doplasma
    lda #toD0181_return
    sta D018
    lda #<SCREEN2
    sta doplasma.screen
    lda #>SCREEN2
    sta doplasma.screen+1
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
    lda SCREEN_ANGLE
    sta angle
    lda SCREEN_ANGLE+1
    sta angle+1
    lda SCREEN_DIST
    sta dist
    lda SCREEN_DIST+1
    sta dist+1
    lda sin_offset_x
    clc
    adc #<SINTABLE
    sta sin_x
    lda #>SINTABLE
    adc #0
    sta sin_x+1
    lda sin_offset_y
    clc
    adc #<SINTABLE
    sta sin_y
    lda #>SINTABLE
    adc #0
    sta sin_y+1
    lda #0
    sta y
  b1:
    ldx #0
  b2:
    txa
    tay
    lda (dist),y
    sta $ff
    lda (angle),y
    tay
    lda (sin_x),y
    ldy $ff
    clc
    adc (sin_y),y
    stx $ff
    ldy $ff
    sta (screen),y
    inx
    cpx #$28
    bne b2
    lda #$28
    clc
    adc screen
    sta screen
    bcc !+
    inc screen+1
  !:
    lda #$28
    clc
    adc angle
    sta angle
    bcc !+
    inc angle+1
  !:
    lda #$28
    clc
    adc dist
    sta dist
    bcc !+
    inc dist+1
  !:
    inc y
    lda #$1a
    cmp y
    bne b1
    lax sin_offset_x
    axs #3
    stx sin_offset_x
    lax sin_offset_y
    axs #7
    stx sin_offset_y
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage(3) str, byte register(X) c)
memset: {
    .label end = $f
    .label dst = 3
    .label str = 3
    lda str
    clc
    adc #<$3e8
    sta end
    lda str+1
    adc #>$3e8
    sta end+1
  b2:
    lda dst+1
    cmp end+1
    bne b3
    lda dst
    cmp end
    bne b3
    rts
  b3:
    txa
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
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
    sta print_char_cursor
    lda #>print_line_cursor
    sta print_char_cursor+1
    lda #<0
    sta c
    sta c+1
  b2:
    lda c
    tay
    lda SINTABLE,y
    sta s
    lda #0
    sta i
  b4:
    ldy #0
    ldx #0
  b7:
    jsr sid_rnd
    and #$ff
    sta _7
    lda s
    cmp _7
    bcs b9
    tya
    ora bittab,x
    tay
  b9:
    inx
    cpx #8
    bcc b7
    lda c
    asl
    sta _10
    lda c+1
    rol
    sta _10+1
    asl _10
    rol _10+1
    asl _10
    rol _10+1
    lda i
    clc
    adc _11
    sta _11
    bcc !+
    inc _11+1
  !:
    clc
    lda _16
    adc #<CHARSET
    sta _16
    lda _16+1
    adc #>CHARSET
    sta _16+1
    tya
    ldy #0
    sta (_16),y
    inc i
    lda i
    cmp #8
    bcc b4
    lda c
    and #7
    cmp #0
    bne b12
    jsr print_char
  b12:
    inc c
    bne !+
    inc c+1
  !:
    lda c+1
    cmp #>$100
    bcc b2
    bne !+
    lda c
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
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
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
    sta memset.str
    lda #>print_line_cursor
    sta memset.str+1
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
    lda screen
    clc
    adc #<$28*$c
    sta screen_topline
    lda screen+1
    adc #>$28*$c
    sta screen_topline+1
    clc
    lda screen_bottomline
    adc #<$28*$c
    sta screen_bottomline
    lda screen_bottomline+1
    adc #>$28*$c
    sta screen_bottomline+1
    lda #0
    sta y
  b1:
    lda #$27
    sta xb
    lda #0
    sta x
  b3:
    lda x
    asl
    eor #$ff
    clc
    adc #$27+1
    ldy #0
    sta xw+1
    sty xw
    lda y
    asl
    sta yw+1
    sty yw
    jsr atan2_16
    lda #$80
    clc
    adc _11
    sta _11
    bcc !+
    inc _11+1
  !:
    lda _11+1
    sta ang_w
    ldy xb
    sta (screen_bottomline),y
    eor #$ff
    clc
    adc #1
    sta (screen_topline),y
    lda #$80
    clc
    adc ang_w
    ldy x
    sta (screen_topline),y
    lda #$80
    sec
    sbc ang_w
    sta (screen_bottomline),y
    inc x
    dec xb
    lda x
    cmp #$13+1
    bcc b3
    lda screen_topline
    sec
    sbc #<$28
    sta screen_topline
    lda screen_topline+1
    sbc #>$28
    sta screen_topline+1
    lda #$28
    clc
    adc screen_bottomline
    sta screen_bottomline
    bcc !+
    inc screen_bottomline+1
  !:
    inc y
    lda #$d
    cmp y
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
    lda y+1
    bmi !b1+
    jmp b1
  !b1:
    sec
    lda #0
    sbc y
    sta _2
    lda #0
    sbc y+1
    sta _2+1
  b3:
    lda x+1
    bmi !b4+
    jmp b4
  !b4:
    sec
    lda #0
    sbc x
    sta _7
    lda #0
    sbc x+1
    sta _7+1
  b6:
    lda #<0
    sta angle
    sta angle+1
    tax
  b10:
    lda yi+1
    bne b11
    lda yi
    bne b11
  b12:
    lsr angle+1
    ror angle
    lda x+1
    bpl b7
    sec
    lda #<$8000
    sbc angle
    sta angle
    lda #>$8000
    sbc angle+1
    sta angle+1
  b7:
    lda y+1
    bpl b8
    sec
    lda #0
    sbc angle
    sta angle
    lda #0
    sbc angle+1
    sta angle+1
  b8:
    rts
  b11:
    txa
    tay
    lda xi
    sta xd
    lda xi+1
    sta xd+1
    lda yi
    sta yd
    lda yi+1
    sta yd+1
  b13:
    cpy #2
    bcs b14
    cpy #0
    beq b17
    lda xd+1
    cmp #$80
    ror xd+1
    ror xd
    lda yd+1
    cmp #$80
    ror yd+1
    ror yd
  b17:
    lda yi+1
    bpl b18
    lda xi
    sec
    sbc yd
    sta xi
    lda xi+1
    sbc yd+1
    sta xi+1
    lda yi
    clc
    adc xd
    sta yi
    lda yi+1
    adc xd+1
    sta yi+1
    txa
    asl
    tay
    sec
    lda angle
    sbc CORDIC_ATAN2_ANGLES_16,y
    sta angle
    lda angle+1
    sbc CORDIC_ATAN2_ANGLES_16+1,y
    sta angle+1
  b19:
    inx
    cpx #CORDIC_ITERATIONS_16-1+1
    bne !b12+
    jmp b12
  !b12:
    jmp b10
  b18:
    lda xi
    clc
    adc yd
    sta xi
    lda xi+1
    adc yd+1
    sta xi+1
    lda yi
    sec
    sbc xd
    sta yi
    lda yi+1
    sbc xd+1
    sta yi+1
    txa
    asl
    tay
    clc
    lda angle
    adc CORDIC_ATAN2_ANGLES_16,y
    sta angle
    lda angle+1
    adc CORDIC_ATAN2_ANGLES_16+1,y
    sta angle+1
    jmp b19
  b14:
    lda xd+1
    cmp #$80
    ror xd+1
    ror xd
    lda xd+1
    cmp #$80
    ror xd+1
    ror xd
    lda yd+1
    cmp #$80
    ror yd+1
    ror yd
    lda yd+1
    cmp #$80
    ror yd+1
    ror yd
    dey
    dey
    jmp b13
  b4:
    lda x
    sta xi
    lda x+1
    sta xi+1
    jmp b6
  b1:
    lda y
    sta yi
    lda y+1
    sta yi+1
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
    lda screen
    clc
    adc #<$28*$18
    sta screen_bottomline
    lda screen+1
    adc #>$28*$18
    sta screen_bottomline+1
    lda #0
    sta y
  b1:
    lda y
    asl
    cmp #$18
    bcs b2
    eor #$ff
    clc
    adc #$18+1
  b4:
    jsr sqr
    lda sqr.return
    sta sqr.return_2
    lda sqr.return+1
    sta sqr.return_2+1
    lda #$27
    sta xb
    lda #0
    sta x
  b6:
    lda x
    asl
    cmp #$27
    bcs b8
    eor #$ff
    clc
    adc #$27+1
  b10:
    jsr sqr
    lda ds
    clc
    adc yds
    sta ds
    lda ds+1
    adc yds+1
    sta ds+1
    jsr sqrt
    ldy x
    sta (screen_topline),y
    sta (screen_bottomline),y
    ldy xb
    sta (screen_topline),y
    sta (screen_bottomline),y
    inc x
    dec xb
    lda x
    cmp #$13+1
    bcc b6
    lda #$28
    clc
    adc screen_topline
    sta screen_topline
    bcc !+
    inc screen_topline+1
  !:
    lda screen_bottomline
    sec
    sbc #<$28
    sta screen_bottomline
    lda screen_bottomline+1
    sbc #>$28
    sta screen_bottomline+1
    inc y
    lda #$d
    cmp y
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
    lda SQUARES
    sta bsearch16u.items_1
    lda SQUARES+1
    sta bsearch16u.items_1+1
    jsr bsearch16u
    lda _3
    sec
    sbc SQUARES
    sta _3
    lda _3+1
    sbc SQUARES+1
    sta _3+1
    lsr _1+1
    ror _1
    lda _1
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
    adc items_10
    sta pivot
    lda #0
    adc items_10+1
    sta pivot+1
    sec
    lda key
    ldy #0
    sbc (pivot),y
    sta result
    lda key+1
    iny
    sbc (pivot),y
    sta result+1
    bne b6
    lda result
    bne b6
  breturn:
    rts
  b6:
    lda result+1
    bmi b10
    bne !+
    lda result
    beq b10
  !:
    lda #1*SIZEOF_WORD
    clc
    adc items
    sta items
    bcc !+
    inc items+1
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
    cmp key+1
    bne !+
    dey
    lda (items),y
    cmp key
    beq breturn
  !:
    bcc breturn
    lda _2
    sec
    sbc #<1*SIZEOF_WORD
    sta _2
    lda _2+1
    sbc #>1*SIZEOF_WORD
    sta _2+1
    rts
  b9:
    lda items
    sta items_16
    lda items+1
    sta items_16+1
    jmp b4
  b10:
    lda items_10
    sta items
    lda items_10+1
    sta items+1
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
    sta return
    iny
    lda (SQUARES),y
    sta return+1
    rts
}
// Initialize squares table
// Uses iterative formula (x+1)^2 = x^2 + 2*x + 1
init_squares: {
    .label squares = $1a
    .label sqr = $18
    lda #<NUM_SQUARES*SIZEOF_WORD
    sta malloc.size
    lda #>NUM_SQUARES*SIZEOF_WORD
    sta malloc.size+1
    jsr malloc
    lda SQUARES
    sta squares
    lda SQUARES+1
    sta squares+1
    ldx #0
    txa
    sta sqr
    sta sqr+1
  b1:
    ldy #0
    lda sqr
    sta (squares),y
    iny
    lda sqr+1
    sta (squares),y
    lda #SIZEOF_WORD
    clc
    adc squares
    sta squares
    bcc !+
    inc squares+1
  !:
    txa
    asl
    clc
    adc #1
    clc
    adc sqr
    sta sqr
    bcc !+
    inc sqr+1
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
    lda heap_head
    sec
    sbc mem
    sta mem
    lda heap_head+1
    sbc mem+1
    sta mem+1
    lda mem
    sta heap_head
    lda mem+1
    sta heap_head+1
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

