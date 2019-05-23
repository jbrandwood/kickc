// Inline Strings in assignments
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = 2
main: {
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    ldx #1
    jsr print_msg
    ldx #2
    jsr print_msg
    rts
}
// print_msg(byte register(X) idx)
print_msg: {
    .label msg = 4
    cpx #1
    beq b1
    lda #<msg_2
    sta msg
    lda #>msg_2
    sta msg+1
    jmp b2
  b1:
    lda #<msg_1
    sta msg
    lda #>msg_1
    sta msg+1
  b2:
    jsr print
    rts
    msg_1: .text "Hello @"
    msg_2: .text "World!@"
}
// print(byte* zeropage(4) msg)
print: {
    .label msg = 4
  b1:
    ldy #0
    lda (msg),y
    cmp #'@'
    bne b2
    rts
  b2:
    ldy #0
    lda (msg),y
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inc msg
    bne !+
    inc msg+1
  !:
    jmp b1
}
