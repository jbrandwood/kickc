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
  .label COS = SIN+$40
  // A single sprite
  .label SPRITE = $3000
  // kickasm
// sin(x) = cos(x+PI/2)
main: {
    // asm
    sei
    // init()
    jsr init
    // anim()
    jsr anim
    // }
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
    // signed fixed[0.7]
    .label sprite_msb = 2
    .label i = $a
    .label angle = 7
    .label cyclecount = $13
    lda #0
    sta.z angle
  __b2:
    // while(*RASTER!=$ff)
    lda #$ff
    cmp RASTER
    bne __b2
    // (*BORDERCOL)++;
    inc BORDERCOL
    // clock_start()
    jsr clock_start
    lda #0
    sta.z sprite_msb
    sta.z i
  __b4:
    // x = xs[i]
    ldy.z i
    lda xs,y
    sta.z x
    // y = ys[i]
    // signed fixed[7.0]
    lda ys,y
    sta.z y
    ldy.z angle
    lda COS,y
    // mulf8u_prepare((byte)a)
    jsr mulf8u_prepare
    // mulf8s_prepared(x)
    ldy.z x
    jsr mulf8s_prepared
    // mulf8s_prepared(x)
    // xr = mulf8s_prepared(x)*2
    lda.z __6
    asl
    sta.z xr
    lda.z __6+1
    rol
    sta.z xr+1
    // mulf8s_prepared(y)
    ldy.z y
    jsr mulf8s_prepared
    // mulf8s_prepared(y)
    // yr = mulf8s_prepared(y)*2
    lda.z __8
    asl
    sta.z yr
    lda.z __8+1
    rol
    sta.z yr+1
    ldy.z angle
    lda SIN,y
    // mulf8u_prepare((byte)a)
    jsr mulf8u_prepare
    // mulf8s_prepared(y)
    ldy.z y
    jsr mulf8s_prepared
    // mulf8s_prepared(y)
    // mulf8s_prepared(y)*2
    asl.z __12
    rol.z __12+1
    // xr -= mulf8s_prepared(y)*2
    lda.z xr
    sec
    sbc.z __12
    sta.z xr
    lda.z xr+1
    sbc.z __12+1
    sta.z xr+1
    // mulf8s_prepared(x)
    ldy.z x
    jsr mulf8s_prepared
    // mulf8s_prepared(x)
    // mulf8s_prepared(x)*2
    asl.z __14
    rol.z __14+1
    // yr += mulf8s_prepared(x)*2
    // signed fixed[8.8]
    lda.z yr
    clc
    adc.z __14
    sta.z yr
    lda.z yr+1
    adc.z __14+1
    sta.z yr+1
    // >xr
    lda.z xr+1
    // xpos = ((signed char) >xr) + 24 /*border*/ + 149
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
    // sprite_msb = sprite_msb/2
    lsr.z sprite_msb
    // >xpos
    // if(>xpos!=0)
    cmp #0
    beq __b5
    // sprite_msb |= $80
    lda #$80
    ora.z sprite_msb
    sta.z sprite_msb
  __b5:
    // (>yr) + 89
    lda.z yr+1
    // ypos = (>yr) + 89 /*center*/+ 51
    clc
    adc #$59+$33
    tay
    // i2 = i*2
    lda.z i
    asl
    tax
    // <xpos
    lda.z xpos
    // SPRITES_XPOS[i2] = <xpos
    sta SPRITES_XPOS,x
    // SPRITES_YPOS[i2] = ypos
    tya
    sta SPRITES_YPOS,x
    // for(char i: 0..7)
    inc.z i
    lda #8
    cmp.z i
    beq !__b4+
    jmp __b4
  !__b4:
    // *SPRITES_XMSB = sprite_msb
    lda.z sprite_msb
    sta SPRITES_XMSB
    // angle++;
    inc.z angle
    // clock()
    jsr clock
    // cyclecount = clock()-CLOCKS_PER_INIT
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
    // print_dword_at(cyclecount, SCREEN)
    // Print cycle count
    jsr print_dword_at
    // *BORDERCOL = LIGHT_BLUE
    lda #LIGHT_BLUE
    sta BORDERCOL
    jmp __b2
}
// Print a dword as HEX at a specific position
// print_dword_at(dword zp($13) dw)
print_dword_at: {
    .label dw = $13
    // print_word_at(>dw, at)
    lda.z dw+2
    sta.z print_word_at.w
    lda.z dw+3
    sta.z print_word_at.w+1
    lda #<SCREEN
    sta.z print_word_at.at
    lda #>SCREEN
    sta.z print_word_at.at+1
    jsr print_word_at
    // print_word_at(<dw, at+4)
    lda.z dw
    sta.z print_word_at.w
    lda.z dw+1
    sta.z print_word_at.w+1
    lda #<SCREEN+4
    sta.z print_word_at.at
    lda #>SCREEN+4
    sta.z print_word_at.at+1
    jsr print_word_at
    // }
    rts
}
// Print a word as HEX at a specific position
// print_word_at(word zp(3) w, byte* zp(5) at)
print_word_at: {
    .label w = 3
    .label at = 5
    // print_byte_at(>w, at)
    lda.z w+1
    sta.z print_byte_at.b
    jsr print_byte_at
    // print_byte_at(<w, at+2)
    lda.z w
    sta.z print_byte_at.b
    lda #2
    clc
    adc.z print_byte_at.at
    sta.z print_byte_at.at
    bcc !+
    inc.z print_byte_at.at+1
  !:
    jsr print_byte_at
    // }
    rts
}
// Print a byte as HEX at a specific position
// print_byte_at(byte zp($b) b, byte* zp(5) at)
print_byte_at: {
    .label b = $b
    .label at = 5
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
    lda.z at
    clc
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
// print_char_at(byte register(X) ch, byte* zp(8) at)
print_char_at: {
    .label at = 8
    // *(at) = ch
    txa
    ldy #0
    sta (at),y
    // }
    rts
}
// Returns the processor clock time used since the beginning of an implementation defined era (normally the beginning of the program).
// This uses CIA #2 Timer A+B on the C64, and must be initialized using clock_start()
clock: {
    .label return = $13
    // 0xffffffff - *CIA2_TIMER_AB
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
    // }
    rts
}
// Calculate fast multiply with a prepared unsigned byte to a word result
// The prepared number is set by calling mulf8s_prepare(byte a)
// mulf8s_prepared(signed byte register(Y) b)
mulf8s_prepared: {
    .label memA = $fd
    .label m = 3
    // mulf8u_prepared((byte) b)
    tya
    jsr mulf8u_prepared
    // m = mulf8u_prepared((byte) b)
    // if(*memA<0)
    lda memA
    cmp #0
    bpl __b1
    // >m
    lda.z m+1
    // >m = (>m)-(byte)b
    sty.z $ff
    sec
    sbc.z $ff
    sta.z m+1
  __b1:
    // if(b<0)
    cpy #0
    bpl __b2
    // >m
    lda.z m+1
    // >m = (>m)-(byte)*memA
    sec
    sbc memA
    sta.z m+1
  __b2:
    // }
    rts
}
// Calculate fast multiply with a prepared unsigned byte to a word result
// The prepared number is set by calling mulf8u_prepare(byte a)
// mulf8u_prepared(byte register(A) b)
mulf8u_prepared: {
    .label resL = $fe
    .label memB = $ff
    .label return = 3
    // *memB = b
    sta memB
    // asm
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
    // return { *memB, *resL };
    lda resL
    sta.z return
    lda memB
    sta.z return+1
    // }
    rts
}
// Prepare for fast multiply with an unsigned byte to a word result
// mulf8u_prepare(byte register(A) a)
mulf8u_prepare: {
    .label memA = $fd
    // *memA = a
    sta memA
    // asm
    sta mulf8u_prepared.sm1+1
    sta mulf8u_prepared.sm3+1
    eor #$ff
    sta mulf8u_prepared.sm2+1
    sta mulf8u_prepared.sm4+1
    // }
    rts
}
// Reset & start the processor clock time. The value can be read using clock().
// This uses CIA #2 Timer A+B on the C64
clock_start: {
    // *CIA2_TIMER_A_CONTROL = CIA_TIMER_CONTROL_STOP | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_A_COUNT_CYCLES
    // Setup CIA#2 timer A to count (down) CPU cycles
    lda #0
    sta CIA2_TIMER_A_CONTROL
    // *CIA2_TIMER_B_CONTROL = CIA_TIMER_CONTROL_STOP | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    lda #CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    sta CIA2_TIMER_B_CONTROL
    // *CIA2_TIMER_AB = 0xffffffff
    lda #<$ffffffff
    sta CIA2_TIMER_AB
    lda #>$ffffffff
    sta CIA2_TIMER_AB+1
    lda #<$ffffffff>>$10
    sta CIA2_TIMER_AB+2
    lda #>$ffffffff>>$10
    sta CIA2_TIMER_AB+3
    // *CIA2_TIMER_B_CONTROL = CIA_TIMER_CONTROL_START | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    lda #CIA_TIMER_CONTROL_START|CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    sta CIA2_TIMER_B_CONTROL
    // *CIA2_TIMER_A_CONTROL = CIA_TIMER_CONTROL_START | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_A_COUNT_CYCLES
    lda #CIA_TIMER_CONTROL_START
    sta CIA2_TIMER_A_CONTROL
    // }
    rts
}
init: {
    .label sprites_ptr = SCREEN+$3f8
    // mulf_init()
    jsr mulf_init
    // *SPRITES_ENABLE = %11111111
    lda #$ff
    sta SPRITES_ENABLE
    ldx #0
  __b1:
    // sprites_ptr[i] = (char)(SPRITE/$40)
    lda #SPRITE/$40
    sta sprites_ptr,x
    // SPRITES_COLS[i] = GREEN
    lda #GREEN
    sta SPRITES_COLS,x
    // for(char i: 0..7)
    inx
    cpx #8
    bne __b1
    // }
    rts
}
// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x/4)
mulf_init: {
    // x/2
    .label c = 7
    // Counter used for determining x%2==0
    .label sqr1_hi = 8
    // Fill mulf_sqr1 = f(x) = int(x*x/4): If f(x) = x*x/4 then f(x+1) = f(x) + x/2 + 1/4
    .label sqr = $11
    .label sqr1_lo = 5
    // Decrease or increase x_255 - initially we decrease
    .label sqr2_hi = $f
    .label sqr2_lo = $d
    //Start with g(0)=f(255)
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
    // for(byte* sqr1_lo = mulf_sqr1_lo+1; sqr1_lo!=mulf_sqr1_lo+512; sqr1_lo++)
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
    // for(byte* sqr2_lo = mulf_sqr2_lo; sqr2_lo!=mulf_sqr2_lo+511; sqr2_lo++)
    lda.z sqr2_lo+1
    cmp #>mulf_sqr2_lo+$1ff
    bne __b6
    lda.z sqr2_lo
    cmp #<mulf_sqr2_lo+$1ff
    bne __b6
    // *(mulf_sqr2_lo+511) = *(mulf_sqr1_lo+256)
    // Set the very last value g(511) = f(256)
    lda mulf_sqr1_lo+$100
    sta mulf_sqr2_lo+$1ff
    // *(mulf_sqr2_hi+511) = *(mulf_sqr1_hi+256)
    lda mulf_sqr1_hi+$100
    sta mulf_sqr2_hi+$1ff
    // }
    rts
  __b6:
    // *sqr2_lo = mulf_sqr1_lo[x_255]
    lda mulf_sqr1_lo,x
    ldy #0
    sta (sqr2_lo),y
    // *sqr2_hi++ = mulf_sqr1_hi[x_255]
    lda mulf_sqr1_hi,x
    sta (sqr2_hi),y
    // *sqr2_hi++ = mulf_sqr1_hi[x_255];
    inc.z sqr2_hi
    bne !+
    inc.z sqr2_hi+1
  !:
    // x_255 = x_255 + dir
    txa
    clc
    adc.z dir
    tax
    // if(x_255==0)
    cpx #0
    bne __b8
    lda #1
    sta.z dir
  __b8:
    // for(byte* sqr2_lo = mulf_sqr2_lo; sqr2_lo!=mulf_sqr2_lo+511; sqr2_lo++)
    inc.z sqr2_lo
    bne !+
    inc.z sqr2_lo+1
  !:
    jmp __b5
  __b2:
    // if((++c&1)==0)
    inc.z c
    // ++c&1
    lda #1
    and.z c
    // if((++c&1)==0)
    cmp #0
    bne __b3
    // x_2++;
    inx
    // sqr++;
    inc.z sqr
    bne !+
    inc.z sqr+1
  !:
  __b3:
    // <sqr
    lda.z sqr
    // *sqr1_lo = <sqr
    ldy #0
    sta (sqr1_lo),y
    // >sqr
    lda.z sqr+1
    // *sqr1_hi++ = >sqr
    sta (sqr1_hi),y
    // *sqr1_hi++ = >sqr;
    inc.z sqr1_hi
    bne !+
    inc.z sqr1_hi+1
  !:
    // sqr = sqr + x_2
    txa
    clc
    adc.z sqr
    sta.z sqr
    bcc !+
    inc.z sqr+1
  !:
    // for(byte* sqr1_lo = mulf_sqr1_lo+1; sqr1_lo!=mulf_sqr1_lo+512; sqr1_lo++)
    inc.z sqr1_lo
    bne !+
    inc.z sqr1_lo+1
  !:
    jmp __b1
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

