// Fill screen using a spiral based on distance-to-center / angle-to-center
// Utilizes a bucket sort for identifying the minimum angle/distance
  // Commodore 64 PRG executable file
.file [name="screen-show-spiral-buckets.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const SIZEOF_WORD = 2
  // The number of iterations performed during 16-bit CORDIC atan2 calculation
  .const CORDIC_ITERATIONS_16 = $f
  // Char to fill with
  .const FILL_CHAR = '*'
  // The number of buckets in our bucket sort
  .const NUM_BUCKETS = $30
  .const SIZEOF_BYTE = 1
  .const SIZEOF_POINTER = 2
  // The number of squares to pre-calculate. Limits what values sqr() can calculate and the result of sqrt()
  .const NUM_SQUARES = $30
  /// $D012 RASTER Raster counter
  .label RASTER = $d012
  /// $D020 Border Color
  .label BORDER_COLOR = $d020
  /// Color Ram
  .label COLS = $d800
  // Screen containing angle to center
  .label SCREEN_FILL = $400
  // Top of the heap used by malloc()
  .label HEAP_TOP = $a000
  // Head of the heap. Moved backward each malloc()
  .label heap_head = 3
  // Squares for each char value SQUARES[i] = i*i
  // Initialized by init_squares()
  .label SQUARES = 6
  // Screen containing distance to center
  .label SCREEN_DIST = $1d
  // Screen containing angle to center
  .label SCREEN_ANGLE = $14
  // Array containing the bucket size for each of the distance buckets
  .label BUCKET_SIZES = $16
  // Buckets containing screen indices for each distance from the center.
  // BUCKETS[dist] is an array of words containing screen indices.
  // The size of the array BUCKETS[dist] is BUCKET_SIZES[dist]
  .label BUCKETS = $18
  // Current index into each bucket. Used while populating the buckets. (After population the end the values will be equal to the bucket sizes)
  .label BUCKET_IDX = $1f
.segment Code
__start: {
    // byte* SCREEN_DIST = malloc(1000)
    lda #<$3e8
    sta.z malloc.size
    lda #>$3e8
    sta.z malloc.size+1
    lda #<HEAP_TOP
    sta.z heap_head
    lda #>HEAP_TOP
    sta.z heap_head+1
    jsr malloc
    // byte* SCREEN_DIST = malloc(1000)
    lda.z malloc.mem
    sta.z SCREEN_DIST
    lda.z malloc.mem+1
    sta.z SCREEN_DIST+1
    // byte* SCREEN_ANGLE= malloc(1000)
    lda #<$3e8
    sta.z malloc.size
    lda #>$3e8
    sta.z malloc.size+1
    jsr malloc
    // byte* SCREEN_ANGLE= malloc(1000)
    lda.z malloc.mem
    sta.z SCREEN_ANGLE
    lda.z malloc.mem+1
    sta.z SCREEN_ANGLE+1
    // byte* BUCKET_SIZES = malloc(NUM_BUCKETS*sizeof(byte))
    lda #<NUM_BUCKETS*SIZEOF_BYTE
    sta.z malloc.size
    lda #>NUM_BUCKETS*SIZEOF_BYTE
    sta.z malloc.size+1
    jsr malloc
    // byte* BUCKET_SIZES = malloc(NUM_BUCKETS*sizeof(byte))
    lda.z malloc.mem
    sta.z BUCKET_SIZES
    lda.z malloc.mem+1
    sta.z BUCKET_SIZES+1
    // word** BUCKETS = malloc(NUM_BUCKETS*sizeof(word*))
    lda #<NUM_BUCKETS*SIZEOF_POINTER
    sta.z malloc.size
    lda #>NUM_BUCKETS*SIZEOF_POINTER
    sta.z malloc.size+1
    jsr malloc
    // word** BUCKETS = malloc(NUM_BUCKETS*sizeof(word*))
    lda.z malloc.mem
    sta.z BUCKETS
    lda.z malloc.mem+1
    sta.z BUCKETS+1
    // byte* BUCKET_IDX = malloc(NUM_BUCKETS*sizeof(byte))
    lda #<NUM_BUCKETS*SIZEOF_BYTE
    sta.z malloc.size
    lda #>NUM_BUCKETS*SIZEOF_BYTE
    sta.z malloc.size+1
    jsr malloc
    // byte* BUCKET_IDX = malloc(NUM_BUCKETS*sizeof(byte))
    lda.z malloc.mem
    sta.z BUCKET_IDX
    lda.z malloc.mem+1
    sta.z BUCKET_IDX+1
    jsr main
    rts
}
// Allocates a block of size chars of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
// malloc(word zp(6) size)
malloc: {
    .label mem = 6
    .label size = 6
    // unsigned char* mem = heap_head-size
    lda.z heap_head
    sec
    sbc.z mem
    sta.z mem
    lda.z heap_head+1
    sbc.z mem+1
    sta.z mem+1
    // heap_head = mem
    lda.z mem
    sta.z heap_head
    lda.z mem+1
    sta.z heap_head+1
    // }
    rts
}
main: {
    .label bucket = $1a
    .label bucket_size = $1c
    // Animate a spiral walking through the buckets one at a time
    .label bucket_idx = 2
    .label offset = 6
    .label fill = $1d
    .label angle = $1f
    // Find the minimum unfilled angle in the current bucket
    .label min_angle = 5
    .label fill1 = 3
    .label min_offset = 3
    .label min_offset_1 = 6
    // asm
    sei
    // init_dist_screen(SCREEN_DIST)
    lda.z SCREEN_DIST
    sta.z init_dist_screen.screen
    lda.z SCREEN_DIST+1
    sta.z init_dist_screen.screen+1
    jsr init_dist_screen
    // init_angle_screen(SCREEN_ANGLE)
    lda.z SCREEN_ANGLE
    sta.z init_angle_screen.screen
    lda.z SCREEN_ANGLE+1
    sta.z init_angle_screen.screen+1
    jsr init_angle_screen
    // init_buckets(SCREEN_DIST)
    jsr init_buckets
    lda #0
    sta.z bucket_idx
  __b2:
    // while (*RASTER!=0xff)
    lda #$ff
    cmp RASTER
    bne __b2
    // (*BORDER_COLOR)++;
    inc BORDER_COLOR
    // word* bucket = BUCKETS[bucket_idx]
    lda.z bucket_idx
    asl
    tay
    lda (BUCKETS),y
    sta.z bucket
    iny
    lda (BUCKETS),y
    sta.z bucket+1
    // byte bucket_size = BUCKET_SIZES[bucket_idx]
    ldy.z bucket_idx
    lda (BUCKET_SIZES),y
    sta.z bucket_size
    // if(bucket_size>0)
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
    // for( byte i=0;i<bucket_size;i++)
    cpx.z bucket_size
    bcc __b6
    // if(min_offset!=0xffff)
    lda.z min_offset
    cmp #<$ffff
    bne !+
    lda.z min_offset+1
    cmp #>$ffff
    beq __b4
  !:
    // byte* fill = SCREEN_FILL+min_offset
    // Found something to fill!
    lda.z fill1
    clc
    adc #<SCREEN_FILL
    sta.z fill1
    lda.z fill1+1
    adc #>SCREEN_FILL
    sta.z fill1+1
    // *fill = FILL_CHAR
    lda #FILL_CHAR
    ldy #0
    sta (fill1),y
    // (*BORDER_COLOR)--;
    dec BORDER_COLOR
    jmp __b2
  __b4:
    // bucket_idx++;
    inc.z bucket_idx
    // if(bucket_idx==NUM_BUCKETS)
    lda #NUM_BUCKETS
    cmp.z bucket_idx
    bne __b12
    // (*BORDER_COLOR)--;
    dec BORDER_COLOR
  __b14:
    // (*(COLS+999))++;
    inc COLS+$3e7
    jmp __b14
  __b12:
    // (*BORDER_COLOR)--;
    dec BORDER_COLOR
    jmp __b2
  __b6:
    // word offset = bucket[i]
    txa
    asl
    tay
    lda (bucket),y
    sta.z offset
    iny
    lda (bucket),y
    sta.z offset+1
    // byte* fill = SCREEN_FILL+offset
    lda.z offset
    clc
    adc #<SCREEN_FILL
    sta.z fill
    lda.z offset+1
    adc #>SCREEN_FILL
    sta.z fill+1
    // if(*fill!=FILL_CHAR)
    lda #FILL_CHAR
    ldy #0
    cmp (fill),y
    beq __b18
    // byte* angle = SCREEN_ANGLE+offset
    lda.z SCREEN_ANGLE
    clc
    adc.z offset
    sta.z angle
    lda.z SCREEN_ANGLE+1
    adc.z offset+1
    sta.z angle+1
    // if(*angle<=min_angle)
    lda (angle),y
    cmp.z min_angle
    beq !+
    bcs __b17
  !:
    // min_angle = *angle
    ldy #0
    lda (angle),y
    sta.z min_angle
  __b8:
    // for( byte i=0;i<bucket_size;i++)
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
// Populates 1000 bytes (a screen) with values representing the distance to the center.
// The actual value stored is distance*2 to increase precision
// Utilizes symmetry around the center
// init_dist_screen(byte* zp($26) screen)
init_dist_screen: {
    .label screen = $26
    .label screen_bottomline = 8
    .label yds = $21
    .label screen_topline = $26
    .label y = $1c
    .label xds = $23
    .label ds = $23
    .label x = $a
    .label xb = $b
    // init_squares()
    jsr init_squares
    // byte *screen_bottomline = screen+40*24
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
    // byte y2 = y*2
    lda.z y
    asl
    // (y2>=24)?(y2-24):(24-y2)
    cmp #$18
    bcs __b2
    eor #$ff
    sec
    adc #$18
  __b4:
    // word yds = sqr(yd)
    jsr sqr
    // word yds = sqr(yd)
    lda.z sqr.return
    sta.z sqr.return_1
    lda.z sqr.return+1
    sta.z sqr.return_1+1
    lda #$27
    sta.z xb
    lda #0
    sta.z x
  __b5:
    // for( byte x=0,xb=39; x<=19; x++, xb--)
    lda.z x
    cmp #$13+1
    bcc __b6
    // screen_topline += 40
    lda #$28
    clc
    adc.z screen_topline
    sta.z screen_topline
    bcc !+
    inc.z screen_topline+1
  !:
    // screen_bottomline -= 40
    sec
    lda.z screen_bottomline
    sbc #$28
    sta.z screen_bottomline
    lda.z screen_bottomline+1
    sbc #0
    sta.z screen_bottomline+1
    // for(byte y: 0..12)
    inc.z y
    lda #$d
    cmp.z y
    bne __b1
    // }
    rts
  __b6:
    // byte x2 = x*2
    lda.z x
    asl
    // (x2>=39)?(x2-39):(39-x2)
    cmp #$27
    bcs __b8
    eor #$ff
    sec
    adc #$27
  __b10:
    // word xds = sqr(xd)
    jsr sqr
    // word xds = sqr(xd)
    // word ds = xds+yds
    clc
    lda.z ds
    adc.z yds
    sta.z ds
    lda.z ds+1
    adc.z yds+1
    sta.z ds+1
    // byte d = sqrt(ds)
    jsr sqrt
    // screen_topline[x] = d
    ldy.z x
    sta (screen_topline),y
    // screen_bottomline[x] = d
    sta (screen_bottomline),y
    // screen_topline[xb] = d
    ldy.z xb
    sta (screen_topline),y
    // screen_bottomline[xb] = d
    sta (screen_bottomline),y
    // for( byte x=0,xb=39; x<=19; x++, xb--)
    inc.z x
    dec.z xb
    jmp __b5
  __b8:
    // (x2>=39)?(x2-39):(39-x2)
    sec
    sbc #$27
    jmp __b10
  __b2:
    // (y2>=24)?(y2-24):(24-y2)
    sec
    sbc #$18
    jmp __b4
}
// Populates 1000 bytes (a screen) with values representing the angle to the center.
// Utilizes symmetry around the center
// init_angle_screen(byte* zp(8) screen)
init_angle_screen: {
    .label __9 = $10
    .label screen = 8
    .label screen_bottomline = 8
    .label xw = $21
    .label yw = $23
    .label angle_w = $10
    .label ang_w = $25
    .label x = $a
    .label xb = $b
    .label screen_topline = $26
    .label y = $1c
    // byte* screen_topline = screen+40*12
    lda.z screen_bottomline
    clc
    adc #<$28*$c
    sta.z screen_bottomline
    lda.z screen_bottomline+1
    adc #>$28*$c
    sta.z screen_bottomline+1
    lda.z screen_bottomline
    sta.z screen_topline
    lda.z screen_bottomline+1
    sta.z screen_topline+1
    lda #0
    sta.z y
  __b1:
    lda #$27
    sta.z xb
    lda #0
    sta.z x
  __b2:
    // for( byte x=0,xb=39; x<=19; x++, xb--)
    lda.z x
    cmp #$13+1
    bcc __b3
    // screen_topline -= 40
    sec
    lda.z screen_topline
    sbc #$28
    sta.z screen_topline
    lda.z screen_topline+1
    sbc #0
    sta.z screen_topline+1
    // screen_bottomline += 40
    lda #$28
    clc
    adc.z screen_bottomline
    sta.z screen_bottomline
    bcc !+
    inc.z screen_bottomline+1
  !:
    // for(byte y: 0..12)
    inc.z y
    lda #$d
    cmp.z y
    bne __b1
    // }
    rts
  __b3:
    // x*2
    lda.z x
    asl
    // 39-x*2
    eor #$ff
    sec
    adc #$27
    // MAKEWORD( 39-x*2, 0 )
    ldy #0
    sta.z xw+1
    sty.z xw
    // y*2
    lda.z y
    asl
    // MAKEWORD( y*2, 0 )
    sta.z yw+1
    sty.z yw
    // word angle_w = atan2_16(xw, yw)
    jsr atan2_16
    // angle_w+0x0080
    lda #$80
    clc
    adc.z __9
    sta.z __9
    bcc !+
    inc.z __9+1
  !:
    // byte ang_w = BYTE1(angle_w+0x0080)
    lda.z __9+1
    sta.z ang_w
    // screen_bottomline[xb] = ang_w
    ldy.z xb
    sta (screen_bottomline),y
    // -ang_w
    eor #$ff
    clc
    adc #1
    // screen_topline[xb] = -ang_w
    sta (screen_topline),y
    // 0x80+ang_w
    lda #$80
    clc
    adc.z ang_w
    // screen_topline[x] = 0x80+ang_w
    ldy.z x
    sta (screen_topline),y
    // 0x80-ang_w
    lda #$80
    sec
    sbc.z ang_w
    // screen_bottomline[x] = 0x80-ang_w
    sta (screen_bottomline),y
    // for( byte x=0,xb=39; x<=19; x++, xb--)
    inc.z x
    dec.z xb
    jmp __b2
}
// Initialize buckets containing indices of chars on the screen with specific distances to the center.
// init_buckets(byte* zp($1d) screen)
init_buckets: {
    .label __4 = 6
    .label __7 = $26
    .label __11 = $28
    .label __12 = $2a
    .label __14 = $2a
    .label screen = $1d
    .label dist = $12
    .label i1 = $1a
    .label i2 = $c
    .label distance = $25
    .label bucket = $2a
    .label dist_1 = $e
    .label i4 = $10
    .label __15 = 6
    .label __16 = $28
    .label __17 = $2a
    ldy #0
  // Init bucket sizes to 0
  __b1:
    // BUCKET_SIZES[i]=0
    lda #0
    sta (BUCKET_SIZES),y
    // for(byte i:0..NUM_BUCKETS-1)
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
    // BUCKET_SIZES[*dist]++;
    ldy #0
    lda (dist),y
    tay
    clc
    lda (BUCKET_SIZES),y
    adc #1
    sta (BUCKET_SIZES),y
    // dist++;
    inc.z dist
    bne !+
    inc.z dist+1
  !:
    // for( word i:0..999)
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
    // malloc(BUCKET_SIZES[i]*sizeof(byte*))
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
    // malloc(BUCKET_SIZES[i]*sizeof(byte*))
    // BUCKETS[i] = malloc(BUCKET_SIZES[i]*sizeof(byte*))
    lda.z i2
    asl
    sta.z __11
    lda.z i2+1
    rol
    sta.z __11+1
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
    // for( word i:0..NUM_BUCKETS-1)
    inc.z i2
    bne !+
    inc.z i2+1
  !:
    lda.z i2+1
    bne __b4
    lda.z i2
    cmp #NUM_BUCKETS-1+1
    bne __b4
    ldy #0
  // Iterate all distances and fill the buckets with indices into the screens
  __b5:
    // BUCKET_IDX[i]=0
    lda #0
    sta (BUCKET_IDX),y
    // for(byte i:0..NUM_BUCKETS-1)
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
    // byte distance = *dist
    ldy #0
    lda (dist_1),y
    sta.z distance
    // word* bucket = BUCKETS[(word)distance]
    sta.z __14
    tya
    sta.z __14+1
    asl.z __12
    rol.z __12+1
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
    // dist-screen
    lda.z dist_1
    sec
    sbc.z screen
    sta.z __7
    lda.z dist_1+1
    sbc.z screen+1
    sta.z __7+1
    // bucket[BUCKET_IDX[distance]] = dist-screen
    ldy.z distance
    lda (BUCKET_IDX),y
    asl
    tay
    lda.z __7
    sta (bucket),y
    iny
    lda.z __7+1
    sta (bucket),y
    // BUCKET_IDX[distance]++;
    ldy.z distance
    clc
    lda (BUCKET_IDX),y
    adc #1
    sta (BUCKET_IDX),y
    // *dist++;
    inc.z dist_1
    bne !+
    inc.z dist_1+1
  !:
    // for(word i:0..999)
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
    // }
    rts
}
// Initialize squares table
// Uses iterative formula (x+1)^2 = x^2 + 2*x + 1
init_squares: {
    .label squares = $1a
    .label sqr = $12
    // malloc(NUM_SQUARES*sizeof(unsigned int))
    lda #<NUM_SQUARES*SIZEOF_WORD
    sta.z malloc.size
    lda #>NUM_SQUARES*SIZEOF_WORD
    sta.z malloc.size+1
    jsr malloc
    // malloc(NUM_SQUARES*sizeof(unsigned int))
    // unsigned int* squares = SQUARES
    lda.z SQUARES
    sta.z squares
    lda.z SQUARES+1
    sta.z squares+1
    lda #<0
    sta.z sqr
    sta.z sqr+1
    tax
  __b1:
    // for(char i=0;i<NUM_SQUARES;i++)
    cpx #NUM_SQUARES
    bcc __b2
    // }
    rts
  __b2:
    // *squares++ = sqr
    ldy #0
    lda.z sqr
    sta (squares),y
    iny
    lda.z sqr+1
    sta (squares),y
    // *squares++ = sqr;
    lda #SIZEOF_WORD
    clc
    adc.z squares
    sta.z squares
    bcc !+
    inc.z squares+1
  !:
    // i*2
    txa
    asl
    // i*2+1
    clc
    adc #1
    // sqr += i*2+1
    clc
    adc.z sqr
    sta.z sqr
    bcc !+
    inc.z sqr+1
  !:
    // for(char i=0;i<NUM_SQUARES;i++)
    inx
    jmp __b1
}
// Find the square of a char value
// Uses a table of squares that must be initialized by calling init_squares()
// sqr(byte register(A) val)
sqr: {
    .label return = $23
    .label return_1 = $21
    // return SQUARES[val];
    asl
    tay
    lda (SQUARES),y
    sta.z return
    iny
    lda (SQUARES),y
    sta.z return+1
    // }
    rts
}
// Find the (integer) square root of a unsigned int value
// If the square is not an integer then it returns the largest integer N where N*N <= val
// Uses a table of squares that must be initialized by calling init_squares()
// sqrt(word zp($23) val)
sqrt: {
    .label __1 = $12
    .label __2 = $12
    .label found = $12
    .label val = $23
    // unsigned int* found = bsearch16u(val, SQUARES, NUM_SQUARES)
    lda.z SQUARES
    sta.z bsearch16u.items
    lda.z SQUARES+1
    sta.z bsearch16u.items+1
    jsr bsearch16u
    // unsigned int* found = bsearch16u(val, SQUARES, NUM_SQUARES)
    // found-SQUARES
    lda.z __2
    sec
    sbc.z SQUARES
    sta.z __2
    lda.z __2+1
    sbc.z SQUARES+1
    sta.z __2+1
    lsr.z __1+1
    ror.z __1
    // char sq = (char)(found-SQUARES)
    lda.z __1
    // }
    rts
}
// Find the atan2(x, y) - which is the angle of the line from (0,0) to (x,y)
// Finding the angle requires a binary search using CORDIC_ITERATIONS_16
// Returns the angle in hex-degrees (0=0, 0x8000=PI, 0x10000=2*PI)
// atan2_16(signed word zp($21) x, signed word zp($23) y)
atan2_16: {
    .label __2 = $c
    .label __7 = $e
    .label yi = $c
    .label xi = $e
    .label angle = $10
    .label xd = $1a
    .label yd = $12
    .label return = $10
    .label x = $21
    .label y = $23
    // (y>=0)?y:-y
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
    // (x>=0)?x:-x
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
    // if(yi==0)
    lda.z yi+1
    ora.z yi
    bne __b11
  __b12:
    // angle /=2
    lsr.z angle+1
    ror.z angle
    // if(x<0)
    lda.z x+1
    bpl __b7
    // angle = 0x8000-angle
    lda #<$8000
    sec
    sbc.z angle
    sta.z angle
    lda #>$8000
    sbc.z angle+1
    sta.z angle+1
  __b7:
    // if(y<0)
    lda.z y+1
    bpl __b8
    // angle = -angle
    sec
    lda #0
    sbc.z angle
    sta.z angle
    lda #0
    sbc.z angle+1
    sta.z angle+1
  __b8:
    // }
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
    // while(shift>=2)
    cpy #2
    bcs __b14
    // if(shift)
    cpy #0
    beq __b17
    // xd >>= 1
    lda.z xd+1
    cmp #$80
    ror.z xd+1
    ror.z xd
    // yd >>= 1
    lda.z yd+1
    cmp #$80
    ror.z yd+1
    ror.z yd
  __b17:
    // if(yi>=0)
    lda.z yi+1
    bpl __b18
    // xi -= yd
    lda.z xi
    sec
    sbc.z yd
    sta.z xi
    lda.z xi+1
    sbc.z yd+1
    sta.z xi+1
    // yi += xd
    clc
    lda.z yi
    adc.z xd
    sta.z yi
    lda.z yi+1
    adc.z xd+1
    sta.z yi+1
    // angle -= CORDIC_ATAN2_ANGLES_16[i]
    txa
    asl
    tay
    lda.z angle
    sec
    sbc CORDIC_ATAN2_ANGLES_16,y
    sta.z angle
    lda.z angle+1
    sbc CORDIC_ATAN2_ANGLES_16+1,y
    sta.z angle+1
  __b19:
    // for( char i: 0..CORDIC_ITERATIONS_16-1)
    inx
    cpx #CORDIC_ITERATIONS_16-1+1
    bne !__b12+
    jmp __b12
  !__b12:
    jmp __b10
  __b18:
    // xi += yd
    clc
    lda.z xi
    adc.z yd
    sta.z xi
    lda.z xi+1
    adc.z yd+1
    sta.z xi+1
    // yi -= xd
    lda.z yi
    sec
    sbc.z xd
    sta.z yi
    lda.z yi+1
    sbc.z xd+1
    sta.z yi+1
    // angle += CORDIC_ATAN2_ANGLES_16[i]
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
    // xd >>= 2
    lda.z xd+1
    cmp #$80
    ror.z xd+1
    ror.z xd
    lda.z xd+1
    cmp #$80
    ror.z xd+1
    ror.z xd
    // yd >>= 2
    lda.z yd+1
    cmp #$80
    ror.z yd+1
    ror.z yd
    lda.z yd+1
    cmp #$80
    ror.z yd+1
    ror.z yd
    // shift -=2
    dey
    dey
    jmp __b13
  __b4:
    // (x>=0)?x:-x
    lda.z x
    sta.z xi
    lda.z x+1
    sta.z xi+1
    jmp __b6
  __b1:
    // (y>=0)?y:-y
    lda.z y
    sta.z yi
    lda.z y+1
    sta.z yi+1
    jmp __b3
}
// Searches an array of nitems unsigned ints, the initial member of which is pointed to by base, for a member that matches the value key.
// - key - The value to look for
// - items - Pointer to the start of the array to search in
// - num - The number of items in the array
// Returns pointer to an entry in the array that matches the search key
// bsearch16u(word zp($23) key, word* zp($12) items, byte register(X) num)
bsearch16u: {
    .label __2 = $12
    .label pivot = $28
    .label result = $2a
    .label return = $12
    .label items = $12
    .label key = $23
    ldx #NUM_SQUARES
  __b3:
    // while (num > 0)
    cpx #0
    bne __b4
    // *items<=key?items:items-1
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
    sec
    lda.z __2
    sbc #1*SIZEOF_WORD
    sta.z __2
    lda.z __2+1
    sbc #0
    sta.z __2+1
  __b2:
    // }
    rts
  __b4:
    // num >> 1
    txa
    lsr
    // unsigned int* pivot = items + (num >> 1)
    asl
    clc
    adc.z items
    sta.z pivot
    lda #0
    adc.z items+1
    sta.z pivot+1
    // signed int result = (signed int)key-(signed int)*pivot
    sec
    lda.z key
    ldy #0
    sbc (pivot),y
    sta.z result
    lda.z key+1
    iny
    sbc (pivot),y
    sta.z result+1
    // if (result == 0)
    ora.z result
    bne __b6
    lda.z pivot
    sta.z return
    lda.z pivot+1
    sta.z return+1
    rts
  __b6:
    // if (result > 0)
    lda.z result+1
    bmi __b7
    bne !+
    lda.z result
    beq __b7
  !:
    // items = pivot+1
    lda #1*SIZEOF_WORD
    clc
    adc.z pivot
    sta.z items
    lda #0
    adc.z pivot+1
    sta.z items+1
    // num--;
    dex
  __b7:
    // num >>= 1
    txa
    lsr
    tax
    jmp __b3
}
.segment Data
// Angles representing ATAN(0.5), ATAN(0.25), ATAN(0.125), ...
CORDIC_ATAN2_ANGLES_16:
.for (var i=0; i<CORDIC_ITERATIONS_16; i++)
        .word 256*2*256*atan(1/pow(2,i))/PI/2

