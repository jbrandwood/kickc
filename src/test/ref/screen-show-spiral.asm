// Fill screen using a spiral based on distance-to-center / angle-to-center
.pc = $801 "Basic"
:BasicUpstart(__b1)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
  // The number of iterations performed during 16-bit CORDIC atan2 calculation
  .const CORDIC_ITERATIONS_16 = $f
  // Screen containing angle to center
  .label SCREEN_FILL = $400
  // Char to fill with
  .const FILL_CHAR = '@'
  // Top of the heap used by malloc()
  .label HEAP_TOP = $a000
  // The number of squares to pre-calculate. Limits what values sqr() can calculate and the result of sqrt()
  .const NUM_SQUARES = $30
  // Head of the heap. Moved backward each malloc()
  .label heap_head = $f
  // Squares for each byte value SQUARES[i] = i*i
  // Initialized by init_squares()
  .label SQUARES = $11
  .label SCREEN_DIST = $b
  .label SCREEN_ANGLE = $d
__b1:
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
    .label dist = 9
    .label angle = $14
    .label fill = 7
    .label dist_angle = $1a
    .label min_dist_angle = $16
    .label min_dist_angle_1 = $1a
    .label min_fill = $18
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
  __b1:
    // Find the minimum dist/angle that is not already filled
    lda.z SCREEN_DIST
    sta.z dist
    lda.z SCREEN_DIST+1
    sta.z dist+1
    lda.z SCREEN_ANGLE
    sta.z angle
    lda.z SCREEN_ANGLE+1
    sta.z angle+1
    lda #<SCREEN_FILL
    sta.z min_fill
    lda #>SCREEN_FILL
    sta.z min_fill+1
    lda #<$ffff
    sta.z min_dist_angle
    lda #>$ffff
    sta.z min_dist_angle+1
    lda #<SCREEN_FILL
    sta.z fill
    lda #>SCREEN_FILL
    sta.z fill+1
  __b2:
    lda #FILL_CHAR
    ldy #0
    cmp (fill),y
    beq __b10
    lda (angle),y
    sta.z dist_angle
    lda (dist),y
    sta.z dist_angle+1
    lda.z min_dist_angle+1
    cmp.z dist_angle+1
    bne !+
    lda.z min_dist_angle
    cmp.z dist_angle
    beq __b11
  !:
    bcc __b11
    lda.z fill
    sta.z min_fill
    lda.z fill+1
    sta.z min_fill+1
  __b3:
    inc.z dist
    bne !+
    inc.z dist+1
  !:
    inc.z angle
    bne !+
    inc.z angle+1
  !:
    inc.z fill
    bne !+
    inc.z fill+1
  !:
    lda.z fill+1
    cmp #>SCREEN_FILL+$3e8
    bcc __b9
    bne !+
    lda.z fill
    cmp #<SCREEN_FILL+$3e8
    bcc __b9
  !:
    lda.z min_dist_angle_1+1
    cmp #>$ffff
    bne __b7
    lda.z min_dist_angle_1
    cmp #<$ffff
    bne __b7
    rts
  __b7:
    // Fill the found location
    lda #FILL_CHAR
    ldy #0
    sta (min_fill),y
    jmp __b1
  __b9:
    lda.z min_dist_angle_1
    sta.z min_dist_angle
    lda.z min_dist_angle_1+1
    sta.z min_dist_angle+1
    jmp __b2
  __b11:
    lda.z min_dist_angle
    sta.z min_dist_angle_1
    lda.z min_dist_angle+1
    sta.z min_dist_angle_1+1
    jmp __b3
  __b10:
    lda.z min_dist_angle
    sta.z min_dist_angle_1
    lda.z min_dist_angle+1
    sta.z min_dist_angle_1+1
    jmp __b3
}
// Populates 1000 bytes (a screen) with values representing the angle to the center.
// Utilizes symmetry around the  center
// init_angle_screen(byte* zp(9) screen)
init_angle_screen: {
    .label __11 = $18
    .label screen = 9
    .label screen_topline = 7
    .label screen_bottomline = 9
    .label xw = $f
    .label yw = $11
    .label angle_w = $18
    .label ang_w = $13
    .label x = 5
    .label xb = 6
    .label y = 2
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
  __b1:
    lda #$27
    sta.z xb
    lda #0
    sta.z x
  __b2:
    lda.z x
    cmp #$13+1
    bcc __b3
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
    bne __b1
    rts
  __b3:
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
    adc.z __11
    sta.z __11
    bcc !+
    inc.z __11+1
  !:
    lda.z __11+1
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
    jmp __b2
}
// Find the atan2(x, y) - which is the angle of the line from (0,0) to (x,y)
// Finding the angle requires a binary search using CORDIC_ITERATIONS_16
// Returns the angle in hex-degrees (0=0, 0x8000=PI, 0x10000=2*PI)
// atan2_16(signed word zp($f) x, signed word zp($11) y)
atan2_16: {
    .label __2 = $14
    .label __7 = $16
    .label yi = $14
    .label xi = $16
    .label angle = $18
    .label xd = 3
    .label yd = $1a
    .label return = $18
    .label x = $f
    .label y = $11
    lda.z y+1
    bmi !__b1+
    jmp __b1
  !__b1:
    sec
    lda #0
    sbc.z y
    sta.z __2
    lda #0
    sbc.z y+1
    sta.z __2+1
  __b3:
    lda.z x+1
    bmi !__b4+
    jmp __b4
  !__b4:
    sec
    lda #0
    sbc.z x
    sta.z __7
    lda #0
    sbc.z x+1
    sta.z __7+1
  __b6:
    lda #<0
    sta.z angle
    sta.z angle+1
    tax
  __b10:
    lda.z yi+1
    bne __b11
    lda.z yi
    bne __b11
  __b12:
    lsr.z angle+1
    ror.z angle
    lda.z x+1
    bpl __b7
    sec
    lda #<$8000
    sbc.z angle
    sta.z angle
    lda #>$8000
    sbc.z angle+1
    sta.z angle+1
  __b7:
    lda.z y+1
    bpl __b8
    sec
    lda #0
    sbc.z angle
    sta.z angle
    lda #0
    sbc.z angle+1
    sta.z angle+1
  __b8:
    rts
  __b11:
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
  __b13:
    cpy #2
    bcs __b14
    cpy #0
    beq __b17
    lda.z xd+1
    cmp #$80
    ror.z xd+1
    ror.z xd
    lda.z yd+1
    cmp #$80
    ror.z yd+1
    ror.z yd
  __b17:
    lda.z yi+1
    bpl __b18
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
  __b19:
    inx
    cpx #CORDIC_ITERATIONS_16-1+1
    bne !__b12+
    jmp __b12
  !__b12:
    jmp __b10
  __b18:
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
    jmp __b19
  __b14:
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
    jmp __b13
  __b4:
    lda.z x
    sta.z xi
    lda.z x+1
    sta.z xi+1
    jmp __b6
  __b1:
    lda.z y
    sta.z yi
    lda.z y+1
    sta.z yi+1
    jmp __b3
}
// Populates 1000 bytes (a screen) with values representing the distance to the center.
// The actual value stored is distance*2 to increase precision
// init_dist_screen(byte* zp(3) screen)
init_dist_screen: {
    .label screen = 3
    .label screen_bottomline = 7
    .label yds = $14
    .label screen_topline = 3
    .label y = 2
    .label xds = $16
    .label ds = $16
    .label x = 5
    .label xb = 6
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
  __b1:
    lda.z y
    asl
    cmp #$18
    bcs __b2
    eor #$ff
    clc
    adc #$18+1
  __b4:
    jsr sqr
    lda.z sqr.return
    sta.z sqr.return_1
    lda.z sqr.return+1
    sta.z sqr.return_1+1
    lda #$27
    sta.z xb
    lda #0
    sta.z x
  __b5:
    lda.z x
    cmp #$13+1
    bcc __b6
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
    bne __b1
    rts
  __b6:
    lda.z x
    asl
    cmp #$27
    bcs __b8
    eor #$ff
    clc
    adc #$27+1
  __b10:
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
    jmp __b5
  __b8:
    sec
    sbc #$27
    jmp __b10
  __b2:
    sec
    sbc #$18
    jmp __b4
}
// Find the (integer) square root of a word value
// If the square is not an integer then it returns the largest integer N where N*N <= val
// Uses a table of squares that must be initialized by calling init_squares()
// sqrt(word zp($16) val)
sqrt: {
    .label __1 = 9
    .label __3 = 9
    .label found = 9
    .label val = $16
    lda.z SQUARES
    sta.z bsearch16u.items
    lda.z SQUARES+1
    sta.z bsearch16u.items+1
    jsr bsearch16u
    lda.z __3
    sec
    sbc.z SQUARES
    sta.z __3
    lda.z __3+1
    sbc.z SQUARES+1
    sta.z __3+1
    lsr.z __1+1
    ror.z __1
    lda.z __1
    rts
}
// Searches an array of nitems unsigned words, the initial member of which is pointed to by base, for a member that matches the value key.
// - key - The value to look for
// - items - Pointer to the start of the array to search in
// - num - The number of items in the array
// Returns pointer to an entry in the array that matches the search key
// bsearch16u(word zp($16) key, word* zp(9) items, byte register(X) num)
bsearch16u: {
    .label __2 = 9
    .label pivot = $18
    .label result = $1a
    .label return = 9
    .label items = 9
    .label key = $16
    ldx #NUM_SQUARES
  __b3:
    cpx #0
    bne __b4
    ldy #1
    lda (items),y
    cmp.z key+1
    bne !+
    dey
    lda (items),y
    cmp.z key
    beq __b2
  !:
    bcc __b2
    lda.z __2
    sec
    sbc #<1*SIZEOF_WORD
    sta.z __2
    lda.z __2+1
    sbc #>1*SIZEOF_WORD
    sta.z __2+1
  __b2:
    rts
  __b4:
    txa
    lsr
    asl
    clc
    adc.z items
    sta.z pivot
    lda #0
    adc.z items+1
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
    bne __b6
    lda.z result
    bne __b6
    lda.z pivot
    sta.z return
    lda.z pivot+1
    sta.z return+1
    rts
  __b6:
    lda.z result+1
    bmi __b7
    bne !+
    lda.z result
    beq __b7
  !:
    lda #1*SIZEOF_WORD
    clc
    adc.z pivot
    sta.z items
    lda #0
    adc.z pivot+1
    sta.z items+1
    dex
  __b7:
    txa
    lsr
    tax
    jmp __b3
}
// Find the square of a byte value
// Uses a table of squares that must be initialized by calling init_squares()
// sqr(byte register(A) val)
sqr: {
    .label return = $16
    .label return_1 = $14
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
    .label squares = 9
    .label sqr = 7
    lda #<NUM_SQUARES*SIZEOF_WORD
    sta.z malloc.size
    lda #>NUM_SQUARES*SIZEOF_WORD
    sta.z malloc.size+1
    jsr malloc
    lda.z SQUARES
    sta.z squares
    lda.z SQUARES+1
    sta.z squares+1
    lda #<0
    sta.z sqr
    sta.z sqr+1
    tax
  __b1:
    cpx #NUM_SQUARES
    bcc __b2
    rts
  __b2:
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
    jmp __b1
}
// Allocates a block of size bytes of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
// malloc(word zp($11) size)
malloc: {
    .label mem = $11
    .label size = $11
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

