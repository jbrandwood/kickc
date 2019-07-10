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
  .label heap_head = $12
  .label SQUARES = $14
  // Screen containing distance to center
  .label SCREEN_DIST = $34
  // Screen containing angle to center
  .label SCREEN_ANGLE = $36
  // Array containing the bucket size for each of the distance buckets
  .label BUCKET_SIZES = $38
  // Buckets containing screen indices for each distance from the center.
  // BUCKETS[dist] is an array of words containing screen indices.
  // The size of the array BUCKETS[dist] is BUCKET_SIZES[dist]
  .label BUCKETS = $3a
  // Current index into each bucket. Used while populating the buckets. (After population the end the values will be equal to the bucket sizes)
  .label BUCKET_IDX = $3c
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
  lda #<NUM_BUCKETS*SIZEOF_BYTE
  sta malloc.size
  lda #>NUM_BUCKETS*SIZEOF_BYTE
  sta malloc.size+1
  jsr malloc
  lda malloc.mem
  sta BUCKET_SIZES
  lda malloc.mem+1
  sta BUCKET_SIZES+1
  lda #<NUM_BUCKETS*SIZEOF_POINTER
  sta malloc.size
  lda #>NUM_BUCKETS*SIZEOF_POINTER
  sta malloc.size+1
  jsr malloc
  lda malloc.mem
  sta BUCKETS
  lda malloc.mem+1
  sta BUCKETS+1
  lda #<NUM_BUCKETS*SIZEOF_BYTE
  sta malloc.size
  lda #>NUM_BUCKETS*SIZEOF_BYTE
  sta malloc.size+1
  jsr malloc
  lda malloc.mem
  sta BUCKET_IDX
  lda malloc.mem+1
  sta BUCKET_IDX+1
  jsr main
  rts
main: {
    .label bucket = $3e
    .label bucket_size = $40
    .label bucket_idx = 2
    .label offset = 6
    .label fill = $41
    .label angle = $43
    .label min_angle = 3
    .label fill1 = 6
    .label min_offset = 6
    .label min_offset_5 = 4
    .label min_offset_7 = 4
    sei
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
    jsr init_buckets
    lda #0
    sta bucket_idx
  b2:
    lda #$ff
    cmp RASTER
    bne b2
    inc BORDERCOL
    lda bucket_idx
    asl
    tay
    lda (BUCKETS),y
    sta bucket
    iny
    lda (BUCKETS),y
    sta bucket+1
    ldy bucket_idx
    lda (BUCKET_SIZES),y
    sta bucket_size
    cmp #0
    beq b4
    lda #<$ffff
    sta min_offset_5
    lda #>$ffff
    sta min_offset_5+1
    lda #$ff
    sta min_angle
    ldx #0
  b5:
    txa
    asl
    tay
    lda (bucket),y
    sta offset
    iny
    lda (bucket),y
    sta offset+1
    lda offset
    clc
    adc #<SCREEN_FILL
    sta fill
    lda offset+1
    adc #>SCREEN_FILL
    sta fill+1
    lda #FILL_CHAR
    ldy #0
    cmp (fill),y
    beq b18
    lda SCREEN_ANGLE
    clc
    adc offset
    sta angle
    lda SCREEN_ANGLE+1
    adc offset+1
    sta angle+1
    lda (angle),y
    cmp min_angle
    beq !+
    bcs b17
  !:
    ldy #0
    lda (angle),y
    sta min_angle
  b6:
    inx
    cpx bucket_size
    bcc b16
    lda min_offset
    cmp #<$ffff
    bne !+
    lda min_offset+1
    cmp #>$ffff
    beq b4
  !:
    clc
    lda fill1
    adc #<SCREEN_FILL
    sta fill1
    lda fill1+1
    adc #>SCREEN_FILL
    sta fill1+1
    lda #FILL_CHAR
    ldy #0
    sta (fill1),y
    dec BORDERCOL
    jmp b2
  b4:
    inc bucket_idx
    lda #NUM_BUCKETS
    cmp bucket_idx
    bne b11
    dec BORDERCOL
  b13:
    inc COLS+$3e7
    jmp b13
  b11:
    dec BORDERCOL
    jmp b2
  b16:
    lda min_offset
    sta min_offset_7
    lda min_offset+1
    sta min_offset_7+1
    jmp b5
  b17:
    lda min_offset_5
    sta min_offset
    lda min_offset_5+1
    sta min_offset+1
    jmp b6
  b18:
    lda min_offset_5
    sta min_offset
    lda min_offset_5+1
    sta min_offset+1
    jmp b6
}
// Initialize buckets containing indices of chars on the screen with specific distances to the center.
// init_buckets(byte* zeropage($34) screen)
init_buckets: {
    .label _5 = $14
    .label _9 = $48
    .label _10 = $4a
    .label _12 = $45
    .label _13 = $48
    .label screen = $34
    .label dist = 8
    .label i1 = $a
    .label i2 = $c
    .label distance = $47
    .label bucket = $48
    .label dist_3 = $e
    .label i4 = $10
    .label dist_5 = $e
    .label _15 = $14
    .label _16 = $45
    .label _17 = $48
    .label dist_8 = $e
    ldy #0
  // Init bucket sizes to 0
  b1:
    lda #0
    sta (BUCKET_SIZES),y
    iny
    cpy #NUM_BUCKETS-1+1
    bne b1
    lda screen
    sta dist
    lda screen+1
    sta dist+1
    lda #<0
    sta i1
    sta i1+1
  b3:
    ldy #0
    lda (dist),y
    tay
    lda (BUCKET_SIZES),y
    clc
    adc #1
    sta (BUCKET_SIZES),y
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
    bne b3
    lda i1
    cmp #<$3e8
    bne b3
    lda #<0
    sta i2
    sta i2+1
  // Allocate the buckets
  b4:
    lda BUCKET_SIZES
    clc
    adc i2
    sta _15
    lda BUCKET_SIZES+1
    adc i2+1
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
    lda _16
    clc
    adc BUCKETS
    sta _16
    lda _16+1
    adc BUCKETS+1
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
    bne b4
    lda i2
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
    lda screen
    sta dist_8
    lda screen+1
    sta dist_8+1
    lda #<0
    sta i4
    sta i4+1
  b7:
    ldy #0
    lda (dist_5),y
    sta distance
    sta _9
    tya
    sta _9+1
    asl _13
    rol _13+1
    lda _17
    clc
    adc BUCKETS
    sta _17
    lda _17+1
    adc BUCKETS+1
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
    sbc screen
    sta _10
    lda dist_5+1
    sbc screen+1
    sta _10+1
    ldy distance
    lda (BUCKET_IDX),y
    asl
    tay
    lda _10
    sta (bucket),y
    iny
    lda _10+1
    sta (bucket),y
    ldy distance
    lda (BUCKET_IDX),y
    clc
    adc #1
    sta (BUCKET_IDX),y
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
    bne b7
    lda i4
    cmp #<$3e8
    bne b7
    rts
}
// Allocates a block of size bytes of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
// malloc(word zeropage($14) size)
malloc: {
    .label mem = $14
    .label size = $14
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
// init_angle_screen(byte* zeropage($17) screen)
init_angle_screen: {
    .label _10 = $21
    .label screen = $17
    .label screen_topline = $19
    .label screen_bottomline = $17
    .label xw = $4c
    .label yw = $4e
    .label angle_w = $21
    .label ang_w = $50
    .label x = $1b
    .label xb = $1c
    .label y = $16
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
// atan2_16(signed word zeropage($4c) x, signed word zeropage($4e) y)
atan2_16: {
    .label _2 = $1d
    .label _7 = $1f
    .label yi = $1d
    .label xi = $1f
    .label angle = $21
    .label xd = $25
    .label yd = $23
    .label return = $21
    .label x = $4c
    .label y = $4e
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
// Utilizes symmetry around the center
// init_dist_screen(byte* zeropage($28) screen)
init_dist_screen: {
    .label screen = $28
    .label screen_bottomline = $2a
    .label yds = $51
    .label xds = $53
    .label ds = $53
    .label x = $2c
    .label xb = $2d
    .label screen_topline = $28
    .label y = $27
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
// sqrt(word zeropage($53) val)
sqrt: {
    .label _1 = $2e
    .label _3 = $2e
    .label found = $2e
    .label val = $53
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
// bsearch16u(word zeropage($53) key, word* zeropage($2e) items, byte register(X) num)
bsearch16u: {
    .label _2 = $2e
    .label pivot = $55
    .label result = $57
    .label return = $2e
    .label items = $2e
    .label key = $53
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
    .label return = $53
    .label return_2 = $51
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
    .label squares = $32
    .label sqr = $30
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
// Angles representing ATAN(0.5), ATAN(0.25), ATAN(0.125), ...
CORDIC_ATAN2_ANGLES_16:
.for (var i=0; i<CORDIC_ITERATIONS_16; i++)
        .word 256*2*256*atan(1/pow(2,i))/PI/2

