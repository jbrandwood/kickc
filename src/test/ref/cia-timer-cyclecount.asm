// Counting cycles using a CIA timer
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // Timer Control - Start/stop timer (0:stop, 1: start)
  .const CIA_TIMER_CONTROL_START = 1
  // Timer B Control - Timer counts (00:system cycles, 01: CNT pulses, 10: timer A underflow, 11: time A underflow while CNT is high)
  .const CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A = $40
  // Clock cycles used to start & read the cycle clock by calling clock_start() and clock() once. Can be subtracted when calculating the number of cycles used by a routine.
  // To make precise cycle measurements interrupts and the display must be disabled so neither steals any cycles from the code.
  .const CLOCKS_PER_INIT = $12
  .const OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL = $e
  .const OFFSET_STRUCT_MOS6526_CIA_TIMER_B_CONTROL = $f
  // The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
  // CIA#2 timer A&B as one single 32-bit value
  .label CIA2_TIMER_AB = $dd04
  .label SCREEN = $400
main: {
    .label __1 = 9
    // Calculate the cycle count - 0x12 is the base usage of start/read
    .label cyclecount = 9
  __b1:
    // clock_start()
    // Reset & start the CIA#2 timer A+B
    jsr clock_start
    // asm
    nop
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
    // print_ulong_at(cyclecount, SCREEN)
    // Print cycle count
    jsr print_ulong_at
    jmp __b1
}
// Print a unsigned long as HEX at a specific position
// print_ulong_at(dword zp(9) dw)
print_ulong_at: {
    .label dw = 9
    // print_uint_at(>dw, at)
    lda.z dw+2
    sta.z print_uint_at.w
    lda.z dw+3
    sta.z print_uint_at.w+1
    lda #<SCREEN
    sta.z print_uint_at.at
    lda #>SCREEN
    sta.z print_uint_at.at+1
    jsr print_uint_at
    // print_uint_at(<dw, at+4)
    lda.z dw
    sta.z print_uint_at.w
    lda.z dw+1
    sta.z print_uint_at.w+1
    lda #<SCREEN+4
    sta.z print_uint_at.at
    lda #>SCREEN+4
    sta.z print_uint_at.at+1
    jsr print_uint_at
    // }
    rts
}
// Print a unsigned int as HEX at a specific position
// print_uint_at(word zp(2) w, byte* zp(4) at)
print_uint_at: {
    .label w = 2
    .label at = 4
    // print_uchar_at(>w, at)
    lda.z w+1
    sta.z print_uchar_at.b
    jsr print_uchar_at
    // print_uchar_at(<w, at+2)
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
// Print a char as HEX at a specific position
// print_uchar_at(byte zp(6) b, byte* zp(4) at)
print_uchar_at: {
    .label b = 6
    .label at = 4
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
// print_char_at(byte register(X) ch, byte* zp(7) at)
print_char_at: {
    .label at = 7
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
    .label return = 9
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
  print_hextab: .text "0123456789abcdef"
