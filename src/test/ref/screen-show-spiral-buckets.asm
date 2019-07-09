// Fill screen using a spiral based on distance-to-center / angle-to-center
// Utilizes a bucket sort for identifying the minimum angle/distance
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
  .label RASTER = $d012
  .label BORDERCOL = $d020
  // Top of the heap used by malloc()
  .label HEAP_TOP = $a000
  // The number of iterations performed during 16-bit CORDIC atan2 calculation
  .const CORDIC_ITERATIONS_16 = $f
  // = malloc(1000);
  // Screen containing angle to center
  .label SCREEN_FILL = $400
  // The number of buckets in our bucket sort
µ  .const NUM_BUCKETS = $100
  .const NUM_SQUARES = $30
  .label heap_head = $15
  .label SQUARES = $17
main: {
    .label _3 = $37
    .label _11 = $39
    .label _16 = $3e
    .label _19 = $39
    .label _21 = $3e
    .label mix = 6
    .label dist = 2
    .label angle = 4
    .label i = 8
    .label bucket_size = $38
    .label bucket_idx = $a
    .label bucket_size1 = $3d
    .label bucket = $39
    .label sc = $3b
    .label bucket1 = $3e
    .label sc1 = $40
    .label _23 = $39
    .label _24 = $3e
    jsr init_dist_screen
    jsr init_angle_screen
    lda #<0
    sta i
    sta i+1
    lda #<SCREEN_MIX
    sta mix
    lda #>SCREEN_MIX
    sta mix+1
    lda #<SCREEN_ANGLE
    sta angle
    lda #>SCREEN_ANGLE
    sta angle+1
    lda #<SCREEN_DIST
    sta dist
    lda #>SCREEN_DIST
    sta dist+1
  b1:
    ldy #0
    lda (dist),y
    asl
    asl
    sta _3
    lda (angle),y
    lsr
    clc
    adc _3
    sta (mix),y
    inc mix
    bne !+
    inc mix+1
  !:
    inc dist
    bne !+
    inc dist+1
  !:
    inc angle
    bne !+
    inc angle+1
  !:
    inc i
    bne !+
    inc i+1
  !:
    lda i+1
    cmp #>$3e8
    bne b1
    lda i
    cmp #<$3e8
    bne b1
    jsr init_buckets
    lda #0
    sta bucket_idx
  b4:
    lda #$fe
    cmp RASTER
    bne b4
  b5:
    lda #$ff
    cmp RASTER
    bne b5
    inc BORDERCOL
    // First clear the current bucket
    ldy bucket_idx
    lda BUCKET_SIZES,y
    sta bucket_size
    cmp #0
    beq b8
    tya
    sta _11
    lda #0
    sta _11+1
    asl _19
    rol _19+1
    clc
    lda _23
    adc #<BUCKETS
    sta _23
    lda _23+1
    adc #>BUCKETS
    sta _23+1
    ldy #0
    lda (bucket),y
    pha
    iny
    lda (bucket),y
    sta bucket+1
    pla
    sta bucket
    ldx #0
  b9:
    txa
    asl
    tay
    clc
    lda #<SCREEN_FILL
    adc (bucket),y
    sta sc
    iny
    lda #>SCREEN_FILL
    adc (bucket),y
    sta sc+1
    lda #' '
    ldy #0
    sta (sc),y
    inx
    cpx bucket_size
    bcc b9
  b8:
    inc bucket_idx
    // Plot char in the bucket
    ldy bucket_idx
    lda BUCKET_SIZES,y
    sta bucket_size1
    cmp #0
    beq b11
    tya
    sta _16
    lda #0
    sta _16+1
    asl _21
    rol _21+1
    clc
    lda _24
    adc #<BUCKETS
    sta _24
    lda _24+1
    adc #>BUCKETS
    sta _24+1
    ldy #0
    lda (bucket1),y
    pha
    iny
    lda (bucket1),y
    sta bucket1+1
    pla
    sta bucket1
    ldx #0
  b12:
    txa
    asl
    tay
    clc
    lda #<SCREEN_FILL
    adc (bucket1),y
    sta sc1
    iny
    lda #>SCREEN_FILL
    adc (bucket1),y
    sta sc1+1
    lda #'*'
    ldy #0
    sta (sc1),y
    inx
    cpx bucket_size1
    bcc b12
  b11:
    dec BORDERCOL
    jmp b4
}
// Initialize buckets containing indices of chars on the screen with specific distances to the center.
init_buckets: {
    .label _5 = $17
    .label _9 = $44
    .label _10 = $46
    .label _12 = $42
    .label _13 = $44
    .label dist = $b
    .label i1 = $d
    .label i2 = $f
    .label bucket = $44
    .label dist_3 = $11
    .label i4 = $13
    .label dist_5 = $11
    .label _15 = $17
    .label _16 = $42
    .label _17 = $44
    ldx #0
  // Init bucket sizes to 0
  b1:
    lda #0
    sta BUCKET_SIZES,x
    inx
    cpx #0
    bne b1
    sta i1
    sta i1+1
    lda #<SCREEN_MIX
    sta dist
    lda #>SCREEN_MIX
    sta dist+1
  b2:
    ldy #0
    lda (dist),y
    tax
    inc BUCKET_SIZES,x
    inc dist
    bne !+
    inc dist+1
  !:
    inc i1
    bne !+
    inc i1+1
  !:
    lda i1+1
    cmp #>$3e8
    bne b2
    lda i1
    cmp #<$3e8
    bne b2
    lda #<0
    sta i2
    sta i2+1
  // Allocate the buckets
  b3:
    lda i2
    clc
    adc #<BUCKET_SIZES
    sta _15
    lda i2+1
    adc #>BUCKET_SIZES
    sta _15+1
    ldy #0
    lda (malloc.size),y
    asl
    sta malloc.size
    tya
    rol
    sta malloc.size+1
    jsr malloc
    lda i2
    asl
    sta _12
    lda i2+1
    rol
    sta _12+1
    clc
    lda _16
    adc #<BUCKETS
    sta _16
    lda _16+1
    adc #>BUCKETS
    sta _16+1
    ldy #0
    lda _5
    sta (_16),y
    iny
    lda _5+1
    sta (_16),y
    inc i2
    bne !+
    inc i2+1
  !:
    lda i2+1
    cmp #>NUM_BUCKETS-1+1
    bne b3
    lda i2
    cmp #<NUM_BUCKETS-1+1
    bne b3
    ldx #0
  // Iterate all distances and fill the buckets with indices into the screens
  b4:
    lda #0
    sta BUCKET_IDX,x
    inx
    cpx #0
    bne b4
    sta i4
    sta i4+1
    lda #<SCREEN_MIX
    sta dist_5
    lda #>SCREEN_MIX
    sta dist_5+1
  b5:
    ldy #0
    lda (dist_5),y
    tax
    txa
    sta _9
    tya
    sta _9+1
    asl _13
    rol _13+1
    clc
    lda _17
    adc #<BUCKETS
    sta _17
    lda _17+1
    adc #>BUCKETS
    sta _17+1
    lda (bucket),y
    pha
    iny
    lda (bucket),y
    sta bucket+1
    pla
    sta bucket
    lda dist_5
    sec
    sbc #<SCREEN_MIX
    sta _10
    lda dist_5+1
    sbc #>SCREEN_MIX
    sta _10+1
    lda BUCKET_IDX,x
    asl
    tay
    lda _10
    sta (bucket),y
    iny
    lda _10+1
    sta (bucket),y
    inc BUCKET_IDX,x
    inc dist_3
    bne !+
    inc dist_3+1
  !:
    inc i4
    bne !+
    inc i4+1
  !:
    lda i4+1
    cmp #>$3e8
    bne b5
    lda i4
    cmp #<$3e8
    bne b5
    rts
}
// Allocates a block of size bytes of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
// malloc(word zeropage($17) size)
malloc: {
    .label mem = $17
    .label size = $17
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
// Populates 1000 bytes (a screen) with values representing the angle to the center.
// Utilizes symmetry around the center
init_angle_screen: {
    .label _10 = $24
    .label xw = $48
    .label yw = $4a
    .label angle_w = $24
    .label ang_w = $4c
    .label x = $1e
    .label xb = $1f
    .label screen_topline = $1c
    .label screen_bottomline = $1a
    .label y = $19
    lda #<SCREEN_ANGLE+$28*$c
    sta screen_topline
    lda #>SCREEN_ANGLE+$28*$c
    sta screen_topline+1
    lda #<SCREEN_ANGLE+$28*$c
    sta screen_bottomline
    lda #>SCREEN_ANGLE+$28*$c
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
// atan2_16(signed word zeropage($48) x, signed word zeropage($4a) y)
atan2_16: {
    .label _2 = $20
    .label _7 = $22
    .label yi = $20
    .label xi = $22
    .label angle = $24
    .label xd = $28
    .label yd = $26
    .label return = $24
    .label x = $48
    .label y = $4a
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
    lda #0
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
// Utilizes symmetry around the center
init_dist_screen: {
    .label yds = $4d
    .label xds = $4f
    .label ds = $4f
    .label x = $2f
    .label xb = $30
    .label screen_topline = $2b
    .label screen_bottomline = $2d
    .label y = $2a
    jsr init_squares
    lda #<SCREEN_DIST+$28*$18
    sta screen_bottomline
    lda #>SCREEN_DIST+$28*$18
    sta screen_bottomline+1
    lda #<SCREEN_DIST
    sta screen_topline
    lda #>SCREEN_DIST
    sta screen_topline+1
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
// sqrt(word zeropage($4f) val)
sqrt: {
    .label _1 = $31
    .label _3 = $31
    .label found = $31
    .label val = $4f
    lda SQUARES
    sta bsearch16u.items
    lda SQUARES+1
    sta bsearch16u.items+1
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
// bsearch16u(word zeropage($4f) key, word* zeropage($31) items, byte register(X) num)
bsearch16u: {
    .label _2 = $31
    .label pivot = $51
    .label result = $53
    .label return = $31
    .label items = $31
    .label key = $4f
    ldx #NUM_SQUARES
  b3:
    cpx #0
    bne b4
    ldy #1
    lda (items),y
    cmp key+1
    bne !+
    dey
    lda (items),y
    cmp key
    beq b2
  !:
    bcc b2
    lda _2
    sec
    sbc #<1*SIZEOF_WORD
    sta _2
    lda _2+1
    sbc #>1*SIZEOF_WORD
    sta _2+1
  b2:
    rts
  b4:
    txa
    lsr
    asl
    clc
    adc items
    sta pivot
    lda #0
    adc items+1
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
    lda pivot
    sta return
    lda pivot+1
    sta return+1
    rts
  b6:
    lda result+1
    bmi b7
    bne !+
    lda result
    beq b7
  !:
    lda #1*SIZEOF_WORD
    clc
    adc pivot
    sta items
    lda #0
    adc pivot+1
    sta items+1
    dex
  b7:
    txa
    lsr
    tax
    jmp b3
}
// Find the square of a byte value
// Uses a table of squares that must be initialized by calling init_squares()
// sqr(byte register(A) val)
sqr: {
    .label return = $4f
    .label return_2 = $4d
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
    .label squares = $35
    .label sqr = $33
    lda #NUM_SQUARES*SIZEOF_WORD
    sta malloc.size
    lda #0
    sta malloc.size+1
    lda #<HEAP_TOP
    sta heap_head
    lda #>HEAP_TOP
    sta heap_head+1
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
  // Angles representing ATAN(0.5), ATAN(0.25), ATAN(0.125), ...
CORDIC_ATAN2_ANGLES_16:
.for (var i=0; i<CORDIC_ITERATIONS_16; i++)
        .word 256*2*256*atan(1/pow(2,i))/PI/2

  // Screen containing distance to center
  SCREEN_DIST: .fill $3e8, 0
  // = malloc(1000);
  // Screen containing angle to center
  SCREEN_ANGLE: .fill $3e8, 0
  // = malloc(1000);
  // Screen containing angle to center
  SCREEN_MIX: .fill $3e8, 0
  // Array containing the bucket size for each of the distance buckets
  BUCKET_SIZES: .fill NUM_BUCKETS, 0
  // Buckets containing screen indices for each distance from the center.
  // BUCKETS[dist] is an array of words containing screen indices.
  // The size of the array BUCKETS[dist] is BUCKET_SIZES[dist]
  BUCKETS: .fill 2*NUM_BUCKETS, 0
  // Current index into each bucket. Used while populating the buckets. (After population the end the values will be equal to the bucket sizes)
  BUCKET_IDX: .fill NUM_BUCKETS, 0
