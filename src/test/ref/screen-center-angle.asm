// Calculate the angle to the center of the screen - and show it using font-hex
// 4.65 million cycles
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
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
  // The number of iterations performed during 16-bit CORDIC atan2 calculation
  .const CORDIC_ITERATIONS_16 = $f
  // Clock cycles used to start & read the cycle clock by calling clock_start() and clock() once. Can be subtracted when calculating the number of cycles used by a routine.
  // To make precise cycle measurements interrupts and the display must be disabled so neither steals any cycles from the code.
  .const CLOCKS_PER_INIT = $12
  .label CHARSET = $2000
  .label SCREEN = $2800
main: {
    .label BASE_SCREEN = $400
    .label BASE_CHARSET = $1000
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>CHARSET)/4&$f
    .const toD0182_return = (>(BASE_SCREEN&$3fff)*4)|(>BASE_CHARSET)/4&$f
    .label _4 = $1c
    .label cyclecount = $1c
    jsr init_font_hex
    lda #toD0181_return
    sta D018
    jsr clock_start
    jsr init_angle_screen
    jsr clock
    lda cyclecount
    sec
    sbc #<CLOCKS_PER_INIT
    sta cyclecount
    lda cyclecount+1
    sbc #>CLOCKS_PER_INIT
    sta cyclecount+1
    lda cyclecount+2
    sbc #<CLOCKS_PER_INIT>>$10
    sta cyclecount+2
    lda cyclecount+3
    sbc #>CLOCKS_PER_INIT>>$10
    sta cyclecount+3
    jsr print_dword_at
    lda #toD0182_return
    sta D018
    rts
}
// Print a dword as HEX at a specific position
// print_dword_at(dword zeropage($1c) dw)
print_dword_at: {
    .label dw = $1c
    lda dw+2
    sta print_word_at.w
    lda dw+3
    sta print_word_at.w+1
    lda #<main.BASE_SCREEN
    sta print_word_at.at
    lda #>main.BASE_SCREEN
    sta print_word_at.at+1
    jsr print_word_at
    lda dw
    sta print_word_at.w
    lda dw+1
    sta print_word_at.w+1
    lda #<main.BASE_SCREEN+4
    sta print_word_at.at
    lda #>main.BASE_SCREEN+4
    sta print_word_at.at+1
    jsr print_word_at
    rts
}
// Print a word as HEX at a specific position
// print_word_at(word zeropage(2) w, byte* zeropage(4) at)
print_word_at: {
    .label w = 2
    .label at = 4
    lda w+1
    sta print_byte_at.b
    jsr print_byte_at
    lda w
    sta print_byte_at.b
    lda print_byte_at.at
    clc
    adc #2
    sta print_byte_at.at
    bcc !+
    inc print_byte_at.at+1
  !:
    jsr print_byte_at
    rts
}
// Print a byte as HEX at a specific position
// print_byte_at(byte zeropage(6) b, byte* zeropage(4) at)
print_byte_at: {
    .label b = 6
    .label at = 4
    lda b
    lsr
    lsr
    lsr
    lsr
    tay
    ldx print_hextab,y
    lda at
    sta print_char_at.at
    lda at+1
    sta print_char_at.at+1
    jsr print_char_at
    lda #$f
    and b
    tay
    lda at
    clc
    adc #1
    sta print_char_at.at
    lda at+1
    adc #0
    sta print_char_at.at+1
    ldx print_hextab,y
    jsr print_char_at
    rts
}
// Print a single char
// print_char_at(byte register(X) ch, byte* zeropage(7) at)
print_char_at: {
    .label at = 7
    txa
    ldy #0
    sta (at),y
    rts
}
// Returns the processor clock time used since the beginning of an implementation defined era (normally the beginning of the program).
// This uses CIA #2 Timer A+B on the C64, and must be initialized using clock_start()
clock: {
    .label return = $1c
    lda #<$ffffffff
    sec
    sbc CIA2_TIMER_AB
    sta return
    lda #>$ffffffff
    sbc CIA2_TIMER_AB+1
    sta return+1
    lda #<$ffffffff>>$10
    sbc CIA2_TIMER_AB+2
    sta return+2
    lda #>$ffffffff>>$10
    sbc CIA2_TIMER_AB+3
    sta return+3
    rts
}
// Populates 1000 bytes (a screen) with values representing the angle to the center.
// The actual value stored is distance*2 to increase precision
// init_angle_screen(byte* zeropage($a) screen)
init_angle_screen: {
    .label _7 = $11
    .label xw = $20
    .label yw = $22
    .label angle_w = $11
    .label screen = $a
    .label y = 9
    lda #<SCREEN
    sta screen
    lda #>SCREEN
    sta screen+1
    lda #-$c
    sta y
  b1:
    ldx #-$13
  b2:
    ldy #0
    txa
    sta xw+1
    sty xw
    lda y
    sta yw+1
    sty yw
    jsr atan2_16
    lda #$80
    clc
    adc _7
    sta _7
    bcc !+
    inc _7+1
  !:
    lda _7+1
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inx
    cpx #$15
    bne b2
    inc y
    lda #$d
    cmp y
    bne b1
    rts
}
// Find the atan2(x, y) - which is the angle of the line from (0,0) to (x,y)
// Finding the angle requires a binary search using CORDIC_ITERATIONS_16
// Returns the angle in hex-degrees (0=0, 0x8000=PI, 0x10000=2*PI)
// atan2_16(signed word zeropage($20) x, signed word zeropage($22) y)
atan2_16: {
    .label _2 = $c
    .label _7 = $e
    .label yi = $c
    .label xi = $e
    .label xd = $24
    .label yd = $26
    .label angle = $11
    .label i = $10
    .label return = $11
    .label x = $20
    .label y = $22
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
    sta i
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
    ldy i
    lda xi
    sta xd
    lda xi+1
    sta xd+1
    cpy #0
    beq !e+
  !:
    lda xd+1
    cmp #$80
    ror xd+1
    ror xd
    dey
    bne !-
  !e:
    ldy i
    lda yi
    sta yd
    lda yi+1
    sta yd+1
    cpy #0
    beq !e+
  !:
    lda yd+1
    cmp #$80
    ror yd+1
    ror yd
    dey
    bne !-
  !e:
    lda yi+1
    bpl b13
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
    lda i
    asl
    tay
    sec
    lda angle
    sbc CORDIC_ATAN2_ANGLES_16,y
    sta angle
    lda angle+1
    sbc CORDIC_ATAN2_ANGLES_16+1,y
    sta angle+1
  b14:
    inc i
    lda #CORDIC_ITERATIONS_16-1+1
    cmp i
    bne !b12+
    jmp b12
  !b12:
    jmp b10
  b13:
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
    lda i
    asl
    tay
    clc
    lda angle
    adc CORDIC_ATAN2_ANGLES_16,y
    sta angle
    lda angle+1
    adc CORDIC_ATAN2_ANGLES_16+1,y
    sta angle+1
    jmp b14
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
// init_font_hex(byte* zeropage($16) charset)
init_font_hex: {
    .label _0 = $28
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
  // Angles representing ATAN(0.5), ATAN(0.25), ATAN(0.125), ...
CORDIC_ATAN2_ANGLES_16:
.for (var i=0; i<CORDIC_ITERATIONS_16; i++)
        .word 256*2*256*atan(1/pow(2,i))/PI/2

  print_hextab: .text "0123456789abcdef"
