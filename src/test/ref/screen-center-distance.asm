// Calculate the distance to the center of the screen - and show it using font-hex
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
  // Top of the heap used by malloc()
  .label HEAP_TOP = $a000
  .label D018 = $d018
  // CIA #2 Timer A+B Value (32-bit)
  .label CIA2_TIMER_AB = $dd04
  // CIA #2 Timer A Control Register
  .label CIA2_TIMER_A_CONTROL = $dd0e
  // CIA #2 Timer B Control Register
  .label CIA2_TIMER_B_CONTROL = $dd0f
  // Timer Control - Start/stop timer (0:stop, 1: start)
  .const CIA_TIMER_CONTROL_START = 1
  // Timer Control - Time CONTINUOUS/ONE-SHOT (0:CONTINUOUS, 1: ONE-SHOT)
  .const CIA_TIMER_CONTROL_CONTINUOUS = 0
  // Timer B Control - Timer counts (00:system cycles, 01: CNT pulses, 10: timer A underflow, 11: time A underflow while CNT is high)
  .const CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A = $40
  // Clock cycles used to start & read the cycle clock by calling clock_start() and clock() once. Can be subtracted when calculating the number of cycles used by a routine.
  // To make precise cycle measurements interrupts and the display must be disabled so neither steals any cycles from the code.
  .const CLOCKS_PER_INIT = $12
  .label CHARSET = $2000
  .label SCREEN = $2800
  .const NUM_SQUARES = $30
  .label SQUARES = malloc.return
main: {
    .label BASE_SCREEN = $400
    .label BASE_CHARSET = $1000
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>CHARSET)/4&$f
    .const toD0182_return = (>(BASE_SCREEN&$3fff)*4)|(>BASE_CHARSET)/4&$f
    .label _4 = $e
    .label cyclecount = $e
    jsr init_font_hex
    lda #toD0181_return
    sta D018
    jsr clock_start
    jsr init_dist_screen
    jsr clock
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
    jsr print_dword_at
    lda #toD0182_return
    sta D018
    rts
}
// Print a dword as HEX at a specific position
// print_dword_at(dword zeropage($e) dw)
print_dword_at: {
    .label dw = $e
    lda.z dw+2
    sta.z print_word_at.w
    lda.z dw+3
    sta.z print_word_at.w+1
    lda #<main.BASE_SCREEN
    sta.z print_word_at.at
    lda #>main.BASE_SCREEN
    sta.z print_word_at.at+1
    jsr print_word_at
    lda.z dw
    sta.z print_word_at.w
    lda.z dw+1
    sta.z print_word_at.w+1
    lda #<main.BASE_SCREEN+4
    sta.z print_word_at.at
    lda #>main.BASE_SCREEN+4
    sta.z print_word_at.at+1
    jsr print_word_at
    rts
}
// Print a word as HEX at a specific position
// print_word_at(word zeropage(9) w, byte* zeropage(2) at)
print_word_at: {
    .label w = 9
    .label at = 2
    lda.z w+1
    sta.z print_byte_at.b
    jsr print_byte_at
    lda.z w
    sta.z print_byte_at.b
    lda.z print_byte_at.at
    clc
    adc #2
    sta.z print_byte_at.at
    bcc !+
    inc.z print_byte_at.at+1
  !:
    jsr print_byte_at
    rts
}
// Print a byte as HEX at a specific position
// print_byte_at(byte zeropage($d) b, byte* zeropage(2) at)
print_byte_at: {
    .label b = $d
    .label at = 2
    lda.z b
    lsr
    lsr
    lsr
    lsr
    tay
    ldx print_hextab,y
    lda.z at
    sta.z print_char_at.at
    lda.z at+1
    sta.z print_char_at.at+1
    jsr print_char_at
    lda #$f
    and.z b
    tay
    lda.z at
    clc
    adc #1
    sta.z print_char_at.at
    lda.z at+1
    adc #0
    sta.z print_char_at.at+1
    ldx print_hextab,y
    jsr print_char_at
    rts
}
// Print a single char
// print_char_at(byte register(X) ch, byte* zeropage(4) at)
print_char_at: {
    .label at = 4
    txa
    ldy #0
    sta (at),y
    rts
}
// Returns the processor clock time used since the beginning of an implementation defined era (normally the beginning of the program).
// This uses CIA #2 Timer A+B on the C64, and must be initialized using clock_start()
clock: {
    .label return = $e
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
    rts
}
// Populates 1000 bytes (a screen) with values representing the distance to the center.
// The actual value stored is distance*2 to increase precision
init_dist_screen: {
    .label yds = $12
    .label screen_topline = 9
    .label screen_bottomline = 2
    .label y = $d
    .label xds = $14
    .label ds = $14
    .label x = $b
    .label xb = $c
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
// sqrt(word zeropage($14) val)
sqrt: {
    .label _1 = 6
    .label _3 = 6
    .label found = 6
    .label val = $14
    jsr bsearch16u
    lda.z _3
    sec
    sbc #<SQUARES
    sta.z _3
    lda.z _3+1
    sbc #>SQUARES
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
// bsearch16u(word zeropage($14) key, word* zeropage(6) items, byte register(X) num)
bsearch16u: {
    .label _2 = 6
    .label pivot = 6
    .label result = $16
    .label return = 6
    .label items = 6
    .label key = $14
    .label items_10 = 4
    .label items_16 = 4
    lda #<SQUARES
    sta.z items_10
    lda #>SQUARES
    sta.z items_10+1
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
    .label return = $14
    .label return_2 = $12
    asl
    tay
    lda SQUARES,y
    sta.z return
    lda SQUARES+1,y
    sta.z return+1
    rts
}
// Initialize squares table
// Uses iterative formula (x+1)^2 = x^2 + 2*x + 1
init_squares: {
    .label squares = 9
    .label sqr = 6
    jsr malloc
    ldx #0
    lda #<SQUARES
    sta.z squares
    lda #>SQUARES
    sta.z squares+1
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
// Allocates a block of size bytes of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
malloc: {
    .const size = NUM_SQUARES*SIZEOF_WORD
    .label mem = HEAP_TOP-size
    .label return = mem
    rts
}
// Reset & start the processor clock time. The value can be read using clock().
// This uses CIA #2 Timer A+B on the C64
clock_start: {
    // Setup CIA#2 timer A to count (down) CPU cycles
    lda #CIA_TIMER_CONTROL_CONTINUOUS
    sta CIA2_TIMER_A_CONTROL
    lda #CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    sta CIA2_TIMER_B_CONTROL
    lda #<$ffffffff
    sta CIA2_TIMER_AB
    lda #>$ffffffff
    sta CIA2_TIMER_AB+1
    lda #<$ffffffff>>$10
    sta CIA2_TIMER_AB+2
    lda #>$ffffffff>>$10
    sta CIA2_TIMER_AB+3
    lda #CIA_TIMER_CONTROL_START|CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    sta CIA2_TIMER_B_CONTROL
    lda #CIA_TIMER_CONTROL_START
    sta CIA2_TIMER_A_CONTROL
    rts
}
// Make charset from proto chars
// init_font_hex(byte* zeropage($12) charset)
init_font_hex: {
    .label _0 = $18
    .label idx = $d
    .label proto_lo = $14
    .label charset = $12
    .label c1 = $c
    .label proto_hi = 9
    .label c = $b
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
  b1:
    lda #0
    sta.z c1
    lda #<FONT_HEX_PROTO
    sta.z proto_lo
    lda #>FONT_HEX_PROTO
    sta.z proto_lo+1
  b2:
    lda #0
    tay
    sta (charset),y
    lda #1
    sta.z idx
    ldx #0
  b3:
    txa
    tay
    lda (proto_hi),y
    asl
    asl
    asl
    asl
    sta.z _0
    txa
    tay
    lda (proto_lo),y
    asl
    ora.z _0
    ldy.z idx
    sta (charset),y
    inc.z idx
    inx
    cpx #5
    bne b3
    lda #0
    ldy.z idx
    sta (charset),y
    iny
    sta (charset),y
    lda #5
    clc
    adc.z proto_lo
    sta.z proto_lo
    bcc !+
    inc.z proto_lo+1
  !:
    lda #8
    clc
    adc.z charset
    sta.z charset
    bcc !+
    inc.z charset+1
  !:
    inc.z c1
    lda #$10
    cmp.z c1
    bne b2
    lda #5
    clc
    adc.z proto_hi
    sta.z proto_hi
    bcc !+
    inc.z proto_hi+1
  !:
    inc.z c
    lda #$10
    cmp.z c
    bne b1
    rts
}
  // Bit patterns for symbols 0-f (3x5 pixels) used in font hex
  FONT_HEX_PROTO: .byte 2, 5, 5, 5, 2, 6, 2, 2, 2, 7, 6, 1, 2, 4, 7, 6, 1, 2, 1, 6, 5, 5, 7, 1, 1, 7, 4, 6, 1, 6, 3, 4, 6, 5, 2, 7, 1, 1, 1, 1, 2, 5, 2, 5, 2, 2, 5, 3, 1, 1, 2, 5, 7, 5, 5, 6, 5, 6, 5, 6, 2, 5, 4, 5, 2, 6, 5, 5, 5, 6, 7, 4, 6, 4, 7, 7, 4, 6, 4, 4
  print_hextab: .text "0123456789abcdef"
