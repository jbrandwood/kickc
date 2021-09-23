// Setup and run a simple CIA-timer
  // Commodore 64 PRG executable file
.file [name="cia-timer-simple.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  /// Timer Control - Start/stop timer (0:stop, 1: start)
  .const CIA_TIMER_CONTROL_START = 1
  /// Timer B Control - Timer counts (00:system cycles, 01: CNT pulses, 10: timer A underflow, 11: time A underflow while CNT is high)
  .const CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A = $40
  .const OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL = $e
  .const OFFSET_STRUCT_MOS6526_CIA_TIMER_B_CONTROL = $f
  /// The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
  /// CIA#2 timer A&B as one single 32-bit value
  .label CIA2_TIMER_AB = $dd04
  .label SCREEN = $400
.segment Code
main: {
    // clock_start()
    // Reset & start the CIA#2 timer A+B
    jsr clock_start
  __b1:
    // clock()
    jsr clock
    // print_ulong_at(clock(), SCREEN)
    jsr print_ulong_at
    jmp __b1
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
// Returns the processor clock time used since the beginning of an implementation defined era (normally the beginning of the program).
// This uses CIA #2 Timer A+B on the C64, and must be initialized using clock_start()
clock: {
    .label return = 9
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
// void print_ulong_at(__zp(9) unsigned long dw, char *at)
print_ulong_at: {
    .label dw = 9
    // print_uint_at(WORD1(dw), at)
    lda.z dw+2
    sta.z print_uint_at.w
    lda.z dw+3
    sta.z print_uint_at.w+1
    lda #<SCREEN
    sta.z print_uint_at.at
    lda #>SCREEN
    sta.z print_uint_at.at+1
    jsr print_uint_at
    // print_uint_at(WORD0(dw), at+4)
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
// void print_uint_at(__zp(7) unsigned int w, __zp(4) char *at)
print_uint_at: {
    .label w = 7
    .label at = 4
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
// Print a char as HEX at a specific position
// void print_uchar_at(__zp(6) char b, __zp(4) char *at)
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
// void print_char_at(__register(X) char ch, __zp(2) char *at)
print_char_at: {
    .label at = 2
    // *(at) = ch
    txa
    ldy #0
    sta (at),y
    // }
    rts
}
.segment Data
  print_hextab: .text "0123456789abcdef"
