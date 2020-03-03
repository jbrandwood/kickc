// Plasma based on the distance/angle to the screen center
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label D018 = $d018
  // Color Ram
  .label COLS = $d800
  // The colors of the C64
  .const BLACK = 0
  .const SIZEOF_WORD = 2
  // The number of iterations performed during 16-bit CORDIC atan2 calculation
  .const CORDIC_ITERATIONS_16 = $f
  // SID registers for random number generation
  .label SID_VOICE3_FREQ = $d40e
  .label SID_VOICE3_CONTROL = $d412
  .const SID_CONTROL_NOISE = $80
  .label SID_VOICE3_OSC = $d41b
  // Plasma charset
  .label CHARSET = $2000
  // Plasma screen 1
  .label SCREEN1 = $2800
  // Plasma screen 2
  .label SCREEN2 = $2c00
  // Top of the heap used by malloc()
  .label HEAP_TOP = $a000
  .label print_line_cursor = $400
  // The number of squares to pre-calculate. Limits what values sqr() can calculate and the result of sqrt()
  .const NUM_SQUARES = $30
  // Head of the heap. Moved backward each malloc()
  .label heap_head = $18
  // Squares for each byte value SQUARES[i] = i*i
  // Initialized by init_squares()
  .label SQUARES = 9
  .label print_char_cursor = 7
  .label SCREEN_DIST = $b
  .label SCREEN_ANGLE = $d
  // Offsets for the sines
  .label sin_offset_x = 2
  .label sin_offset_y = $f
__bbegin:
  // malloc(1000)
  lda #<$3e8
  sta.z malloc.size
  lda #>$3e8
  sta.z malloc.size+1
  lda #<HEAP_TOP
  sta.z heap_head
  lda #>HEAP_TOP
  sta.z heap_head+1
  jsr malloc
  // malloc(1000)
  lda.z malloc.mem
  sta.z SCREEN_DIST
  lda.z malloc.mem+1
  sta.z SCREEN_DIST+1
  lda #<$3e8
  sta.z malloc.size
  lda #>$3e8
  sta.z malloc.size+1
  jsr malloc
  // malloc(1000)
  lda.z malloc.mem
  sta.z SCREEN_ANGLE
  lda.z malloc.mem+1
  sta.z SCREEN_ANGLE+1
  jsr main
  rts
main: {
    .const toD0181_return = (>(SCREEN1&$3fff)*4)|(>CHARSET)/4&$f
    .const toD0182_return = (>(SCREEN2&$3fff)*4)|(>CHARSET)/4&$f
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
    // make_plasma_charset(CHARSET)
    jsr make_plasma_charset
    // memset(COLS, BLACK, 1000)
    ldx #BLACK
    lda #<COLS
    sta.z memset.str
    lda #>COLS
    sta.z memset.str+1
    jsr memset
    lda #0
    sta.z sin_offset_y
    sta.z sin_offset_x
  // Show double-buffered plasma
  __b2:
    // doplasma(SCREEN1)
    lda #<SCREEN1
    sta.z doplasma.screen
    lda #>SCREEN1
    sta.z doplasma.screen+1
    jsr doplasma
    // *D018 = toD018(SCREEN1, CHARSET)
    lda #toD0181_return
    sta D018
    // doplasma(SCREEN2)
    lda #<SCREEN2
    sta.z doplasma.screen
    lda #>SCREEN2
    sta.z doplasma.screen+1
    jsr doplasma
    // *D018 = toD018(SCREEN2, CHARSET)
    lda #toD0182_return
    sta D018
    jmp __b2
}
// Render plasma to the passed screen
// doplasma(byte* zp(7) screen)
doplasma: {
    .label angle = 3
    .label dist = 5
    .label sin_x = $1a
    .label sin_y = $10
    .label screen = 7
    .label y = $12
    // angle = SCREEN_ANGLE
    lda.z SCREEN_ANGLE
    sta.z angle
    lda.z SCREEN_ANGLE+1
    sta.z angle+1
    // dist = SCREEN_DIST
    lda.z SCREEN_DIST
    sta.z dist
    lda.z SCREEN_DIST+1
    sta.z dist+1
    // sin_x = SINTABLE+sin_offset_x
    lda.z sin_offset_x
    clc
    adc #<SINTABLE
    sta.z sin_x
    lda #>SINTABLE
    adc #0
    sta.z sin_x+1
    // sin_y = SINTABLE+sin_offset_y
    lda.z sin_offset_y
    clc
    adc #<SINTABLE
    sta.z sin_y
    lda #>SINTABLE
    adc #0
    sta.z sin_y+1
    lda #0
    sta.z y
  __b1:
    ldx #0
  __b2:
    // sin_x[angle[x]] + sin_y[dist[x]]
    txa
    tay
    lda (dist),y
    sta.z $ff
    lda (angle),y
    tay
    lda (sin_x),y
    ldy.z $ff
    clc
    adc (sin_y),y
    // screen[x] = sin_x[angle[x]] + sin_y[dist[x]]
    stx.z $ff
    ldy.z $ff
    sta (screen),y
    // for( char x: 0..39)
    inx
    cpx #$28
    bne __b2
    // screen += 40
    lda #$28
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    // angle += 40
    lda #$28
    clc
    adc.z angle
    sta.z angle
    bcc !+
    inc.z angle+1
  !:
    // dist += 40
    lda #$28
    clc
    adc.z dist
    sta.z dist
    bcc !+
    inc.z dist+1
  !:
    // for( char y: 0..25)
    inc.z y
    lda #$1a
    cmp.z y
    bne __b1
    // sin_offset_x -= 3
    lax.z sin_offset_x
    axs #3
    stx.z sin_offset_x
    // sin_offset_y -= 7
    lax.z sin_offset_y
    axs #7
    stx.z sin_offset_y
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp(3) str, byte register(X) c)
memset: {
    .label end = $1a
    .label dst = 3
    .label str = 3
    // end = (char*)str + num
    lda.z str
    clc
    adc #<$3e8
    sta.z end
    lda.z str+1
    adc #>$3e8
    sta.z end+1
  __b2:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
    // }
    rts
  __b3:
    // *dst = c
    txa
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
// Make a plasma-friendly charset where the chars are randomly filled
make_plasma_charset: {
    .label __7 = $12
    .label __10 = $10
    .label __11 = $10
    .label s = $f
    .label i = 2
    .label c = 5
    .label __16 = $10
    // sid_rnd_init()
    jsr sid_rnd_init
    // print_cls()
    jsr print_cls
    lda #<print_line_cursor
    sta.z print_char_cursor
    lda #>print_line_cursor
    sta.z print_char_cursor+1
    lda #<0
    sta.z c
    sta.z c+1
  __b1:
    // for (unsigned int c = 0; c < 0x100; ++c)
    lda.z c+1
    cmp #>$100
    bcc __b2
    bne !+
    lda.z c
    cmp #<$100
    bcc __b2
  !:
    // }
    rts
  __b2:
    // <c
    lda.z c
    // s = SINTABLE[<c]
    tay
    lda SINTABLE,y
    sta.z s
    lda #0
    sta.z i
  __b3:
    // for ( char i = 0; i < 8; ++i)
    lda.z i
    cmp #8
    bcc b1
    // c & 0x07
    lda #7
    and.z c
    // if ((c & 0x07) == 0)
    cmp #0
    bne __b11
    // print_char('.')
    jsr print_char
  __b11:
    // for (unsigned int c = 0; c < 0x100; ++c)
    inc.z c
    bne !+
    inc.z c+1
  !:
    jmp __b1
  b1:
    ldy #0
    ldx #0
  __b5:
    // for (char ii = 0; ii < 8; ++ii)
    cpx #8
    bcc __b6
    // c*8
    lda.z c
    asl
    sta.z __10
    lda.z c+1
    rol
    sta.z __10+1
    asl.z __10
    rol.z __10+1
    asl.z __10
    rol.z __10+1
    // (c*8) + i
    lda.z i
    clc
    adc.z __11
    sta.z __11
    bcc !+
    inc.z __11+1
  !:
    // charset[(c*8) + i] = b
    clc
    lda.z __16
    adc #<CHARSET
    sta.z __16
    lda.z __16+1
    adc #>CHARSET
    sta.z __16+1
    tya
    ldy #0
    sta (__16),y
    // for ( char i = 0; i < 8; ++i)
    inc.z i
    jmp __b3
  __b6:
    // sid_rnd()
    jsr sid_rnd
    // sid_rnd() & 0xFF
    and #$ff
    sta.z __7
    // if ((sid_rnd() & 0xFF) > s)
    lda.z s
    cmp.z __7
    bcs __b8
    // b |= bittab[ii]
    tya
    ora bittab,x
    tay
  __b8:
    // for (char ii = 0; ii < 8; ++ii)
    inx
    jmp __b5
    bittab: .byte 1, 2, 4, 8, $10, $20, $40, $80
}
// Get a random number from the SID voice 3,
// Must be initialized with sid_rnd_init()
sid_rnd: {
    // return *SID_VOICE3_OSC;
    lda SID_VOICE3_OSC
    // }
    rts
}
// Print a single char
print_char: {
    .const ch = '.'
    // *(print_char_cursor++) = ch
    lda #ch
    ldy #0
    sta (print_char_cursor),y
    // *(print_char_cursor++) = ch;
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    // }
    rts
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    ldx #' '
    lda #<print_line_cursor
    sta.z memset.str
    lda #>print_line_cursor
    sta.z memset.str+1
    jsr memset
    // }
    rts
}
// Initialize SID voice 3 for random number generation
sid_rnd_init: {
    // *SID_VOICE3_FREQ = $ffff
    lda #<$ffff
    sta SID_VOICE3_FREQ
    lda #>$ffff
    sta SID_VOICE3_FREQ+1
    // *SID_VOICE3_CONTROL = SID_CONTROL_NOISE
    lda #SID_CONTROL_NOISE
    sta SID_VOICE3_CONTROL
    // }
    rts
}
// Populates 1000 bytes (a screen) with values representing the angle to the center.
// Utilizes symmetry around the  center
// init_angle_screen(byte* zp(5) screen)
init_angle_screen: {
    .label __11 = $10
    .label screen = 5
    .label screen_topline = 3
    .label screen_bottomline = 5
    .label xw = $14
    .label yw = $16
    .label angle_w = $10
    .label ang_w = $13
    .label x = $12
    .label xb = 2
    .label y = $f
    // screen_topline = screen+40*12
    lda.z screen
    clc
    adc #<$28*$c
    sta.z screen_topline
    lda.z screen+1
    adc #>$28*$c
    sta.z screen_topline+1
    // screen_bottomline = screen+40*12
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
    // for( byte x=0,xb=39; x<=19; x++, xb--)
    lda.z x
    cmp #$13+1
    bcc __b3
    // screen_topline -= 40
    lda.z screen_topline
    sec
    sbc #<$28
    sta.z screen_topline
    lda.z screen_topline+1
    sbc #>$28
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
    clc
    adc #$27+1
    // (word){ 39-x*2, 0 }
    ldy #0
    sta.z xw+1
    sty.z xw
    // y*2
    lda.z y
    asl
    // (word){ y*2, 0 }
    sta.z yw+1
    sty.z yw
    // atan2_16(xw, yw)
    jsr atan2_16
    // angle_w = atan2_16(xw, yw)
    // angle_w+0x0080
    lda #$80
    clc
    adc.z __11
    sta.z __11
    bcc !+
    inc.z __11+1
  !:
    // ang_w = >(angle_w+0x0080)
    lda.z __11+1
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
// Find the atan2(x, y) - which is the angle of the line from (0,0) to (x,y)
// Finding the angle requires a binary search using CORDIC_ITERATIONS_16
// Returns the angle in hex-degrees (0=0, 0x8000=PI, 0x10000=2*PI)
// atan2_16(signed word zp($14) x, signed word zp($16) y)
atan2_16: {
    .label __2 = 7
    .label __7 = $1a
    .label yi = 7
    .label xi = $1a
    .label angle = $10
    .label xd = 9
    .label yd = $18
    .label return = $10
    .label x = $14
    .label y = $16
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
    bne __b11
    lda.z yi
    bne __b11
  __b12:
    // angle /=2
    lsr.z angle+1
    ror.z angle
    // if(x<0)
    lda.z x+1
    bpl __b7
    // angle = 0x8000-angle
    sec
    lda #<$8000
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
    lda.z yi
    clc
    adc.z xd
    sta.z yi
    lda.z yi+1
    adc.z xd+1
    sta.z yi+1
    // angle -= CORDIC_ATAN2_ANGLES_16[i]
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
    // for( byte i: 0..CORDIC_ITERATIONS_16-1)
    inx
    cpx #CORDIC_ITERATIONS_16-1+1
    bne !__b12+
    jmp __b12
  !__b12:
    jmp __b10
  __b18:
    // xi += yd
    lda.z xi
    clc
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
    .label screen_bottomline = 5
    .label yds = $14
    .label screen_topline = 3
    .label y = 2
    .label xds = $16
    .label ds = $16
    .label x = $f
    .label xb = $12
    // init_squares()
    jsr init_squares
    // screen_bottomline = screen+40*24
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
    // y2 = y*2
    lda.z y
    asl
    // (y2>=24)?(y2-24):(24-y2)
    cmp #$18
    bcs __b2
    eor #$ff
    clc
    adc #$18+1
  __b4:
    // sqr(yd)
    jsr sqr
    // sqr(yd)
    lda.z sqr.return
    sta.z sqr.return_1
    lda.z sqr.return+1
    sta.z sqr.return_1+1
    // yds = sqr(yd)
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
    lda.z screen_bottomline
    sec
    sbc #<$28
    sta.z screen_bottomline
    lda.z screen_bottomline+1
    sbc #>$28
    sta.z screen_bottomline+1
    // for(byte y: 0..12)
    inc.z y
    lda #$d
    cmp.z y
    bne __b1
    // }
    rts
  __b6:
    // x2 = x*2
    lda.z x
    asl
    // (x2>=39)?(x2-39):(39-x2)
    cmp #$27
    bcs __b8
    eor #$ff
    clc
    adc #$27+1
  __b10:
    // sqr(xd)
    jsr sqr
    // sqr(xd)
    // xds = sqr(xd)
    // ds = xds+yds
    lda.z ds
    clc
    adc.z yds
    sta.z ds
    lda.z ds+1
    adc.z yds+1
    sta.z ds+1
    // sqrt(ds)
    jsr sqrt
    // d = sqrt(ds)
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
// Find the (integer) square root of a word value
// If the square is not an integer then it returns the largest integer N where N*N <= val
// Uses a table of squares that must be initialized by calling init_squares()
// sqrt(word zp($16) val)
sqrt: {
    .label __1 = 7
    .label __3 = 7
    .label found = 7
    .label val = $16
    // bsearch16u(val, SQUARES, NUM_SQUARES)
    lda.z SQUARES
    sta.z bsearch16u.items
    lda.z SQUARES+1
    sta.z bsearch16u.items+1
    jsr bsearch16u
    // bsearch16u(val, SQUARES, NUM_SQUARES)
    // found = bsearch16u(val, SQUARES, NUM_SQUARES)
    // found-SQUARES
    lda.z __3
    sec
    sbc.z SQUARES
    sta.z __3
    lda.z __3+1
    sbc.z SQUARES+1
    sta.z __3+1
    lsr.z __1+1
    ror.z __1
    // (byte)(found-SQUARES)
    lda.z __1
    // }
    rts
}
// Searches an array of nitems unsigned words, the initial member of which is pointed to by base, for a member that matches the value key.
// - key - The value to look for
// - items - Pointer to the start of the array to search in
// - num - The number of items in the array
// Returns pointer to an entry in the array that matches the search key
// bsearch16u(word zp($16) key, word* zp(7) items, byte register(X) num)
bsearch16u: {
    .label __2 = 7
    .label pivot = $18
    .label result = $1a
    .label return = 7
    .label items = 7
    .label key = $16
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
    lda.z __2
    sec
    sbc #<1*SIZEOF_WORD
    sta.z __2
    lda.z __2+1
    sbc #>1*SIZEOF_WORD
    sta.z __2+1
  __b2:
    // }
    rts
  __b4:
    // num >> 1
    txa
    lsr
    // items + (num >> 1)
    asl
    clc
    adc.z items
    sta.z pivot
    lda #0
    adc.z items+1
    sta.z pivot+1
    // result = (signed int)key-(signed int)*pivot
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
    bne __b6
    lda.z result
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
// Find the square of a byte value
// Uses a table of squares that must be initialized by calling init_squares()
// sqr(byte register(A) val)
sqr: {
    .label return = $16
    .label return_1 = $14
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
// Initialize squares table
// Uses iterative formula (x+1)^2 = x^2 + 2*x + 1
init_squares: {
    .label squares = $10
    .label sqr = $1a
    // malloc(NUM_SQUARES*sizeof(word))
    lda #<NUM_SQUARES*SIZEOF_WORD
    sta.z malloc.size
    lda #>NUM_SQUARES*SIZEOF_WORD
    sta.z malloc.size+1
    jsr malloc
    // malloc(NUM_SQUARES*sizeof(word))
    // squares = SQUARES
    lda.z SQUARES
    sta.z squares
    lda.z SQUARES+1
    sta.z squares+1
    lda #<0
    sta.z sqr
    sta.z sqr+1
    tax
  __b1:
    // for(byte i=0;i<NUM_SQUARES;i++)
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
    // for(byte i=0;i<NUM_SQUARES;i++)
    inx
    jmp __b1
}
// Allocates a block of size bytes of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
// malloc(word zp(9) size)
malloc: {
    .label mem = 9
    .label size = 9
    // mem = heap_head-size
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
  // Angles representing ATAN(0.5), ATAN(0.25), ATAN(0.125), ...
CORDIC_ATAN2_ANGLES_16:
.for (var i=0; i<CORDIC_ITERATIONS_16; i++)
        .word 256*2*256*atan(1/pow(2,i))/PI/2

  .align $100
SINTABLE:
.for(var i=0;i<$200;i++)
        .byte round(127.5+127.5*sin(2*PI*i/256))

