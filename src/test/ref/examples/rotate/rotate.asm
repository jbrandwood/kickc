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
    .label __6 = 3
    .label __8 = 3
    .label __11 = 3
    .label __12 = 3
    .label __13 = 3
    .label __14 = 3
    .label __29 = $13
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
    sta.z angle
  __b2:
    lda #$ff
    cmp RASTER
    bne __b2
    inc BORDERCOL
    jsr clock_start
    lda #0
    sta.z sprite_msb
    sta.z i
  __b4:
    ldy.z i
    lda xs,y
    sta.z x
    // signed fixed[7.0]
    lda ys,y
    sta.z y
    ldy.z angle
    lda COS,y
    jsr mulf8u_prepare
    ldy.z x
    jsr mulf8s_prepared
    lda.z __6
    asl
    sta.z xr
    lda.z __6+1
    rol
    sta.z xr+1
    ldy.z y
    jsr mulf8s_prepared
    lda.z __8
    asl
    sta.z yr
    lda.z __8+1
    rol
    sta.z yr+1
    ldy.z angle
    lda SIN,y
    jsr mulf8u_prepare
    ldy.z y
    jsr mulf8s_prepared
    asl.z __12
    rol.z __12+1
    lda.z xr
    sec
    sbc.z __12
    sta.z xr
    lda.z xr+1
    sbc.z __12+1
    sta.z xr+1
    ldy.z x
    jsr mulf8s_prepared
    asl.z __14
    rol.z __14+1
    // signed fixed[8.8]
    lda.z yr
    clc
    adc.z __14
    sta.z yr
    lda.z yr+1
    adc.z __14+1
    sta.z yr+1
    lda.z xr+1
    tax
    clc
    adc #<$18+$95
    sta.z xpos
    txa
    ora #$7f
    bmi !+
    lda #0
  !:
    adc #>$18+$95
    sta.z xpos+1
    lsr.z sprite_msb
    cmp #0
    beq __b5
    lda #$80
    ora.z sprite_msb
    sta.z sprite_msb
  __b5:
    lda.z yr+1
    clc
    adc #$59+$33
    tay
    lda.z i
    asl
    tax
    lda.z xpos
    sta SPRITES_XPOS,x
    tya
    sta SPRITES_YPOS,x
    inc.z i
    lda #8
    cmp.z i
    beq !__b4+
    jmp __b4
  !__b4:
    lda.z sprite_msb
    sta SPRITES_XMSB
    inc.z angle
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
    lda #LIGHT_BLUE
    sta BORDERCOL
    jmp __b2
}
// Print a dword as HEX at a specific position
// print_dword_at(dword zeropage($13) dw)
print_dword_at: {
    .label dw = $13
    lda.z dw+2
    sta.z print_word_at.w
    lda.z dw+3
    sta.z print_word_at.w+1
    lda #<SCREEN
    sta.z print_word_at.at
    lda #>SCREEN
    sta.z print_word_at.at+1
    jsr print_word_at
    lda.z dw
    sta.z print_word_at.w
    lda.z dw+1
    sta.z print_word_at.w+1
    lda #<SCREEN+4
    sta.z print_word_at.at
    lda #>SCREEN+4
    sta.z print_word_at.at+1
    jsr print_word_at
    rts
}
// Print a word as HEX at a specific position
// print_word_at(word zeropage(3) w, byte* zeropage(5) at)
print_word_at: {
    .label w = 3
    .label at = 5
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
// print_byte_at(byte zeropage(2) b, byte* zeropage(5) at)
print_byte_at: {
    .label b = 2
    .label at = 5
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
    bpl __b1
    lda.z m+1
    sty.z $ff
    sec
    sbc.z $ff
    sta.z m+1
  __b1:
    cpy #0
    bpl __b2
    lda.z m+1
    sec
    sbc memA
    sta.z m+1
  __b2:
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
    sta.z return
    lda memB
    sta.z return+1
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
    lda #0
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
  __b1:
    lda #SPRITE/$40
    sta sprites_ptr,x
    lda #GREEN
    sta SPRITES_COLS,x
    inx
    cpx #8
    bne __b1
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
    sta.z sqr1_hi
    lda #>mulf_sqr1_hi+1
    sta.z sqr1_hi+1
    txa
    sta.z sqr
    sta.z sqr+1
    sta.z c
    lda #<mulf_sqr1_lo+1
    sta.z sqr1_lo
    lda #>mulf_sqr1_lo+1
    sta.z sqr1_lo+1
  __b1:
    lda.z sqr1_lo+1
    cmp #>mulf_sqr1_lo+$200
    bne __b2
    lda.z sqr1_lo
    cmp #<mulf_sqr1_lo+$200
    bne __b2
    lda #$ff
    sta.z dir
    lda #<mulf_sqr2_hi
    sta.z sqr2_hi
    lda #>mulf_sqr2_hi
    sta.z sqr2_hi+1
    ldx #-1
    lda #<mulf_sqr2_lo
    sta.z sqr2_lo
    lda #>mulf_sqr2_lo
    sta.z sqr2_lo+1
  __b5:
    lda.z sqr2_lo+1
    cmp #>mulf_sqr2_lo+$1ff
    bne __b6
    lda.z sqr2_lo
    cmp #<mulf_sqr2_lo+$1ff
    bne __b6
    // Set the very last value g(511) = f(256)
    lda mulf_sqr1_lo+$100
    sta mulf_sqr2_lo+$1ff
    lda mulf_sqr1_hi+$100
    sta mulf_sqr2_hi+$1ff
    rts
  __b6:
    lda mulf_sqr1_lo,x
    ldy #0
    sta (sqr2_lo),y
    lda mulf_sqr1_hi,x
    sta (sqr2_hi),y
    inc.z sqr2_hi
    bne !+
    inc.z sqr2_hi+1
  !:
    txa
    clc
    adc.z dir
    tax
    cpx #0
    bne __b8
    lda #1
    sta.z dir
  __b8:
    inc.z sqr2_lo
    bne !+
    inc.z sqr2_lo+1
  !:
    jmp __b5
  __b2:
    inc.z c
    lda #1
    and.z c
    cmp #0
    bne __b3
    inx
    inc.z sqr
    bne !+
    inc.z sqr+1
  !:
  __b3:
    lda.z sqr
    ldy #0
    sta (sqr1_lo),y
    lda.z sqr+1
    sta (sqr1_hi),y
    inc.z sqr1_hi
    bne !+
    inc.z sqr1_hi+1
  !:
    txa
    clc
    adc.z sqr
    sta.z sqr
    bcc !+
    inc.z sqr+1
  !:
    inc.z sqr1_lo
    bne !+
    inc.z sqr1_lo+1
  !:
    jmp __b1
}
  print_hextab: .text "0123456789abcdef"
  // Positions to rotate
  xs: .byte -$46, -$46, -$46, 0, 0, $46, $46, $46
  ys: .byte -$46, 0, $46, -$46, $46, -$46, 0, $46
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
  // Sine and Cosine tables  
  // Angles: $00=0, $80=PI,$100=2*PI
  // Sine/Cosine: signed fixed [-$7f,$7f]
  .align $40
SIN:
.for(var i=0;i<$140;i++)
        .byte >round($7fff*sin(i*2*PI/256))

.pc = SPRITE "SPRITE"
  .var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)

