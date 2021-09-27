// Fill screen using a spiral based on distance-to-center / angle-to-center
  // Commodore 64 PRG executable file
.file [name="screen-show-spiral.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const SIZEOF_UNSIGNED_INT = 2
  // The number of iterations performed during 16-bit CORDIC atan2 calculation
  .const CORDIC_ITERATIONS_16 = $f
  // Char to fill with
  .const FILL_CHAR = '@'
  // The number of squares to pre-calculate. Limits what values sqr() can calculate and the result of sqrt()
  .const NUM_SQUARES = $30
  // Screen containing angle to center
  .label SCREEN_FILL = $400
  // Top of the heap used by malloc()
  .label HEAP_TOP = $a000
  // Head of the heap. Moved backward each malloc()
  .label heap_head = $14
  // Squares for each char value SQUARES[i] = i*i
  // Initialized by init_squares()
  .label SQUARES = $12
  // Screen containing distance to center
  .label SCREEN_DIST = $26
  // Screen containing angle to center
  .label SCREEN_ANGLE = $24
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
    // byte* SCREEN_ANGLE = malloc(1000)
    lda #<$3e8
    sta.z malloc.size
    lda #>$3e8
    sta.z malloc.size+1
    jsr malloc
    // byte* SCREEN_ANGLE = malloc(1000)
    lda.z malloc.mem
    sta.z SCREEN_ANGLE
    lda.z malloc.mem+1
    sta.z SCREEN_ANGLE+1
    jsr main
    rts
}
// Allocates a block of size chars of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
// void * malloc(__zp($12) unsigned int size)
malloc: {
    .label mem = $12
    .label size = $12
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
    .label dist = $12
    .label angle = $22
    .label fill = $14
    .label dist_angle = $17
    .label min_dist_angle = $1e
    .label min_dist_angle_1 = $17
    .label min_fill = $1c
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
  __b1:
    // byte* dist = SCREEN_DIST
    // Find the minimum dist/angle that is not already filled
    lda.z SCREEN_DIST
    sta.z dist
    lda.z SCREEN_DIST+1
    sta.z dist+1
    // byte* angle = SCREEN_ANGLE
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
    // if(*fill!=FILL_CHAR)
    lda #FILL_CHAR
    ldy #0
    cmp (fill),y
    beq __b10
    // word dist_angle = MAKEWORD( *dist, *angle )
    lda (angle),y
    sta.z dist_angle
    lda (dist),y
    sta.z dist_angle+1
    // if(dist_angle<min_dist_angle)
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
    // dist++;
    inc.z dist
    bne !+
    inc.z dist+1
  !:
    // angle++;
    inc.z angle
    bne !+
    inc.z angle+1
  !:
    // fill++;
    inc.z fill
    bne !+
    inc.z fill+1
  !:
    // while (fill<SCREEN_FILL+1000)
    lda.z fill+1
    cmp #>SCREEN_FILL+$3e8
    bcc __b9
    bne !+
    lda.z fill
    cmp #<SCREEN_FILL+$3e8
    bcc __b9
  !:
    // if(min_dist_angle==0xffff)
    lda.z min_dist_angle_1+1
    cmp #>$ffff
    bne __b7
    lda.z min_dist_angle_1
    cmp #<$ffff
    bne __b7
    // }
    rts
  __b7:
    // *min_fill = FILL_CHAR
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
// Populates 1000 bytes (a screen) with values representing the distance to the center.
// The actual value stored is distance*2 to increase precision
// void init_dist_screen(__zp($20) char *screen)
init_dist_screen: {
    .label screen = $20
    .label screen_bottomline = $1a
    .label yds = 4
    .label screen_topline = $20
    .label y = $19
    .label xds = 6
    .label ds = 6
    .label x = $11
    .label xb = $10
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
// Utilizes symmetry around the  center
// void init_angle_screen(__zp($1a) char *screen)
init_angle_screen: {
    .label __9 = 2
    .label screen = $1a
    .label screen_bottomline = $1a
    .label xw = $a
    .label yw = 8
    .label angle_w = 2
    .label ang_w = $16
    .label x = $11
    .label xb = $10
    .label screen_topline = $20
    .label y = $19
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
// Initialize squares table
// Uses iterative formula (x+1)^2 = x^2 + 2*x + 1
init_squares: {
    .label squares = $e
    .label sqr = $c
    // malloc(NUM_SQUARES*sizeof(unsigned int))
    lda #<NUM_SQUARES*SIZEOF_UNSIGNED_INT
    sta.z malloc.size
    lda #>NUM_SQUARES*SIZEOF_UNSIGNED_INT
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
    lda #SIZEOF_UNSIGNED_INT
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
// __zp(6) unsigned int sqr(__register(A) char val)
sqr: {
    .label return = 6
    .label return_1 = 4
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
// __register(A) char sqrt(__zp(6) unsigned int val)
sqrt: {
    .label __1 = 2
    .label __2 = 2
    .label found = 2
    .label val = 6
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
// __zp(2) unsigned int atan2_16(__zp($a) int x, __zp(8) int y)
atan2_16: {
    .label __2 = $c
    .label __7 = $e
    .label yi = $c
    .label xi = $e
    .label angle = 2
    .label xd = 6
    .label yd = 4
    .label return = 2
    .label x = $a
    .label y = 8
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
// __zp(2) unsigned int * bsearch16u(__zp(6) unsigned int key, __zp(2) unsigned int *items, __register(X) char num)
bsearch16u: {
    .label __2 = 2
    .label pivot = $a
    .label result = 8
    .label return = 2
    .label items = 2
    .label key = 6
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
    sbc #1*SIZEOF_UNSIGNED_INT
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
    lda #1*SIZEOF_UNSIGNED_INT
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

