// Calculate the distance to the center of the screen - and show it using font-hex
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
  // Start of the heap used by malloc()
  .label HEAP_START = $c000
  .label D018 = $d018
  .label CHARSET = $2000
  .label SCREEN = $2800
  .const NUM_SQUARES = $30
  .label SQUARES = malloc.return
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>CHARSET)/4&$f
    .label yds = $1c
    .label xds = $1e
    .label ds = $1e
    .label screen = $b
    .label x = 3
    .label screen_mirror1 = 4
    .label y = 2
    .label screen_mirror = 9
    .label y1 = 6
    jsr init_font_hex
    lda #toD0181_return
    sta D018
    jsr init_squares
    lda #<SCREEN
    sta screen
    lda #>SCREEN
    sta screen+1
    lda #0
    sta y
  b1:
    lda y
    asl
    cmp #$18
    bcc !b2+
    jmp b2
  !b2:
    eor #$ff
    clc
    adc #$18+1
  b4:
    jsr sqr
    lda sqr.return
    sta sqr.return_2
    lda sqr.return+1
    sta sqr.return_2+1
    lda #0
    sta x
  b5:
    lda x
    asl
    cmp #$27
    bcc !b6+
    jmp b6
  !b6:
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
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inc x
    lda #$14
    cmp x
    bne b5
    lda screen
    sta screen_mirror1
    lda screen+1
    sta screen_mirror1+1
    ldx #0
  b10:
    lda screen_mirror1
    bne !+
    dec screen_mirror1+1
  !:
    dec screen_mirror1
    ldy #0
    lda (screen_mirror1),y
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inx
    cpx #$14
    bne b10
    inc y
    lda #$d
    cmp y
    beq !b1+
    jmp b1
  !b1:
    lda screen
    sec
    sbc #<$28
    sta screen_mirror
    lda screen+1
    sbc #>$28
    sta screen_mirror+1
    lda #0
    sta y1
  b13:
    ldx #0
  b14:
    lda screen_mirror
    bne !+
    dec screen_mirror+1
  !:
    dec screen_mirror
    ldy #0
    lda (screen_mirror),y
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inx
    cpx #$28
    bne b14
    inc y1
    lda #$c
    cmp y1
    bne b13
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
// sqrt(word zeropage($1e) val)
sqrt: {
    .label _1 = $d
    .label _3 = $d
    .label found = $d
    .label val = $1e
    jsr bsearch16u
    lda _3
    sec
    sbc #<SQUARES
    sta _3
    lda _3+1
    sbc #>SQUARES
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
// bsearch16u(word zeropage($1e) key, word* zeropage($d) items, byte register(X) num)
bsearch16u: {
    .label _2 = $d
    .label pivot = $20
    .label result = $22
    .label return = $d
    .label items = $d
    .label key = $1e
    lda #<SQUARES
    sta items
    lda #>SQUARES
    sta items+1
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
    .label return = $1e
    .label return_2 = $1c
    asl
    tay
    lda SQUARES,y
    sta return
    lda SQUARES+1,y
    sta return+1
    rts
}
// Initialize squares table
// Uses iterative formula (x+1)^2 = x^2 + 2*x + 1
init_squares: {
    .label squares = $11
    .label sqr = $f
    jsr malloc
    ldx #0
    lda #<SQUARES
    sta squares
    lda #>SQUARES
    sta squares+1
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
malloc: {
    .label return = HEAP_START
    rts
}
// Make charset from proto chars
// init_font_hex(byte* zeropage($16) charset)
init_font_hex: {
    .label _0 = $24
    .label idx = $1b
    .label proto_lo = $18
    .label charset = $16
    .label c1 = $1a
    .label proto_hi = $13
    .label c = $15
    lda #0
    sta c
    lda #<FONT_HEX_PROTO
    sta proto_hi
    lda #>FONT_HEX_PROTO
    sta proto_hi+1
    lda #<CHARSET
    sta charset
    lda #>CHARSET
    sta charset+1
  b1:
    lda #0
    sta c1
    lda #<FONT_HEX_PROTO
    sta proto_lo
    lda #>FONT_HEX_PROTO
    sta proto_lo+1
  b2:
    lda #0
    tay
    sta (charset),y
    lda #1
    sta idx
    ldx #0
  b3:
    txa
    tay
    lda (proto_hi),y
    asl
    asl
    asl
    asl
    sta _0
    txa
    tay
    lda (proto_lo),y
    asl
    ora _0
    ldy idx
    sta (charset),y
    inc idx
    inx
    cpx #5
    bne b3
    lda #0
    ldy idx
    sta (charset),y
    iny
    sta (charset),y
    lda #5
    clc
    adc proto_lo
    sta proto_lo
    bcc !+
    inc proto_lo+1
  !:
    lda #8
    clc
    adc charset
    sta charset
    bcc !+
    inc charset+1
  !:
    inc c1
    lda #$10
    cmp c1
    bne b2
    lda #5
    clc
    adc proto_hi
    sta proto_hi
    bcc !+
    inc proto_hi+1
  !:
    inc c
    lda #$10
    cmp c
    bne b1
    rts
}
  // Bit patterns for symbols 0-f (3x5 pixels) used in font hex
  FONT_HEX_PROTO: .byte 2, 5, 5, 5, 2, 6, 2, 2, 2, 7, 6, 1, 2, 4, 7, 6, 1, 2, 1, 6, 5, 5, 7, 1, 1, 7, 4, 6, 1, 6, 3, 4, 6, 5, 2, 7, 1, 1, 1, 1, 2, 5, 2, 5, 2, 2, 5, 3, 1, 1, 2, 5, 7, 5, 5, 6, 5, 6, 5, 6, 2, 5, 4, 5, 2, 6, 5, 5, 5, 6, 7, 4, 6, 4, 7, 7, 4, 6, 4, 4
