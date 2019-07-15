// Quadratic Spline Library for the C64
// Implements an iterative algorithm using only addition for calculating quadratic splines
//
// A quadratic spline is a curve defined by 3 points: P0, P1 and P2.
// The curve connects P0 to P2 through a smooth curve that moves towards P1, but does usually not touch it.
//
// The general formula for the quadratic spline is as follows:
// A = P2 - 2*P1 + P0
// B = 2*P1 - 2*P0
// C = P0
// P(t) = A*t*t + B*t + C
// for 0 <= t <= 1
//
// This library implements a iterative algorithm using multiplications in the initialization and only additions for calculating each point on the spline.
// The iterative algorithm is based on the following:
// P(t+Dt) = P(t) + A*Dt*Dt + 2*A*t*Dt + B*Dt
//
// init:
//   N = 16 (number of plots)
//   Dt = 1/N
//   P = C
//   I = A*Dt*Dt + B*Dt
//   J = 2*A*Dt*Dt
// loop(N times):
//   plot(P)
//   P = P + I
//   I = I + J
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label D011 = $d011
  .const VIC_BMM = $20
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .label D018 = $d018
  // CIA#2 Port A: Serial bus, RS-232, VIC memory bank
  .label CIA2_PORT_A = $dd00
  // CIA #2 Port A data direction register.
  .label CIA2_PORT_A_DDR = $dd02
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
  .const WHITE = 1
  // Clock cycles used to start & read the cycle clock by calling clock_start() and clock() once. Can be subtracted when calculating the number of cycles used by a routine.
  // To make precise cycle measurements interrupts and the display must be disabled so neither steals any cycles from the code.
  .const CLOCKS_PER_INIT = $12
  .label SCREEN = $400
  .label BITMAP_SCREEN = $5c00
  .label BITMAP_GRAPHICS = $6000
main: {
    .const p0_x = $32
    .const p0_y = $32
    .const p1a_x = $64
    .const p1a_y = $32
    .const p1b_x = $32
    .const p1b_y = $64
    .const p2_x = $64
    .const p2_y = $64
    .const p3a_x = $96
    .const p3a_y = $64
    .const p3b_x = $64
    .const p3b_y = $96
    .const p4_x = $96
    .const p4_y = $96
    .const vicSelectGfxBank1_toDd001_return = 3^(>BITMAP_SCREEN)/$40
    .const toD0181_return = (>(BITMAP_SCREEN&$3fff)*4)|(>BITMAP_GRAPHICS)/4&$f
    .label _12 = $2b
    .label cyclecount = $2b
    jsr bitmap_init
    jsr bitmap_clear
    lda #3
    sta CIA2_PORT_A_DDR
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2_PORT_A
    lda #toD0181_return
    sta D018
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta D011
    jsr clock_start
    lda #<p0_y
    sta splinePlot.p0_y
    lda #>p0_y
    sta splinePlot.p0_y+1
    lda #<p2_y
    sta splinePlot.p2_y
    lda #>p2_y
    sta splinePlot.p2_y+1
    lda #<p1a_y
    sta splinePlot.p1_y
    lda #>p1a_y
    sta splinePlot.p1_y+1
    lda #<p0_x
    sta splinePlot.p0_x
    lda #>p0_x
    sta splinePlot.p0_x+1
    lda #<p2_x
    sta splinePlot.p2_x
    lda #>p2_x
    sta splinePlot.p2_x+1
    lda #<p1a_x
    sta splinePlot.p1_x
    lda #>p1a_x
    sta splinePlot.p1_x+1
    jsr splinePlot
    lda #<p2_y
    sta splinePlot.p0_y
    lda #>p2_y
    sta splinePlot.p0_y+1
    lda #<p4_y
    sta splinePlot.p2_y
    lda #>p4_y
    sta splinePlot.p2_y+1
    lda #<p3a_y
    sta splinePlot.p1_y
    lda #>p3a_y
    sta splinePlot.p1_y+1
    lda #<p2_x
    sta splinePlot.p0_x
    lda #>p2_x
    sta splinePlot.p0_x+1
    lda #<p4_x
    sta splinePlot.p2_x
    lda #>p4_x
    sta splinePlot.p2_x+1
    lda #<p3a_x
    sta splinePlot.p1_x
    lda #>p3a_x
    sta splinePlot.p1_x+1
    jsr splinePlot
    lda #<p2_y
    sta splinePlot.p0_y
    lda #>p2_y
    sta splinePlot.p0_y+1
    lda #<p0_y
    sta splinePlot.p2_y
    lda #>p0_y
    sta splinePlot.p2_y+1
    lda #<p1b_y
    sta splinePlot.p1_y
    lda #>p1b_y
    sta splinePlot.p1_y+1
    lda #<p2_x
    sta splinePlot.p0_x
    lda #>p2_x
    sta splinePlot.p0_x+1
    lda #<p0_x
    sta splinePlot.p2_x
    lda #>p0_x
    sta splinePlot.p2_x+1
    lda #<p1b_x
    sta splinePlot.p1_x
    lda #>p1b_x
    sta splinePlot.p1_x+1
    jsr splinePlot
    lda #<p4_y
    sta splinePlot.p0_y
    lda #>p4_y
    sta splinePlot.p0_y+1
    lda #<p2_y
    sta splinePlot.p2_y
    lda #>p2_y
    sta splinePlot.p2_y+1
    lda #<p3b_y
    sta splinePlot.p1_y
    lda #>p3b_y
    sta splinePlot.p1_y+1
    lda #<p4_x
    sta splinePlot.p0_x
    lda #>p4_x
    sta splinePlot.p0_x+1
    lda #<p2_x
    sta splinePlot.p2_x
    lda #>p2_x
    sta splinePlot.p2_x+1
    lda #<p3b_x
    sta splinePlot.p1_x
    lda #>p3b_x
    sta splinePlot.p1_x+1
    jsr splinePlot
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
    rts
}
// Print a dword as HEX at a specific position
// print_dword_at(dword zeropage($2b) dw)
print_dword_at: {
    .label dw = $2b
    lda dw+2
    sta print_word_at.w
    lda dw+3
    sta print_word_at.w+1
    lda #<SCREEN
    sta print_word_at.at
    lda #>SCREEN
    sta print_word_at.at+1
    jsr print_word_at
    lda dw
    sta print_word_at.w
    lda dw+1
    sta print_word_at.w+1
    lda #<SCREEN+4
    sta print_word_at.at
    lda #>SCREEN+4
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
    .label return = $2b
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
// splinePlot(signed word zeropage($d) p0_x, signed word zeropage($13) p0_y, signed word zeropage(9) p1_x, signed word zeropage($f) p1_y, signed word zeropage($b) p2_x, signed word zeropage($11) p2_y)
splinePlot: {
    .label _1 = $b
    .label _4 = $11
    .label _6 = 9
    .label _7 = $2f
    .label _9 = $f
    .label _10 = $31
    .label _12 = $1d
    .label _13 = $1d
    .label _14 = $33
    .label _15 = $33
    .label _16 = $33
    .label _18 = $21
    .label _19 = $21
    .label _20 = $37
    .label _21 = $37
    .label _22 = $37
    .label _24 = $3b
    .label _25 = $3b
    .label _27 = $3f
    .label _28 = $3f
    .label _30 = $15
    .label _32 = $19
    .label _35 = $45
    .label a_x = $b
    .label a_y = $11
    .label b_x = $2f
    .label b_y = $31
    .label i_x = $1d
    .label i_y = $21
    .label j_x = $3b
    .label j_y = $3f
    .label p_x = $15
    .label p_y = $19
    .label p1_x = 9
    .label p2_x = $b
    .label p0_x = $d
    .label p1_y = $f
    .label p2_y = $11
    .label p0_y = $13
    asl _6
    rol _6+1
    lda _1
    sec
    sbc _6
    sta _1
    lda _1+1
    sbc _6+1
    sta _1+1
    lda a_x
    clc
    adc p0_x
    sta a_x
    lda a_x+1
    adc p0_x+1
    sta a_x+1
    asl _9
    rol _9+1
    lda _4
    sec
    sbc _9
    sta _4
    lda _4+1
    sbc _9+1
    sta _4+1
    lda a_y
    clc
    adc p0_y
    sta a_y
    lda a_y+1
    adc p0_y+1
    sta a_y+1
    lda p0_x
    asl
    sta _7
    lda p0_x+1
    rol
    sta _7+1
    lda _6
    sec
    sbc b_x
    sta b_x
    lda _6+1
    sbc b_x+1
    sta b_x+1
    lda p0_y
    asl
    sta _10
    lda p0_y+1
    rol
    sta _10+1
    lda _9
    sec
    sbc b_y
    sta b_y
    lda _9+1
    sbc b_y+1
    sta b_y+1
    lda a_x
    sta _12
    lda a_x+1
    sta _12+1
    ora #$7f
    bmi !+
    lda #0
  !:
    sta _12+2
    sta _12+3
    lda _13+2
    sta _13+3
    lda _13+1
    sta _13+2
    lda _13
    sta _13+1
    lda #0
    sta _13
    lda b_x
    sta _14
    lda b_x+1
    sta _14+1
    ora #$7f
    bmi !+
    lda #0
  !:
    sta _14+2
    sta _14+3
    lda _15+2
    sta _15+3
    lda _15+1
    sta _15+2
    lda _15
    sta _15+1
    lda #0
    sta _15
    asl _16
    rol _16+1
    rol _16+2
    rol _16+3
    asl _16
    rol _16+1
    rol _16+2
    rol _16+3
    asl _16
    rol _16+1
    rol _16+2
    rol _16+3
    asl _16
    rol _16+1
    rol _16+2
    rol _16+3
    lda i_x
    clc
    adc _16
    sta i_x
    lda i_x+1
    adc _16+1
    sta i_x+1
    lda i_x+2
    adc _16+2
    sta i_x+2
    lda i_x+3
    adc _16+3
    sta i_x+3
    lda a_y
    sta _18
    lda a_y+1
    sta _18+1
    ora #$7f
    bmi !+
    lda #0
  !:
    sta _18+2
    sta _18+3
    lda _19+2
    sta _19+3
    lda _19+1
    sta _19+2
    lda _19
    sta _19+1
    lda #0
    sta _19
    lda b_y
    sta _20
    lda b_y+1
    sta _20+1
    ora #$7f
    bmi !+
    lda #0
  !:
    sta _20+2
    sta _20+3
    lda _21+2
    sta _21+3
    lda _21+1
    sta _21+2
    lda _21
    sta _21+1
    lda #0
    sta _21
    asl _22
    rol _22+1
    rol _22+2
    rol _22+3
    asl _22
    rol _22+1
    rol _22+2
    rol _22+3
    asl _22
    rol _22+1
    rol _22+2
    rol _22+3
    asl _22
    rol _22+1
    rol _22+2
    rol _22+3
    lda i_y
    clc
    adc _22
    sta i_y
    lda i_y+1
    adc _22+1
    sta i_y+1
    lda i_y+2
    adc _22+2
    sta i_y+2
    lda i_y+3
    adc _22+3
    sta i_y+3
    lda a_x
    sta _24
    lda a_x+1
    sta _24+1
    ora #$7f
    bmi !+
    lda #0
  !:
    sta _24+2
    sta _24+3
    lda _25+2
    sta _25+3
    lda _25+1
    sta _25+2
    lda _25
    sta _25+1
    lda #0
    sta _25
    asl j_x
    rol j_x+1
    rol j_x+2
    rol j_x+3
    lda a_y
    sta _27
    lda a_y+1
    sta _27+1
    ora #$7f
    bmi !+
    lda #0
  !:
    sta _27+2
    sta _27+3
    lda _28+2
    sta _28+3
    lda _28+1
    sta _28+2
    lda _28
    sta _28+1
    lda #0
    sta _28
    asl j_y
    rol j_y+1
    rol j_y+2
    rol j_y+3
    lda p0_x
    sta _30
    lda p0_x+1
    sta _30+1
    ora #$7f
    bmi !+
    lda #0
  !:
    sta _30+2
    sta _30+3
    lda p_x+1
    sta p_x+3
    lda p_x
    sta p_x+2
    lda #0
    sta p_x
    sta p_x+1
    lda p0_y
    sta _32
    lda p0_y+1
    sta _32+1
    ora #$7f
    bmi !+
    lda #0
  !:
    sta _32+2
    sta _32+3
    lda p_y+1
    sta p_y+3
    lda p_y
    sta p_y+2
    lda #0
    sta p_y
    sta p_y+1
    tax
  b1:
    lda p_x+2
    sta bitmap_plot.x
    lda p_x+3
    sta bitmap_plot.x+1
    lda p_y+2
    sta _35
    lda p_y+3
    sta _35+1
    lda _35
    jsr bitmap_plot
    lda p_x
    clc
    adc i_x
    sta p_x
    lda p_x+1
    adc i_x+1
    sta p_x+1
    lda p_x+2
    adc i_x+2
    sta p_x+2
    lda p_x+3
    adc i_x+3
    sta p_x+3
    lda p_y
    clc
    adc i_y
    sta p_y
    lda p_y+1
    adc i_y+1
    sta p_y+1
    lda p_y+2
    adc i_y+2
    sta p_y+2
    lda p_y+3
    adc i_y+3
    sta p_y+3
    lda i_x
    clc
    adc j_x
    sta i_x
    lda i_x+1
    adc j_x+1
    sta i_x+1
    lda i_x+2
    adc j_x+2
    sta i_x+2
    lda i_x+3
    adc j_x+3
    sta i_x+3
    lda i_y
    clc
    adc j_y
    sta i_y
    lda i_y+1
    adc j_y+1
    sta i_y+1
    lda i_y+2
    adc j_y+2
    sta i_y+2
    lda i_y+3
    adc j_y+3
    sta i_y+3
    inx
    cpx #$11
    bne b1
    rts
}
// Plot a single dot in the bitmap
// bitmap_plot(word zeropage($43) x, byte register(A) y)
bitmap_plot: {
    .label _1 = $49
    .label plotter = $47
    .label x = $43
    tay
    lda bitmap_plot_yhi,y
    sta plotter+1
    lda bitmap_plot_ylo,y
    sta plotter
    lda x
    and #<$fff8
    sta _1
    lda x+1
    and #>$fff8
    sta _1+1
    lda plotter
    clc
    adc _1
    sta plotter
    lda plotter+1
    adc _1+1
    sta plotter+1
    lda x
    tay
    lda bitmap_plot_bit,y
    ldy #0
    ora (plotter),y
    sta (plotter),y
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
// Clear all graphics on the bitmap
// bgcol - the background color to fill the screen with
// fgcol - the foreground color to fill the screen with
bitmap_clear: {
    .const col = WHITE*$10
    ldx #col
    lda #<BITMAP_SCREEN
    sta memset.str
    lda #>BITMAP_SCREEN
    sta memset.str+1
    lda #<$3e8
    sta memset.num
    lda #>$3e8
    sta memset.num+1
    jsr memset
    ldx #0
    lda #<BITMAP_GRAPHICS
    sta memset.str
    lda #>BITMAP_GRAPHICS
    sta memset.str+1
    lda #<$1f40
    sta memset.num
    lda #>$1f40
    sta memset.num+1
    jsr memset
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage($27) str, byte register(X) c, word zeropage($25) num)
memset: {
    .label end = $25
    .label dst = $27
    .label num = $25
    .label str = $27
    lda num
    beq breturn
    lda num+1
    beq breturn
    lda end
    clc
    adc str
    sta end
    lda end+1
    adc str+1
    sta end+1
  b2:
    txa
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    lda dst+1
    cmp end+1
    bne b2
    lda dst
    cmp end
    bne b2
  breturn:
    rts
}
// Initialize bitmap plotting tables
bitmap_init: {
    .label _7 = $4b
    .label yoffs = $29
    ldx #0
    lda #$80
  b1:
    sta bitmap_plot_bit,x
    lsr
    cmp #0
    bne b2
    lda #$80
  b2:
    inx
    cpx #0
    bne b1
    lda #<BITMAP_GRAPHICS
    sta yoffs
    lda #>BITMAP_GRAPHICS
    sta yoffs+1
    ldx #0
  b3:
    lda #7
    sax _7
    lda yoffs
    ora _7
    sta bitmap_plot_ylo,x
    lda yoffs+1
    sta bitmap_plot_yhi,x
    lda #7
    cmp _7
    bne b4
    clc
    lda yoffs
    adc #<$28*8
    sta yoffs
    lda yoffs+1
    adc #>$28*8
    sta yoffs+1
  b4:
    inx
    cpx #0
    bne b3
    rts
}
  print_hextab: .text "0123456789abcdef"
  // Tables for the plotter - initialized by calling bitmap_init();
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
