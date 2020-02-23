// Inline Strings in assignments
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = 2
main: {
    // print_msg(1)
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    ldx #1
    jsr print_msg
    // print_msg(2)
    ldx #2
    jsr print_msg
    // }
    rts
}
// print_msg(byte register(X) idx)
print_msg: {
    .label msg = 4
    // if(idx==1)
    cpx #1
    beq __b1
    lda #<msg_2
    sta.z msg
    lda #>msg_2
    sta.z msg+1
    jmp __b2
  __b1:
    lda #<msg_1
    sta.z msg
    lda #>msg_1
    sta.z msg+1
  __b2:
    // print(msg)
    jsr print
    // }
    rts
    msg_1: .text "Hello "
    .byte 0
    msg_2: .text "World!"
    .byte 0
}
// print(byte* zp(4) msg)
print: {
    .label msg = 4
  __b1:
    // while(*msg)
    ldy #0
    lda (msg),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // *(screen++) = *(msg++)
    ldy #0
    lda (msg),y
    sta (screen),y
    // *(screen++) = *(msg++);
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inc.z msg
    bne !+
    inc.z msg+1
  !:
    jmp __b1
}
