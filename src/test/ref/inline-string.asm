// Inline Strings in method calls are automatically converted to local constant variables byte st[] = "..."; - generating an ASM .text).
  // Commodore 64 PRG executable file
.file [name="inline-string.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label screen = 2
.segment Code
main: {
    // print(msg1)
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    lda #<msg1
    sta.z print.msg
    lda #>msg1
    sta.z print.msg+1
    jsr print
    // print(msg2)
    lda #<msg2
    sta.z print.msg
    lda #>msg2
    sta.z print.msg+1
    jsr print
    // print("message 3 ")
    lda #<msg
    sta.z print.msg
    lda #>msg
    sta.z print.msg+1
    jsr print
    // }
    rts
  .segment Data
    msg2: .text "message 2 "
    .byte 0
    msg: .text "message 3 "
    .byte 0
}
.segment Code
// void print(__zp(4) char *msg)
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
.segment Data
  msg1: .text "message 1 "
  .byte 0
