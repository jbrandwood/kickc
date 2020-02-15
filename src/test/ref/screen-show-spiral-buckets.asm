// Fill screen using a spiral based on distance-to-center / angle-to-center
// Utilizes a bucket sort for identifying the minimum angle/distance
.pc = $801 "Basic"
:BasicUpstart(__b1)
.pc = $80d "Program"
  .label RASTER = $d012
  .label BORDERCOL = $d020
  // Color Ram
  .label COLS = $d800
  .const SIZEOF_WORD = 2
  // The number of iterations performed during 16-bit CORDIC atan2 calculation
  .const CORDIC_ITERATIONS_16 = $f
  // Screen containing angle to center
  .label SCREEN_FILL = $400
  // Char to fill with
  .const FILL_CHAR = '*'
  // The number of buckets in our bucket sort
  .const NUM_BUCKETS = $30
  .const SIZEOF_BYTE = 1
  .const SIZEOF_POINTER = 2
  // Top of the heap used by malloc()
  .label HEAP_TOP = $a000
  // The number of squares to pre-calculate. Limits what values sqr() can calculate and the result of sqrt()
  .const NUM_SQUARES = $30
  // Head of the heap. Moved backward each malloc()
  .label heap_head = 2
  // Squares for each byte value SQUARES[i] = i*i
  // Initialized by init_squares()
  .label SQUARES = 5
  .label SCREEN_DIST = $16
  .label SCREEN_ANGLE = $e
  .label BUCKET_SIZES = $10
  .label BUCKETS = $12
  .label BUCKET_IDX = $18
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
  lda #<NUM_BUCKETS*SIZEOF_BYTE
  sta.z malloc.size
  lda #>NUM_BUCKETS*SIZEOF_BYTE
  sta.z malloc.size+1
  jsr malloc
  lda.z malloc.mem
  sta.z BUCKET_SIZES
  lda.z malloc.mem+1
  sta.z BUCKET_SIZES+1
  lda #<NUM_BUCKETS*SIZEOF_POINTER
  sta.z malloc.size
  lda #>NUM_BUCKETS*SIZEOF_POINTER
  sta.z malloc.size+1
  jsr malloc
  lda.z malloc.mem
  sta.z BUCKETS
  lda.z malloc.mem+1
  sta.z BUCKETS+1
  lda #<NUM_BUCKETS*SIZEOF_BYTE
  sta.z malloc.size
  lda #>NUM_BUCKETS*SIZEOF_BYTE
  sta.z malloc.size+1
  jsr malloc
  lda.z malloc.mem
  sta.z BUCKET_IDX
  lda.z malloc.mem+1
  sta.z BUCKET_IDX+1
  jsr main
  rts
main: {
    .label bucket = $14
    .label bucket_size = $1b
    // Animate a spiral walking through the buckets one at a time
    .label bucket_idx = $1a
    .label offset = $a
    .label fill = $16
    .label angle = $18
    // Find the minimum unfilled angle in the current bucket
    .label min_angle = 4
    .label fill1 = 8
    .label min_offset = 8
    .label min_offset_1 = $a
    sei
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
    jsr init_buckets
    lda #0
    sta.z bucket_idx
  __b2:
    lda #$ff
    cmp RASTER
    bne __b2
    inc BORDERCOL
    lda.z bucket_idx
    asl
    tay
    lda (BUCKETS),y
    sta.z bucket
    iny
    lda (BUCKETS),y
    sta.z bucket+1
    ldy.z bucket_idx
    lda (BUCKET_SIZES),y
    sta.z bucket_size
    cmp #0
    beq __b4
    lda #$ff
    sta.z min_angle
    lda #<$ffff
    sta.z min_offset
    lda #>$ffff
    sta.z min_offset+1
    ldx #0
  __b5:
    cpx.z bucket_size
    bcc __b6
    lda.z min_offset
    cmp #<$ffff
    bne !+
    lda.z min_offset+1
    cmp #>$ffff
    beq __b4
  !:
    clc
    lda.z fill1
    adc #<SCREEN_FILL
    sta.z fill1
    lda.z fill1+1
    adc #>SCREEN_FILL
    sta.z fill1+1
    lda #FILL_CHAR
    ldy #0
    sta (fill1),y
    dec BORDERCOL
    jmp __b2
  __b4:
    inc.z bucket_idx
    lda #NUM_BUCKETS
    cmp.z bucket_idx
    bne __b12
    dec BORDERCOL
  __b14:
    inc COLS+$3e7
    jmp __b14
  __b12:
    dec BORDERCOL
    jmp __b2
  __b6:
    txa
    asl
    tay
    lda (bucket),y
    sta.z offset
    iny
    lda (bucket),y
    sta.z offset+1
    lda.z offset
    clc
    adc #<SCREEN_FILL
    sta.z fill
    lda.z offset+1
    adc #>SCREEN_FILL
    sta.z fill+1
    lda #FILL_CHAR
    ldy #0
    cmp (fill),y
    beq __b18
    lda.z SCREEN_ANGLE
    clc
    adc.z offset
    sta.z angle
    lda.z SCREEN_ANGLE+1
    adc.z offset+1
    sta.z angle+1
    lda (angle),y
    cmp.z min_angle
    beq !+
    bcs __b17
  !:
    ldy #0
    lda (angle),y
    sta.z min_angle
  __b8:
    inx
    lda.z min_offset_1
    sta.z min_offset
    lda.z min_offset_1+1
    sta.z min_offset+1
    jmp __b5
  __b17:
    lda.z min_offset
    sta.z min_offset_1
    lda.z min_offset+1
    sta.z min_offset_1+1
    jmp __b8
  __b18:
    lda.z min_offset
    sta.z min_offset_1
    lda.z min_offset+1
    sta.z min_offset_1+1
    jmp __b8
}
// Initialize buckets containing indices of chars on the screen with specific distances to the center.
// init_buckets(byte* zp($16) screen)
init_buckets: {
    .label __4 = 5
    .label __7 = $22
    .label __8 = $1c
    .label __12 = $20
    .label __13 = $22
    .label screen = $16
    .label dist = 8
    .label i1 = $a
    .label i2 = $14
    .label distance = $1a
    .label bucket = $22
    .label dist_1 = 2
    .label i4 = $1e
    .label __15 = 5
    .label __16 = $20
    .label __17 = $22
    ldy #0
  // Init bucket sizes to 0
  __b1:
    lda #0
    sta (BUCKET_SIZES),y
    iny
    cpy #NUM_BUCKETS-1+1
    bne __b1
    lda.z screen
    sta.z dist
    lda.z screen+1
    sta.z dist+1
    lda #<0
    sta.z i1
    sta.z i1+1
  __b3:
    ldy #0
    lda (dist),y
    tay
    lda (BUCKET_SIZES),y
    clc
    adc #1
    sta (BUCKET_SIZES),y
    inc.z dist
    bne !+
    inc.z dist+1
  !:
    inc.z i1
    bne !+
    inc.z i1+1
  !:
    lda.z i1+1
    cmp #>$3e8
    bne __b3
    lda.z i1
    cmp #<$3e8
    bne __b3
    lda #<0
    sta.z i2
    sta.z i2+1
  // Allocate the buckets
  __b4:
    lda.z BUCKET_SIZES
    clc
    adc.z i2
    sta.z __15
    lda.z BUCKET_SIZES+1
    adc.z i2+1
    sta.z __15+1
    ldy #0
    lda (malloc.size),y
    asl
    sta.z malloc.size
    tya
    rol
    sta.z malloc.size+1
    jsr malloc
    lda.z i2
    asl
    sta.z __12
    lda.z i2+1
    rol
    sta.z __12+1
    lda.z __16
    clc
    adc.z BUCKETS
    sta.z __16
    lda.z __16+1
    adc.z BUCKETS+1
    sta.z __16+1
    ldy #0
    lda.z __4
    sta (__16),y
    iny
    lda.z __4+1
    sta (__16),y
    inc.z i2
    bne !+
    inc.z i2+1
  !:
    lda.z i2+1
    cmp #>NUM_BUCKETS-1+1
    bne __b4
    lda.z i2
    cmp #<NUM_BUCKETS-1+1
    bne __b4
    ldy #0
  // Iterate all distances and fill the buckets with indices into the screens
  __b5:
    lda #0
    sta (BUCKET_IDX),y
    iny
    cpy #NUM_BUCKETS-1+1
    bne __b5
    lda.z screen
    sta.z dist_1
    lda.z screen+1
    sta.z dist_1+1
    lda #<0
    sta.z i4
    sta.z i4+1
  __b7:
    ldy #0
    lda (dist_1),y
    sta.z distance
    sta.z __7
    tya
    sta.z __7+1
    asl.z __13
    rol.z __13+1
    lda.z __17
    clc
    adc.z BUCKETS
    sta.z __17
    lda.z __17+1
    adc.z BUCKETS+1
    sta.z __17+1
    lda (bucket),y
    pha
    iny
    lda (bucket),y
    sta.z bucket+1
    pla
    sta.z bucket
    lda.z dist_1
    sec
    sbc.z screen
    sta.z __8
    lda.z dist_1+1
    sbc.z screen+1
    sta.z __8+1
    ldy.z distance
    lda (BUCKET_IDX),y
    asl
    tay
    lda.z __8
    sta (bucket),y
    iny
    lda.z __8+1
    sta (bucket),y
    ldy.z distance
    lda (BUCKET_IDX),y
    clc
    adc #1
    sta (BUCKET_IDX),y
    inc.z dist_1
    bne !+
    inc.z dist_1+1
  !:
    inc.z i4
    bne !+
    inc.z i4+1
  !:
    lda.z i4+1
    cmp #>$3e8
    bne __b7
    lda.z i4
    cmp #<$3e8
    bne __b7
    rts
}
// Allocates a block of size bytes of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
// malloc(word zp(5) size)
malloc: {
    .label mem = 5
    .label size = 5
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
// Populates 1000 bytes (a screen) with values representing the angle to the center.
// Utilizes symmetry around the center
// init_angle_screen(byte* zp($1e) screen)
init_angle_screen: {
    .label __11 = $a
    .label screen = $1e
    .label screen_topline = $14
    .label screen_bottomline = $1e
    .label xw = $20
    .label yw = $22
    .label angle_w = $a
    .label ang_w = $1b
    .label x = 4
    .label xb = 7
    .label y = $1a
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
// atan2_16(signed word zp($20) x, signed word zp($22) y)
atan2_16: {
    .label __2 = 5
    .label __7 = 8
    .label yi = 5
    .label xi = 8
    .label angle = $a
    .label xd = $1c
    .label yd = $c
    .label return = $a
    .label x = $20
    .label y = $22
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
// Utilizes symmetry around the center
// init_dist_screen(byte* zp(8) screen)
init_dist_screen: {
    .label screen = 8
    .label screen_bottomline = $a
    .label yds = $1c
    .label screen_topline = 8
    .label y = 7
    .label xds = $1e
    .label ds = $1e
    .label x = $1b
    .label xb = $1a
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
// sqrt(word zp($1e) val)
sqrt: {
    .label __1 = $c
    .label __3 = $c
    .label found = $c
    .label val = $1e
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
// bsearch16u(word zp($1e) key, word* zp($c) items, byte register(X) num)
bsearch16u: {
    .label __2 = $c
    .label pivot = $20
    .label result = $22
    .label return = $c
    .label items = $c
    .label key = $1e
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
    .label return = $1e
    .label return_1 = $1c
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
    .label squares = $14
    .label sqr = $1c
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
// Angles representing ATAN(0.5), ATAN(0.25), ATAN(0.125), ...
CORDIC_ATAN2_ANGLES_16:
.for (var i=0; i<CORDIC_ITERATIONS_16; i++)
        .word 256*2*256*atan(1/pow(2,i))/PI/2

