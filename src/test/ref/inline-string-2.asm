// Inline Strings in assignments
  // Commodore 64 PRG executable file
.file [name="inline-string-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label screen = 4
.segment Code
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
// void print_msg(__register(X) char idx)
print_msg: {
    .label msg = 2
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
  .segment Data
    msg_1: .text "Hello "
    .byte 0
    msg_2: .text "World!"
    .byte 0
}
.segment Code
// void print(__zp(2) char *msg)
print: {
    .label msg = 2
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
