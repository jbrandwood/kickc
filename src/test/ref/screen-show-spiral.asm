// Fill screen using a spiral based on distance-to-center / angle-to-center
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
  // Top of the heap used by malloc()
  .label HEAP_TOP = $a000
  // The number of iterations performed during 16-bit CORDIC atan2 calculation
  .const CORDIC_ITERATIONS_16 = $f
  // Screen containing angle to center
  .label SCREEN_FILL = $400
  // Char to fill with
  .const FILL_CHAR = '@'
  .const NUM_SQUARES = $30
  .label heap_head = $d
  .label SQUARES = $13
  // Screen containing distance to center
  .label SCREEN_DIST = $f
  // Screen containing angle to center
  .label SCREEN_ANGLE = $11
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
    .label dist = $b
    .label angle = $d
    .label fill = 9
    .label dist_angle = 2
    .label min_dist_angle = $18
    .label min_dist_angle_3 = 2
    .label min_fill = $1a
    .label min_dist_angle_7 = 2
    .label min_dist_angle_8 = 2
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
  b1:
    // Find the minimum dist/angle that is not already filled
    lda SCREEN_DIST
    sta dist
    lda SCREEN_DIST+1
    sta dist+1
    lda SCREEN_ANGLE
    sta angle
    lda SCREEN_ANGLE+1
    sta angle+1
    lda #<SCREEN_FILL
    sta min_fill
    lda #>SCREEN_FILL
    sta min_fill+1
    lda #<$ffff
    sta min_dist_angle
    lda #>$ffff
    sta min_dist_angle+1
    lda #<SCREEN_FILL
    sta fill
    lda #>SCREEN_FILL
    sta fill+1
  b2:
    lda #FILL_CHAR
    ldy #0
    cmp (fill),y
    beq b10
    lda (angle),y
    sta dist_angle
    lda (dist),y
    sta dist_angle+1
    lda min_dist_angle+1
    cmp dist_angle+1
    bne !+
    lda min_dist_angle
    cmp dist_angle
    beq b11
  !:
    bcc b11
    lda fill
    sta min_fill
    lda fill+1
    sta min_fill+1
  b3:
    inc dist
    bne !+
    inc dist+1
  !:
    inc angle
    bne !+
    inc angle+1
  !:
    inc fill
    bne !+
    inc fill+1
  !:
    lda fill+1
    cmp #>SCREEN_FILL+$3e8
    bcc b9
    bne !+
    lda fill
    cmp #<SCREEN_FILL+$3e8
    bcc b9
  !:
    lda min_dist_angle_3+1
    cmp #>$ffff
    bne b7
    lda min_dist_angle_3
    cmp #<$ffff
    bne b7
    rts
  b7:
    // Fill the found location
    lda #FILL_CHAR
    ldy #0
    sta (min_fill),y
    jmp b1
  b9:
    lda min_dist_angle_3
    sta min_dist_angle
    lda min_dist_angle_3+1
    sta min_dist_angle+1
    jmp b2
  b11:
    lda min_dist_angle
    sta min_dist_angle_8
    lda min_dist_angle+1
    sta min_dist_angle_8+1
    jmp b3
  b10:
    lda min_dist_angle
    sta min_dist_angle_7
    lda min_dist_angle+1
    sta min_dist_angle_7+1
    jmp b3
}
// Populates 1000 bytes (a screen) with values representing the angle to the center.
// Utilizes symmetry around the  center
// init_angle_screen(byte* zeropage(9) screen)
init_angle_screen: {
    .label _10 = $1a
    .label screen = 9
    .label screen_topline = $b
    .label screen_bottomline = 9
    .label xw = $13
    .label yw = $16
    .label angle_w = $1a
    .label ang_w = $15
    .label x = 7
    .label xb = 8
    .label y = 4
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
  b2:
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
    adc _10
    sta _10
    bcc !+
    inc _10+1
  !:
    lda _10+1
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
    bcc b2
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
    .label _2 = $d
    .label _7 = $18
    .label yi = $d
    .label xi = $18
    .label angle = $1a
    .label xd = 5
    .label yd = 2
    .label return = $1a
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
// init_dist_screen(byte* zeropage(5) screen)
init_dist_screen: {
    .label screen = 5
    .label screen_bottomline = 9
    .label yds = $16
    .label xds = $18
    .label ds = $18
    .label x = 7
    .label xb = 8
    .label screen_topline = 5
    .label y = 4
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
  b5:
    lda x
    asl
    cmp #$27
    bcs b6
    eor #$ff
    clc
    adc #$27+1
  b8:
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
    bcc b5
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
  b6:
    sec
    sbc #$27
    jmp b8
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
    .label _1 = $d
    .label _3 = $d
    .label found = $d
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
// bsearch16u(word zeropage($18) key, word* zeropage($d) items, byte register(X) num)
bsearch16u: {
    .label _2 = $d
    .label pivot = $d
    .label result = $1a
    .label return = $d
    .label items = $d
    .label key = $18
    .label items_1 = $b
    .label items_10 = $b
    .label items_16 = $b
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
    .label squares = $b
    .label sqr = 9
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

