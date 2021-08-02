// Calculate the distance to the center of the screen - and show it using font-hex
  // Commodore 64 PRG executable file
.file [name="screen-center-distance.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_WORD = 2
  /// Timer Control - Start/stop timer (0:stop, 1: start)
  .const CIA_TIMER_CONTROL_START = 1
  /// Timer B Control - Timer counts (00:system cycles, 01: CNT pulses, 10: timer A underflow, 11: time A underflow while CNT is high)
  .const CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A = $40
  /// Clock cycles used to start & read the cycle clock by calling clock_start() and clock() once. Can be subtracted when calculating the number of cycles used by a routine.
  /// To make precise cycle measurements interrupts and the display must be disabled so neither steals any cycles from the code.
  .const CLOCKS_PER_INIT = $12
  .const OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL = $e
  .const OFFSET_STRUCT_MOS6526_CIA_TIMER_B_CONTROL = $f
  // The number of squares to pre-calculate. Limits what values sqr() can calculate and the result of sqrt()
  .const NUM_SQUARES = $30
  /// $D018 VIC-II base addresses
  // @see #VICII_MEMORY
  .label D018 = $d018
  /// The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
  /// CIA#2 timer A&B as one single 32-bit value
  .label CIA2_TIMER_AB = $dd04
  .label CHARSET = $2000
  .label SCREEN = $2800
  // Top of the heap used by malloc()
  .label HEAP_TOP = $a000
  // Squares for each char value SQUARES[i] = i*i
  // Initialized by init_squares()
  .label SQUARES = malloc.return
.segment Code
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>CHARSET)/4&$f
    .const toD0182_return = (>(BASE_SCREEN&$3fff)*4)|(>BASE_CHARSET)/4&$f
    .label BASE_SCREEN = $400
    .label BASE_CHARSET = $1000
    .label __4 = $c
    .label cyclecount = $c
    // init_font_hex(CHARSET)
    jsr init_font_hex
    // *D018 = toD018(SCREEN, CHARSET)
    lda #toD0181_return
    sta D018
    // clock_start()
    jsr clock_start
    // init_dist_screen(SCREEN)
    jsr init_dist_screen
    // clock()
    jsr clock
    // clock_t cyclecount = clock()-CLOCKS_PER_INIT
    lda.z cyclecount
    sec
    sbc #<CLOCKS_PER_INIT
    sta.z cyclecount
    lda.z cyclecount+1
    sbc #>CLOCKS_PER_INIT
    sta.z cyclecount+1
    lda.z cyclecount+2
    sbc #<CLOCKS_PER_INIT>>$10
    sta.z cyclecount+2
    lda.z cyclecount+3
    sbc #>CLOCKS_PER_INIT>>$10
    sta.z cyclecount+3
    // print_ulong_at(cyclecount, BASE_SCREEN)
    jsr print_ulong_at
    // *D018 = toD018(BASE_SCREEN, BASE_CHARSET)
    lda #toD0182_return
    sta D018
    // }
    rts
}
// Make charset from proto chars
// init_font_hex(byte* zp(5) charset)
init_font_hex: {
    .label __0 = $10
    .label idx = 9
    .label proto_lo = $a
    .label charset = 5
    .label c1 = 7
    .label proto_hi = 3
    .label c = 2
    lda #0
    sta.z c
    lda #<FONT_HEX_PROTO
    sta.z proto_hi
    lda #>FONT_HEX_PROTO
    sta.z proto_hi+1
    lda #<CHARSET
    sta.z charset
    lda #>CHARSET
    sta.z charset+1
  __b1:
    lda #0
    sta.z c1
    lda #<FONT_HEX_PROTO
    sta.z proto_lo
    lda #>FONT_HEX_PROTO
    sta.z proto_lo+1
  __b2:
    // charset[idx++] = 0
    lda #0
    tay
    sta (charset),y
    lda #1
    sta.z idx
    ldx #0
  __b3:
    // proto_hi[i]<<4
    txa
    tay
    lda (proto_hi),y
    asl
    asl
    asl
    asl
    sta.z __0
    // proto_lo[i]<<1
    txa
    tay
    lda (proto_lo),y
    asl
    // proto_hi[i]<<4 | proto_lo[i]<<1
    ora.z __0
    // charset[idx++] = proto_hi[i]<<4 | proto_lo[i]<<1
    ldy.z idx
    sta (charset),y
    // charset[idx++] = proto_hi[i]<<4 | proto_lo[i]<<1;
    inc.z idx
    // for( byte i: 0..4)
    inx
    cpx #5
    bne __b3
    // charset[idx++] = 0
    lda #0
    ldy.z idx
    sta (charset),y
    // charset[idx++] = 0;
    iny
    // charset[idx++] = 0
    sta (charset),y
    // proto_lo += 5
    lda #5
    clc
    adc.z proto_lo
    sta.z proto_lo
    bcc !+
    inc.z proto_lo+1
  !:
    // charset += 8
    lda #8
    clc
    adc.z charset
    sta.z charset
    bcc !+
    inc.z charset+1
  !:
    // for( byte c: 0..15 )
    inc.z c1
    lda #$10
    cmp.z c1
    bne __b2
    // proto_hi += 5
    lda #5
    clc
    adc.z proto_hi
    sta.z proto_hi
    bcc !+
    inc.z proto_hi+1
  !:
    // for( byte c: 0..15 )
    inc.z c
    lda #$10
    cmp.z c
    bne __b1
    // }
    rts
}
// Reset & start the processor clock time. The value can be read using clock().
// This uses CIA #2 Timer A+B on the C64
clock_start: {
    // CIA2->TIMER_A_CONTROL = CIA_TIMER_CONTROL_STOP | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_A_COUNT_CYCLES
    // Setup CIA#2 timer A to count (down) CPU cycles
    lda #0
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL
    // CIA2->TIMER_B_CONTROL = CIA_TIMER_CONTROL_STOP | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    lda #CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_TIMER_B_CONTROL
    // *CIA2_TIMER_AB = 0xffffffff
    lda #<$ffffffff
    sta CIA2_TIMER_AB
    lda #>$ffffffff
    sta CIA2_TIMER_AB+1
    lda #<$ffffffff>>$10
    sta CIA2_TIMER_AB+2
    lda #>$ffffffff>>$10
    sta CIA2_TIMER_AB+3
    // CIA2->TIMER_B_CONTROL = CIA_TIMER_CONTROL_START | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    lda #CIA_TIMER_CONTROL_START|CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_TIMER_B_CONTROL
    // CIA2->TIMER_A_CONTROL = CIA_TIMER_CONTROL_START | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_A_COUNT_CYCLES
    lda #CIA_TIMER_CONTROL_START
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL
    // }
    rts
}
// Populates 1000 bytes (a screen) with values representing the distance to the center.
// The actual value stored is distance*2 to increase precision
init_dist_screen: {
    .label yds = $11
    .label screen_topline = 3
    .label screen_bottomline = 5
    .label y = 2
    .label xds = $13
    .label ds = $13
    .label x = 7
    .label xb = 9
    // init_squares()
    jsr init_squares
    lda #<SCREEN+$28*$18
    sta.z screen_bottomline
    lda #>SCREEN+$28*$18
    sta.z screen_bottomline+1
    lda #<SCREEN
    sta.z screen_topline
    lda #>SCREEN
    sta.z screen_topline+1
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
// Returns the processor clock time used since the beginning of an implementation defined era (normally the beginning of the program).
// This uses CIA #2 Timer A+B on the C64, and must be initialized using clock_start()
clock: {
    .label return = $c
    // CIA2->TIMER_A_CONTROL = CIA_TIMER_CONTROL_STOP | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_A_COUNT_CYCLES
    // Stop the timer
    lda #0
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL
    // clock_t ticks = 0xffffffff - *CIA2_TIMER_AB
    lda #<$ffffffff
    sec
    sbc CIA2_TIMER_AB
    sta.z return
    lda #>$ffffffff
    sbc CIA2_TIMER_AB+1
    sta.z return+1
    lda #<$ffffffff>>$10
    sbc CIA2_TIMER_AB+2
    sta.z return+2
    lda #>$ffffffff>>$10
    sbc CIA2_TIMER_AB+3
    sta.z return+3
    // CIA2->TIMER_A_CONTROL = CIA_TIMER_CONTROL_START | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_A_COUNT_CYCLES
    // Start the timer
    lda #CIA_TIMER_CONTROL_START
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL
    // }
    rts
}
// Print a unsigned long as HEX at a specific position
// print_ulong_at(dword zp($c) dw)
print_ulong_at: {
    .label dw = $c
    // print_uint_at(WORD1(dw), at)
    lda.z dw+2
    sta.z print_uint_at.w
    lda.z dw+3
    sta.z print_uint_at.w+1
    lda #<main.BASE_SCREEN
    sta.z print_uint_at.at
    lda #>main.BASE_SCREEN
    sta.z print_uint_at.at+1
    jsr print_uint_at
    // print_uint_at(WORD0(dw), at+4)
    lda.z dw
    sta.z print_uint_at.w
    lda.z dw+1
    sta.z print_uint_at.w+1
    lda #<main.BASE_SCREEN+4
    sta.z print_uint_at.at
    lda #>main.BASE_SCREEN+4
    sta.z print_uint_at.at+1
    jsr print_uint_at
    // }
    rts
}
// Initialize squares table
// Uses iterative formula (x+1)^2 = x^2 + 2*x + 1
init_squares: {
    .label squares = $13
    .label sqr = $a
    // malloc(NUM_SQUARES*sizeof(unsigned int))
    jsr malloc
    lda #<SQUARES
    sta.z squares
    lda #>SQUARES
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
    .label return = $13
    .label return_1 = $11
    // return SQUARES[val];
    asl
    tay
    lda SQUARES,y
    sta.z return
    lda SQUARES+1,y
    sta.z return+1
    // }
    rts
}
// Find the (integer) square root of a unsigned int value
// If the square is not an integer then it returns the largest integer N where N*N <= val
// Uses a table of squares that must be initialized by calling init_squares()
// sqrt(word zp($13) val)
sqrt: {
    .label __1 = $a
    .label __2 = $a
    .label found = $a
    .label val = $13
    // unsigned int* found = bsearch16u(val, SQUARES, NUM_SQUARES)
    jsr bsearch16u
    // unsigned int* found = bsearch16u(val, SQUARES, NUM_SQUARES)
    // found-SQUARES
    lda.z __2
    sec
    sbc #<SQUARES
    sta.z __2
    lda.z __2+1
    sbc #>SQUARES
    sta.z __2+1
    lsr.z __1+1
    ror.z __1
    // char sq = (char)(found-SQUARES)
    lda.z __1
    // }
    rts
}
// Print a unsigned int as HEX at a specific position
// print_uint_at(word zp($13) w, byte* zp($a) at)
print_uint_at: {
    .label w = $13
    .label at = $a
    // print_uchar_at(BYTE1(w), at)
    lda.z w+1
    sta.z print_uchar_at.b
    jsr print_uchar_at
    // print_uchar_at(BYTE0(w), at+2)
    lda.z w
    sta.z print_uchar_at.b
    lda #2
    clc
    adc.z print_uchar_at.at
    sta.z print_uchar_at.at
    bcc !+
    inc.z print_uchar_at.at+1
  !:
    jsr print_uchar_at
    // }
    rts
}
// Allocates a block of size chars of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
malloc: {
    .const size = NUM_SQUARES*SIZEOF_WORD
    .label mem = HEAP_TOP-size
    .label return = mem
    rts
}
// Searches an array of nitems unsigned ints, the initial member of which is pointed to by base, for a member that matches the value key.
// - key - The value to look for
// - items - Pointer to the start of the array to search in
// - num - The number of items in the array
// Returns pointer to an entry in the array that matches the search key
// bsearch16u(word zp($13) key, word* zp($a) items, byte register(X) num)
bsearch16u: {
    .label __2 = $a
    .label pivot = $15
    .label result = $17
    .label return = $a
    .label items = $a
    .label key = $13
    lda #<SQUARES
    sta.z items
    lda #>SQUARES
    sta.z items+1
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
// Print a char as HEX at a specific position
// print_uchar_at(byte zp($10) b, byte* zp($a) at)
print_uchar_at: {
    .label b = $10
    .label at = $a
    // b>>4
    lda.z b
    lsr
    lsr
    lsr
    lsr
    // print_char_at(print_hextab[b>>4], at)
    tay
    ldx print_hextab,y
    lda.z at
    sta.z print_char_at.at
    lda.z at+1
    sta.z print_char_at.at+1
  // Table of hexadecimal digits
    jsr print_char_at
    // b&$f
    lda #$f
    and.z b
    tay
    // print_char_at(print_hextab[b&$f], at+1)
    clc
    lda.z at
    adc #1
    sta.z print_char_at.at
    lda.z at+1
    adc #0
    sta.z print_char_at.at+1
    ldx print_hextab,y
    jsr print_char_at
    // }
    rts
}
// Print a single char
// print_char_at(byte register(X) ch, byte* zp($11) at)
print_char_at: {
    .label at = $11
    // *(at) = ch
    txa
    ldy #0
    sta (at),y
    // }
    rts
}
.segment Data
  // Bit patterns for symbols 0-f (3x5 pixels) used in font hex
  FONT_HEX_PROTO: .byte 2, 5, 5, 5, 2, 6, 2, 2, 2, 7, 6, 1, 2, 4, 7, 6, 1, 2, 1, 6, 5, 5, 7, 1, 1, 7, 4, 6, 1, 6, 3, 4, 6, 5, 2, 7, 1, 1, 1, 1, 2, 5, 2, 5, 2, 2, 5, 3, 1, 1, 2, 5, 7, 5, 5, 6, 5, 6, 5, 6, 2, 5, 4, 5, 2, 6, 5, 5, 5, 6, 7, 4, 6, 4, 7, 7, 4, 6, 4, 4
  print_hextab: .text "0123456789abcdef"
