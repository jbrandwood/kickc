// Setup and run a simple CIA-timer
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
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
  .label SCREEN = $400
main: {
    jsr clock_start
  __b1:
    jsr clock
    jsr print_dword_at
    jmp __b1
}
// Print a dword as HEX at a specific position
// print_dword_at(dword zeropage(9) dw)
print_dword_at: {
    .label dw = 9
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
// print_word_at(word zeropage(2) w, byte* zeropage(4) at)
print_word_at: {
    .label w = 2
    .label at = 4
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
// print_byte_at(byte zeropage(6) b, byte* zeropage(4) at)
print_byte_at: {
    .label b = 6
    .label at = 4
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
    .label return = 9
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
  print_hextab: .text "0123456789abcdef"
