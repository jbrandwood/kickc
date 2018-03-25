.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d021
  .const GREEN = 5
  .const RED = 2
  .label print_char_cursor = 5
  .label print_line_cursor = 7
  jsr main
main: {
    jsr print_cls
    lda #GREEN
    sta BGCOL
    jsr test_bytes
    jsr test_sbytes
    rts
}
test_sbytes: {
    .const bb = 0
    .const bc = bb+2
    .const bd = bc-4
    .const bf = $ff&-$7f-$7f
    .const be = -bd
    lda #0
    sta assert_sbyte.c
    ldx #bb
    lda #<msg
    sta assert_sbyte.msg
    lda #>msg
    sta assert_sbyte.msg+1
    jsr assert_sbyte
    lda #2
    sta assert_sbyte.c
    ldx #bc
    lda #<msg1
    sta assert_sbyte.msg
    lda #>msg1
    sta assert_sbyte.msg+1
    jsr assert_sbyte
    lda #-2
    sta assert_sbyte.c
    ldx #bd
    lda #<msg2
    sta assert_sbyte.msg
    lda #>msg2
    sta assert_sbyte.msg+1
    jsr assert_sbyte
    lda #2
    sta assert_sbyte.c
    ldx #be
    lda #<msg3
    sta assert_sbyte.msg
    lda #>msg3
    sta assert_sbyte.msg+1
    jsr assert_sbyte
    lda #2
    sta assert_sbyte.c
    ldx #bf
    lda #<msg4
    sta assert_sbyte.msg
    lda #>msg4
    sta assert_sbyte.msg+1
    jsr assert_sbyte
    rts
    msg: .text "0=0@"
    msg1: .text "0+2=2@"
    msg2: .text "0+2-4=-2@"
    msg3: .text "-(0+2-4)=2@"
    msg4: .text "-127-127=2@"
}
assert_sbyte: {
    .label msg = 2
    .label c = 4
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jsr print_str
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    cpx c
    beq b1
    lda #RED
    sta BGCOL
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
  b2:
    jsr print_ln
    rts
  b1:
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    jmp b2
    str: .text " @"
    str1: .text "ok@"
    str2: .text "fail!@"
}
print_str: {
    .label str = 2
  b1:
    ldy #0
    lda (str),y
    cmp #'@'
    bne b2
    rts
  b2:
    ldy #0
    lda (str),y
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    inc str
    bne !+
    inc str+1
  !:
    jmp b1
}
print_ln: {
  b1:
    lda print_line_cursor
    clc
    adc #$28
    sta print_line_cursor
    bcc !+
    inc print_line_cursor+1
  !:
    lda print_line_cursor+1
    cmp print_char_cursor+1
    bcc b1
    bne !+
    lda print_line_cursor
    cmp print_char_cursor
    bcc b1
  !:
    rts
}
test_bytes: {
    .const bb = 0
    .const bc = bb+2
    .const bd = bc-4
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    lda #0
    sta assert_byte.c
    ldx #bb
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #<msg
    sta assert_byte.msg
    lda #>msg
    sta assert_byte.msg+1
    jsr assert_byte
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #2
    sta assert_byte.c
    ldx #bc
    lda #<msg1
    sta assert_byte.msg
    lda #>msg1
    sta assert_byte.msg+1
    jsr assert_byte
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #$fe
    sta assert_byte.c
    ldx #bd
    lda #<msg2
    sta assert_byte.msg
    lda #>msg2
    sta assert_byte.msg+1
    jsr assert_byte
    rts
    msg: .text "0=0@"
    msg1: .text "0+2=2@"
    msg2: .text "0+2-4=254@"
}
assert_byte: {
    .label msg = 2
    .label c = 4
    jsr print_str
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    cpx c
    beq b1
    lda #RED
    sta BGCOL
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
  b2:
    jsr print_ln
    rts
  b1:
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    jmp b2
    str: .text " @"
    str1: .text "ok@"
    str2: .text "fail!@"
}
print_cls: {
    .label sc = 2
    lda #<$400
    sta sc
    lda #>$400
    sta sc+1
  b1:
    lda #' '
    ldy #0
    sta (sc),y
    inc sc
    bne !+
    inc sc+1
  !:
    lda sc+1
    cmp #>$400+$3e8
    bne b1
    lda sc
    cmp #<$400+$3e8
    bne b1
    rts
}
