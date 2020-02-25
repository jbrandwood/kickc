// Adding a missing word-fragment for Travis Fisher
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const READY_FRAMES = 5
  .label print_char_cursor = 7
  .label print_line_cursor = 5
main: {
    .label i = 2
    lda #0
    sta.z i
    tax
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
  __b1:
    // game_ready()
    jsr game_ready
    // if(game_ready())
    cmp #0
    bne __b3
    jmp __b2
  __b3:
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str_ln("ready!")
    lda #<str
    sta.z print_str_ln.str
    lda #>str
    sta.z print_str_ln.str+1
    jsr print_str_ln
  __b2:
    // for(byte i:0..5)
    inc.z i
    lda #6
    cmp.z i
    bne __b5
    // }
    rts
  __b5:
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    jmp __b1
    str: .text "ready!"
    .byte 0
}
// Print a zero-terminated string followed by a newline
// print_str_ln(byte* zp(3) str)
print_str_ln: {
    .label str = 3
    // print_str(str)
    jsr print_str
    // print_ln()
    jsr print_ln
    // }
    rts
}
// Print a newline
print_ln: {
  __b1:
    // print_line_cursor + $28
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    // while (print_line_cursor<print_char_cursor)
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    // }
    rts
}
// Print a zero-terminated string
// print_str(byte* zp(3) str)
print_str: {
    .label str = 3
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // *(print_char_cursor++) = *(str++)
    ldy #0
    lda (str),y
    sta (print_char_cursor),y
    // *(print_char_cursor++) = *(str++);
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
game_ready: {
    // if (action_count == 0)
    cpx #0
    bne __b1
    ldx #READY_FRAMES
  __b1:
    // print_str_ln("ready")
    lda #<str
    sta.z print_str_ln.str
    lda #>str
    sta.z print_str_ln.str+1
    jsr print_str_ln
    // action_count--;
    dex
    // action_count==0
    lda #1
    cpx #0
    beq !+
    lda #0
  !:
    // }
    rts
    str: .text "ready"
    .byte 0
}
