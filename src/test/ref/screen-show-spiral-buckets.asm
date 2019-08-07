// Fill screen using a spiral based on distance-to-center / angle-to-center
// Utilizes a bucket sort for identifying the minimum angle/distance
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
  .const SIZEOF_BYTE = 1
  .const SIZEOF_POINTER = 2
  .label RASTER = $d012
  .label BORDERCOL = $d020
  // Color Ram
  .label COLS = $d800
  // Top of the heap used by malloc()
  .label HEAP_TOP = $a000
  // The number of iterations performed during 16-bit CORDIC atan2 calculation
  .const CORDIC_ITERATIONS_16 = $f
  // Screen containing angle to center
  .label SCREEN_FILL = $400
  // Char to fill with
  .const FILL_CHAR = '*'
  // The number of buckets in our bucket sort
  .const NUM_BUCKETS = $30
  .const NUM_SQUARES = $30
  .label heap_head = 2
  .label SQUARES = 5
  // Screen containing distance to center
  .label SCREEN_DIST = $1c
  // Screen containing angle to center
  .label SCREEN_ANGLE = $10
  // Array containing the bucket size for each of the distance buckets
  .label BUCKET_SIZES = $12
  // Buckets containing screen indices for each distance from the center.
  // BUCKETS[dist] is an array of words containing screen indices.
  // The size of the array BUCKETS[dist] is BUCKET_SIZES[dist]
  .label BUCKETS = $14
  // Current index into each bucket. Used while populating the buckets. (After population the end the values will be equal to the bucket sizes)
  .label BUCKET_IDX = $16
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
    .label bucket = $18
    .label bucket_size = $1f
    .label bucket_idx = $1e
    .label offset = $a
    .label fill = $1a
    .label angle = $1c
    .label min_angle = 4
    .label fill1 = 8
    .label min_offset = 8
    .label min_offset_5 = $a
    .label min_offset_9 = $a
    .label min_offset_11 = $a
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
  b2:
    lda #$ff
    cmp RASTER
    bne b2
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
    beq b4
    lda #$ff
    sta.z min_angle
    lda #<$ffff
    sta.z min_offset
    lda #>$ffff
    sta.z min_offset+1
    ldx #0
  b5:
    cpx.z bucket_size
    bcc b6
    lda.z min_offset
    cmp #<$ffff
    bne !+
    lda.z min_offset+1
    cmp #>$ffff
    beq b4
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
    jmp b2
  b4:
    inc.z bucket_idx
    lda #NUM_BUCKETS
    cmp.z bucket_idx
    bne b12
    dec BORDERCOL
  b14:
    inc COLS+$3e7
    jmp b14
  b12:
    dec BORDERCOL
    jmp b2
  b6:
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
    beq b18
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
    bcs b17
  !:
    ldy #0
    lda (angle),y
    sta.z min_angle
  b8:
    inx
    lda.z min_offset_5
    sta.z min_offset
    lda.z min_offset_5+1
    sta.z min_offset+1
    jmp b5
  b17:
    lda.z min_offset
    sta.z min_offset_9
    lda.z min_offset+1
    sta.z min_offset_9+1
    jmp b8
  b18:
    lda.z min_offset
    sta.z min_offset_11
    lda.z min_offset+1
    sta.z min_offset_11+1
    jmp b8
}
// Initialize buckets containing indices of chars on the screen with specific distances to the center.
// init_buckets(byte* zeropage($1c) screen)
init_buckets: {
    .label _5 = 5
    .label _9 = $24
    .label _10 = $20
    .label _12 = $22
    .label _13 = $24
    .label screen = $1c
    .label dist = 8
    .label i1 = $a
    .label i2 = $18
    .label distance = $1e
    .label bucket = $24
    .label dist_3 = 2
    .label i4 = $1a
    .label dist_5 = 2
    .label _15 = 5
    .label _16 = $22
    .label _17 = $24
    .label dist_8 = 2
    ldy #0
  // Init bucket sizes to 0
  b1:
    lda #0
    sta (BUCKET_SIZES),y
    iny
    cpy #NUM_BUCKETS-1+1
    bne b1
    lda.z screen
    sta.z dist
    lda.z screen+1
    sta.z dist+1
    lda #<0
    sta.z i1
    sta.z i1+1
  b3:
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
    bne b3
    lda.z i1
    cmp #<$3e8
    bne b3
    lda #<0
    sta.z i2
    sta.z i2+1
  // Allocate the buckets
  b4:
    lda.z BUCKET_SIZES
    clc
    adc.z i2
    sta.z _15
    lda.z BUCKET_SIZES+1
    adc.z i2+1
    sta.z _15+1
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
    sta.z _12
    lda.z i2+1
    rol
    sta.z _12+1
    lda.z _16
    clc
    adc.z BUCKETS
    sta.z _16
    lda.z _16+1
    adc.z BUCKETS+1
    sta.z _16+1
    ldy #0
    lda.z _5
    sta (_16),y
    iny
    lda.z _5+1
    sta (_16),y
    inc.z i2
    bne !+
    inc.z i2+1
  !:
    lda.z i2+1
    cmp #>NUM_BUCKETS-1+1
    bne b4
    lda.z i2
    cmp #<NUM_BUCKETS-1+1
    bne b4
    ldy #0
  // Iterate all distances and fill the buckets with indices into the screens
  b5:
    lda #0
    sta (BUCKET_IDX),y
    iny
    cpy #NUM_BUCKETS-1+1
    bne b5
    lda.z screen
    sta.z dist_8
    lda.z screen+1
    sta.z dist_8+1
    lda #<0
    sta.z i4
    sta.z i4+1
  b7:
    ldy #0
    lda (dist_5),y
    sta.z distance
    sta.z _9
    tya
    sta.z _9+1
    asl.z _13
    rol.z _13+1
    lda.z _17
    clc
    adc.z BUCKETS
    sta.z _17
    lda.z _17+1
    adc.z BUCKETS+1
    sta.z _17+1
    lda (bucket),y
    pha
    iny
    lda (bucket),y
    sta.z bucket+1
    pla
    sta.z bucket
    lda.z dist_5
    sec
    sbc.z screen
    sta.z _10
    lda.z dist_5+1
    sbc.z screen+1
    sta.z _10+1
    ldy.z distance
    lda (BUCKET_IDX),y
    asl
    tay
    lda.z _10
    sta (bucket),y
    iny
    lda.z _10+1
    sta (bucket),y
    ldy.z distance
    lda (BUCKET_IDX),y
    clc
    adc #1
    sta (BUCKET_IDX),y
    inc.z dist_3
    bne !+
    inc.z dist_3+1
  !:
    inc.z i4
    bne !+
    inc.z i4+1
  !:
    lda.z i4+1
    cmp #>$3e8
    bne b7
    lda.z i4
    cmp #<$3e8
    bne b7
    rts
}
// Allocates a block of size bytes of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
// malloc(word zeropage(5) size)
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
// init_angle_screen(byte* zeropage($1a) screen)
init_angle_screen: {
    .label _11 = $a
    .label screen = $1a
    .label screen_topline = $18
    .label screen_bottomline = $1a
    .label xw = $22
    .label yw = $24
    .label angle_w = $a
    .label ang_w = $1f
    .label x = 4
    .label xb = 7
    .label y = $1e
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
// atan2_16(signed word zeropage($22) x, signed word zeropage($24) y)
atan2_16: {
    .label _2 = 5
    .label _7 = 8
    .label yi = 5
    .label xi = 8
    .label angle = $a
    .label xd = $e
    .label yd = $c
    .label return = $a
    .label x = $22
    .label y = $24
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
// Utilizes symmetry around the center
// init_dist_screen(byte* zeropage(8) screen)
init_dist_screen: {
    .label screen = 8
    .label screen_bottomline = $a
    .label yds = $20
    .label screen_topline = 8
    .label y = 7
    .label xds = $22
    .label ds = $22
    .label x = $1f
    .label xb = $1e
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
// sqrt(word zeropage($22) val)
sqrt: {
    .label _1 = $e
    .label _3 = $e
    .label found = $e
    .label val = $22
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
// bsearch16u(word zeropage($22) key, word* zeropage($e) items, byte register(X) num)
bsearch16u: {
    .label _2 = $e
    .label pivot = $e
    .label result = $24
    .label return = $e
    .label items = $e
    .label key = $22
    .label items_1 = $c
    .label items_10 = $c
    .label items_16 = $c
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
    .label return = $22
    .label return_2 = $20
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
// Angles representing ATAN(0.5), ATAN(0.25), ATAN(0.125), ...
CORDIC_ATAN2_ANGLES_16:
.for (var i=0; i<CORDIC_ITERATIONS_16; i++)
        .word 256*2*256*atan(1/pow(2,i))/PI/2

