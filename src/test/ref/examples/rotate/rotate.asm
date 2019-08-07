// 2D rotattion of 8 sprites 
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label SPRITES_XMSB = $d010
  .label RASTER = $d012
  .label SPRITES_ENABLE = $d015
  .label BORDERCOL = $d020
  .label SPRITES_COLS = $d027
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
  .const GREEN = 5
  .const LIGHT_BLUE = $e
  // Clock cycles used to start & read the cycle clock by calling clock_start() and clock() once. Can be subtracted when calculating the number of cycles used by a routine.
  // To make precise cycle measurements interrupts and the display must be disabled so neither steals any cycles from the code.
  .const CLOCKS_PER_INIT = $12
  .label SCREEN = $400
  // A single sprite
  .label SPRITE = $3000
  .label COS = SIN+$40
// sin(x) = cos(x+PI/2)
main: {
    sei
    jsr init
    jsr anim
    rts
}
anim: {
    .label _5 = 3
    .label _7 = 3
    .label _10 = 3
    .label _11 = 3
    .label _12 = 3
    .label _13 = 3
    .label _28 = $13
    .label x = $b
    .label y = $c
    .label xr = $d
    .label yr = $f
    .label xpos = $11
    .label sprite_msb = $a
    .label i = 2
    .label angle = 7
    .label cyclecount = $13
    lda #0
    sta angle
  b2:
    lda #$ff
    cmp RASTER
    bne b2
    inc BORDERCOL
    jsr clock_start
    lda #0
    sta sprite_msb
    sta i
  b4:
    ldy i
    lda xs,y
    sta x
    // signed fixed[7.0]
    lda ys,y
    sta y
    ldy angle
    lda COS,y
    jsr mulf8u_prepare
    ldy x
    jsr mulf8s_prepared
    lda _5
    asl
    sta xr
    lda _5+1
    rol
    sta xr+1
    ldy y
    jsr mulf8s_prepared
    lda _7
    asl
    sta yr
    lda _7+1
    rol
    sta yr+1
    ldy angle
    lda SIN,y
    jsr mulf8u_prepare
    ldy y
    jsr mulf8s_prepared
    asl _11
    rol _11+1
    lda xr
    sec
    sbc _11
    sta xr
    lda xr+1
    sbc _11+1
    sta xr+1
    ldy x
    jsr mulf8s_prepared
    asl _13
    rol _13+1
    // signed fixed[8.8]
    lda yr
    clc
    adc _13
    sta yr
    lda yr+1
    adc _13+1
    sta yr+1
    lda xr+1
    tax
    clc
    adc #<$18+$95
    sta xpos
    txa
    ora #$7f
    bmi !+
    lda #0
  !:
    adc #>$18+$95
    sta xpos+1
    lsr sprite_msb
    cmp #0
    beq b5
    lda #$80
    ora sprite_msb
    sta sprite_msb
  b5:
    lda yr+1
    clc
    adc #$59+$33
    tay
    lda i
    asl
    tax
    lda xpos
    sta SPRITES_XPOS,x
    tya
    sta SPRITES_YPOS,x
    inc i
    lda #8
    cmp i
    beq !b4+
    jmp b4
  !b4:
    lda sprite_msb
    sta SPRITES_XMSB
    inc angle
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
    lda #LIGHT_BLUE
    sta BORDERCOL
    jmp b2
}
// Print a dword as HEX at a specific position
// print_dword_at(dword zeropage($13) dw)
print_dword_at: {
    .label dw = $13
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
// print_word_at(word zeropage(3) w, byte* zeropage(5) at)
print_word_at: {
    .label w = 3
    .label at = 5
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
// print_byte_at(byte zeropage(2) b, byte* zeropage(5) at)
print_byte_at: {
    .label b = 2
    .label at = 5
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
// print_char_at(byte register(X) ch, byte* zeropage(8) at)
print_char_at: {
    .label at = 8
    txa
    ldy #0
    sta (at),y
    rts
}
// Returns the processor clock time used since the beginning of an implementation defined era (normally the beginning of the program).
// This uses CIA #2 Timer A+B on the C64, and must be initialized using clock_start()
clock: {
    .label return = $13
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
// Calculate fast multiply with a prepared unsigned byte to a word result
// The prepared number is set by calling mulf8s_prepare(byte a)
// mulf8s_prepared(signed byte register(Y) b)
mulf8s_prepared: {
    .label memA = $fd
    .label m = 3
    tya
    jsr mulf8u_prepared
    lda memA
    cmp #0
    bpl b1
    lda m+1
    sty $ff
    sec
    sbc $ff
    sta m+1
  b1:
    cpy #0
    bpl b2
    lda m+1
    sec
    sbc memA
    sta m+1
  b2:
    rts
}
// Calculate fast multiply with a prepared unsigned byte to a word result
// The prepared number is set by calling mulf8u_prepare(byte a)
// mulf8u_prepared(byte register(A) b)
mulf8u_prepared: {
    .label resL = $fe
    .label memB = $ff
    .label return = 3
    sta memB
    tax
    sec
  sm1:
    lda mulf_sqr1_lo,x
  sm2:
    sbc mulf_sqr2_lo,x
    sta resL
  sm3:
    lda mulf_sqr1_hi,x
  sm4:
    sbc mulf_sqr2_hi,x
    sta memB
    lda resL
    sta return
    lda memB
    sta return+1
    rts
}
// Prepare for fast multiply with an unsigned byte to a word result
// mulf8u_prepare(byte register(A) a)
mulf8u_prepare: {
    .label memA = $fd
    sta memA
    sta mulf8u_prepared.sm1+1
    sta mulf8u_prepared.sm3+1
    eor #$ff
    sta mulf8u_prepared.sm2+1
    sta mulf8u_prepared.sm4+1
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
init: {
    .label sprites_ptr = SCREEN+$3f8
    jsr mulf_init
    lda #$ff
    sta SPRITES_ENABLE
    ldx #0
  b1:
    lda #SPRITE/$40
    sta sprites_ptr,x
    lda #GREEN
    sta SPRITES_COLS,x
    inx
    cpx #8
    bne b1
    rts
}
// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x/4)
mulf_init: {
    .label c = 7
    .label sqr1_hi = 8
    .label sqr = $11
    .label sqr1_lo = 5
    .label sqr2_hi = $f
    .label sqr2_lo = $d
    .label dir = $a
    ldx #0
    lda #<mulf_sqr1_hi+1
    sta sqr1_hi
    lda #>mulf_sqr1_hi+1
    sta sqr1_hi+1
    txa
    sta sqr
    sta sqr+1
    sta c
    lda #<mulf_sqr1_lo+1
    sta sqr1_lo
    lda #>mulf_sqr1_lo+1
    sta sqr1_lo+1
  b1:
    lda sqr1_lo+1
    cmp #>mulf_sqr1_lo+$200
    bne b2
    lda sqr1_lo
    cmp #<mulf_sqr1_lo+$200
    bne b2
    lda #$ff
    sta dir
    lda #<mulf_sqr2_hi
    sta sqr2_hi
    lda #>mulf_sqr2_hi
    sta sqr2_hi+1
    ldx #-1
    lda #<mulf_sqr2_lo
    sta sqr2_lo
    lda #>mulf_sqr2_lo
    sta sqr2_lo+1
  b5:
    lda sqr2_lo+1
    cmp #>mulf_sqr2_lo+$1ff
    bne b6
    lda sqr2_lo
    cmp #<mulf_sqr2_lo+$1ff
    bne b6
    // Set the very last value g(511) = f(256)
    lda mulf_sqr1_lo+$100
    sta mulf_sqr2_lo+$1ff
    lda mulf_sqr1_hi+$100
    sta mulf_sqr2_hi+$1ff
    rts
  b6:
    lda mulf_sqr1_lo,x
    ldy #0
    sta (sqr2_lo),y
    lda mulf_sqr1_hi,x
    sta (sqr2_hi),y
    inc sqr2_hi
    bne !+
    inc sqr2_hi+1
  !:
    txa
    clc
    adc dir
    tax
    cpx #0
    bne b8
    lda #1
    sta dir
  b8:
    inc sqr2_lo
    bne !+
    inc sqr2_lo+1
  !:
    jmp b5
  b2:
    inc c
    lda #1
    and c
    cmp #0
    bne b3
    inx
    inc sqr
    bne !+
    inc sqr+1
  !:
  b3:
    lda sqr
    ldy #0
    sta (sqr1_lo),y
    lda sqr+1
    sta (sqr1_hi),y
    inc sqr1_hi
    bne !+
    inc sqr1_hi+1
  !:
    txa
    clc
    adc sqr
    sta sqr
    bcc !+
    inc sqr+1
  !:
    inc sqr1_lo
    bne !+
    inc sqr1_lo+1
  !:
    jmp b1
}
  // mulf_sqr tables will contain f(x)=int(x*x/4) and g(x) = f(x-255).
  // <f(x) = <(( x * x )/4)
  .align $100
  mulf_sqr1_lo: .fill $200, 0
  // >f(x) = >(( x * x )/4)
  .align $100
  mulf_sqr1_hi: .fill $200, 0
  // <g(x) =  <((( x - 255) * ( x - 255 ))/4)
  .align $100
  mulf_sqr2_lo: .fill $200, 0
  // >g(x) = >((( x - 255) * ( x - 255 ))/4)
  .align $100
  mulf_sqr2_hi: .fill $200, 0
  print_hextab: .text "0123456789abcdef"
  // Sine and Cosine tables  
  // Angles: $00=0, $80=PI,$100=2*PI
  // Sine/Cosine: signed fixed [-$7f,$7f]
  .align $40
SIN:
.for(var i=0;i<$140;i++)
        .byte >round($7fff*sin(i*2*PI/256))

  // Positions to rotate
  xs: .byte -$46, -$46, -$46, 0, 0, $46, $46, $46
  ys: .byte -$46, 0, $46, -$46, $46, -$46, 0, $46
.pc = SPRITE "SPRITE"
  .var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)

